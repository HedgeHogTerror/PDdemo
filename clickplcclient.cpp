#include "clickplcclient.h"
#include<QDebug>

const auto holding_register = static_cast<QModbusDataUnit::RegisterType> (4);
const auto input_register = static_cast<QModbusDataUnit::RegisterType> (3);

static quint32 toUint(const QByteArray &data, bool bigEndian)
{
    if (data.size() != 4)
        return 0;

    quint32 word = 0;

    if (bigEndian) {
        word = quint32((quint8(data.at(0)) << 24) |
                       (quint8(data.at(1)) << 16) |
                       (quint8(data.at(2)) <<  8) |
                       (quint8(data.at(3)) <<  0));
    } else {
        word = quint32((quint8(data.at(0)) <<  0) |
                       (quint8(data.at(1)) <<  8) |
                       (quint8(data.at(2)) << 16) |
                       (quint8(data.at(3)) << 24));

    }
    return word;
}

static float toFloat(const QString &data, bool bigEndian)
{
    const QByteArray ba = QByteArray::fromHex(data.toLatin1());
    quint32 word = toUint(ba, bigEndian);

    const float *f = reinterpret_cast<const float *>(&word);

    return *f;
}

ClickPLCClient::ClickPLCClient(QObject *parent):QObject(parent),m_modbusDevice(nullptr),m_writeValue(1000)
{
    init(); //uncomment to init


}

void ClickPLCClient::init(){
    m_modbusDevice = new QModbusTcpClient(this);

    // connection looper
    m_connectionTimer = new QTimer(this);
    m_connectionTimer->setInterval(500);
    connect(m_connectionTimer, SIGNAL(timeout()), this, SLOT( connectLoop() ));

    // temp read test
    m_readTimer = new QTimer(this);
    m_readTimer->setInterval(100);
    connect(m_readTimer, SIGNAL(timeout()), this, SLOT(read_loop()));

    // temp write test
    m_writeTimer = new QTimer(this);
    m_writeTimer->setInterval(1000);
    connect(m_writeTimer, SIGNAL(timeout()), this, SLOT(writeLoop()));

    // setup error callback
    connect(m_modbusDevice, &QModbusClient::errorOccurred, [this](QModbusDevice::Error) {
        QString error = m_modbusDevice->errorString();
        qCritical() << "Error callback: " << error << endl;
    });

    if (!m_modbusDevice) qCritical() << "could not create the modbus device object" << endl;
    else {
        if (m_modbusDevice->state() != QModbusDevice::ConnectedState) {
            m_modbusDevice->setConnectionParameter(QModbusDevice::NetworkPortParameter, 502);
            m_modbusDevice->setConnectionParameter(QModbusDevice::NetworkAddressParameter, "169.254.1.10");
            m_modbusDevice->setTimeout(50);
            m_modbusDevice->setNumberOfRetries(10);

            m_connectionTimer->start();
        }
    }
    auto clampPosition = new SensorInfo( "Clamp Position", holding_register, 28682, 2);
    m_sensorParameters.insert( std::pair<Sensor, std::shared_ptr<SensorInfo>>(CLAMP_POSITION,clampPosition) );
    auto plungerPosition = new SensorInfo( "Plunger Position", holding_register, 28680, 2);
    m_sensorParameters.insert( std::pair<Sensor, std::shared_ptr<SensorInfo>>(PLUNGER_POSITION,plungerPosition) );
}

void ClickPLCClient::connectLoop(){
    m_modbusDevice->connectDevice();
    qDebug() << "attempting to connect..." << endl;
    if( m_modbusDevice->state() == QModbusDevice::ConnectedState ) {
        m_connectionTimer->stop();
        qDebug() << "CONNECTED!" << endl;
        // 1 sec delay
        QTimer::singleShot(1000,this,SLOT( start_reading() ));
        //QTimer::singleShot(2500,this,SLOT( startWriting() ));
    }
}

void ClickPLCClient::start_reading(){
    m_readTimer->start();
    qCritical() << "reading started" << endl;
}

QModbusDataUnit ClickPLCClient::createReadRequest(QModbusDataUnit::RegisterType type, quint16 address, quint16 values) const
{
    return QModbusDataUnit(type, address, values);
}


/*
 * Starts read loop, sends read requests for each sensor in the catelogue
 *
 */
void ClickPLCClient::read_loop(){
    if (!m_modbusDevice) return;

    // read through all sensors once
    for ( auto const& x : m_sensorParameters)
    {
        auto *reply = m_modbusDevice->sendReadRequest(createReadRequest(x.second->getRegisterType(),
                            x.second->getStartModBusAddress(), x.second->getNumRegisters()), 2);

            if (reply) {
                qInfo() << "reply received for:" <<  x.second->getName() << endl;

                connect(reply, &QModbusReply::finished, this, &ClickPLCClient::readReady);
                //connect(reply, &QModbusReply::finished, this, &MainWindow::readReady);
                // TBD connect reply to Settings UI
            } else {
                qCritical() << "read error: " << m_modbusDevice->errorString() << endl;
                //statusBar()->showMessage(tr("Read error: ") + modbusDevice->errorString(), 5000 b);
            }
    }
}

void ClickPLCClient::readReady(){
    auto reply = qobject_cast<QModbusReply *>( sender() );
    if (!reply)
        return;

    const QModbusDataUnit unit = reply->result();
    
    if (reply->error() == QModbusDevice::NoError) {
        bool ok;
        QString one = QString::number( unit.value(0), unit.registerType() <= QModbusDataUnit::Coils ? 10 : 16 );
        QString two = QString::number( unit.value(1), unit.registerType() <= QModbusDataUnit::Coils ? 10 : 16 );
        QString combined = two.append(one);
        float reading = toFloat(combined, true);


        //int result = (reading.toInt(&ok, 16) - 1054935370)/1000000;
        // 3ee1094a minimum clamp 42831369 maximum clamp
       // QString message = ok ? QString::number(reading) : "read not ok";
        qInfo() << "readAddress:" << unit.startAddress() << "one" << one <<
                   "two" << two <<
                   "combined reading" << reading <<
                   "# values:" << unit.valueCount() << endl;

    } else if (reply->error() == QModbusDevice::ProtocolError) {
        qCritical() << "protocol error" << reply->errorString() << endl;
    } else qCritical() << "unknown error"  << endl;

    reply->deleteLater();
}



void ClickPLCClient::startWriting(){
    m_writeTimer->start();
}

QModbusDataUnit ClickPLCClient::createWriteRequest() const
{
    const auto holding_register = static_cast<QModbusDataUnit::RegisterType> (4);

    return QModbusDataUnit(holding_register, 2, 1);
}

void ClickPLCClient::writeLoop(){
    if (!m_modbusDevice)
        return;

    QModbusDataUnit writeUnit = createWriteRequest();

    //QModbusDataUnit::RegisterType register = writeUnit.registerType();
    for (uint i = 0; i < writeUnit.valueCount(); i++) {
        /*if (register == QModbusDataUnit::Coils)
            writeUnit.setValue(i, writeModel->m_coils[i + writeUnit.startAddress()]);
        else*/
        writeUnit.setValue(i, m_writeValue );
        m_writeValue += 1;
        //if (m_writeValue < 100) m_writeValue += 1;
        //else m_writeValue = 0;
    }

    if (auto *reply = m_modbusDevice->sendWriteRequest(writeUnit, 2)) {
        if (!reply->isFinished()) {
            connect(reply, &QModbusReply::finished, this, [this, reply]() {
                if (reply->error() == QModbusDevice::ProtocolError) {
                    qCritical() << "Write response error:" << reply->errorString() << endl;
                } else if (reply->error() != QModbusDevice::NoError) {
                    qCritical() << "Write response error:" << reply->errorString() << endl;
                } else {
                    qInfo() << "wroteAddress" << endl;

                }
                reply->deleteLater();
            });
        } else delete reply;
    } else {
        qCritical() << "Write error:" << m_modbusDevice->errorString() << endl;
    }
}

bool ClickPLCClient::write_value( Sensor setting, float value ) {
    if (!m_modbusDevice) return false;

    return true;
}



ClickPLCClient::~ClickPLCClient()
{
    if (m_modbusDevice)
            m_modbusDevice->disconnectDevice();
        delete m_modbusDevice;
}
