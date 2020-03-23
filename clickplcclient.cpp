#include "clickplcclient.h"
#include<QDebug>
#include <math.h>
#include <string.h>

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
//    m_readTimer = new QTimer(this);
//    m_readTimer->setInterval(50);
//    connect(m_readTimer, SIGNAL(timeout()), this, SLOT(read_loop()));

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
            m_modbusDevice->setTimeout(250);
            m_modbusDevice->setNumberOfRetries(10);

            m_connectionTimer->start();
        }
    }
    auto clampPosition = std::make_shared<SensorInfo>( "Clamp Position", holding_register, 28682, 2);
    m_sensorParameters.insert( std::pair<Sensor, std::shared_ptr<SensorInfo>>(CLAMP_POSITION,clampPosition) );
    auto plungerPosition = std::make_shared<SensorInfo>( "Plunger Position", holding_register, 28680, 2);
    m_sensorParameters.insert( std::pair<Sensor, std::shared_ptr<SensorInfo>>(PLUNGER_POSITION,plungerPosition) );
    auto clampPressure =std::make_shared<SensorInfo>( "Clamp Pressure", holding_register, 28674, 2);
    m_sensorParameters.insert( std::pair<Sensor, std::shared_ptr<SensorInfo>>(CLAMP_PRESSURE,clampPressure) );
    auto injectionPressure = std::make_shared<SensorInfo>( "Injection Pressure", holding_register, 28672, 2);
    m_sensorParameters.insert( std::pair<Sensor, std::shared_ptr<SensorInfo>>(INJECTION_PRESSURE,injectionPressure) );
    auto hydraulicOilTemperature = std::make_shared<SensorInfo>( "Hydraulic Oil Temperature", holding_register, 28688, 2);
    m_sensorParameters.insert( std::pair<Sensor, std::shared_ptr<SensorInfo>>(HYDRAULILC_OIL_TEMPERATURE,hydraulicOilTemperature) );
//    auto meteringTemperature = std::make_shared<SensorInfo>(( "Metering Temperature", holding_register, 0, 2);
//    m_sensorParameters.insert( std::pair<Sensor, std::shared_ptr<SensorInfo>>(HYDRAULILC_OIL_TEMPERATURE,hydraulicOilTemperature) );
//    auto nozzleTemperature = std::make_shared<SensorInfo>(( "Nozzle Temperature", holding_register, 1, 2);
//    m_sensorParameters.insert( std::pair<Sensor, std::shared_ptr<SensorInfo>>(HYDRAULILC_OIL_TEMPERATURE,hydraulicOilTemperature) );
//    auto injectionTemperature = std::make_shared<SensorInfo>(( "Injection Temperature", holding_register, 2, 2);
//    m_sensorParameters.insert( std::pair<Sensor, std::shared_ptr<SensorInfo>>(HYDRAULILC_OIL_TEMPERATURE,hydraulicOilTemperature) );

}

void ClickPLCClient::connectLoop(){
    m_modbusDevice->connectDevice();
    qDebug() << "attempting to connect..." << endl;
    if( m_modbusDevice->state() == QModbusDevice::ConnectedState ) {
        m_connectionTimer->stop();
        qDebug() << "CONNECTED!" << endl;
        // 1 sec delay
        for ( auto const& x : m_sensorParameters)
        {
            QTimer::singleShot(1000,this, [this,x]{
                start_reading(x.first);
            });
        }
        //QTimer::singleShot(2500,this,SLOT( startWriting() ));
    }
}

//void ClickPLCClient::start_reading(){
//    m_readTimer->start();
//    qCritical() << "reading started" << endl;
//}

QModbusDataUnit ClickPLCClient::createReadRequest(QModbusDataUnit::RegisterType type, quint16 address, quint16 values) const
{
    return QModbusDataUnit(type, address, values);
}


/*
 * Starts read loop, sends read requests for each sensor in the catelogue
 *
 */
void ClickPLCClient::start_reading(Sensor sensor ){
    if (!m_modbusDevice) { qCritical() << "no device" << endl; return; }
    else qCritical() << "reading started" << endl;
    // read through all sensors once
    auto x = m_sensorParameters[sensor];
    auto *reply = m_modbusDevice->sendReadRequest(createReadRequest(x->getRegisterType(),
                        x->getStartModBusAddress(), x->getNumRegisters()), 2);
    if (reply) {
//                qInfo() << "reply received for:" <<  x.second->getName() << endl;

        connect(reply, &QModbusReply::finished, this, &ClickPLCClient::readReady);
        //connect(reply, &QModbusReply::finished, this, &MainWindow::readReady);
        // TBD connect reply to Settings UI
    } else {
        qCritical() << "read error: " << m_modbusDevice->errorString() << endl;
        //statusBar()->showMessage(tr("Read error: ") + modbusDevice->errorString(), 5000 b);
    }
}

void ClickPLCClient::readReady(){
    auto reply = qobject_cast<QModbusReply *>( sender() );
    if (!reply)
        return;

    const QModbusDataUnit unit = reply->result();
    bool ok;
    QString one;
    QString two;

    switch ( reply->error() ) {
        case QModbusDevice::ProtocolError :
            qCritical() << "protocol error" << reply->errorString() << endl;
            break;
        case QModbusDevice::ReadError:
            qCritical() << "read error" << reply->errorString() << endl;
            break;
        case QModbusDevice::ConnectionError:
            qCritical() << "connection error" << reply->errorString() << endl;
            break;
        case QModbusDevice::TimeoutError:
            qCritical() << "timeout error" << reply->errorString() << endl;
            break;
        case QModbusDevice::ReplyAbortedError:
            qCritical() << "aborted error" << reply->errorString() << endl;
        break;
        case QModbusDevice::UnknownError:
            qCritical() << "unknown error" << reply->errorString() << endl;
            break;
        case QModbusDevice::NoError:
            QString one = QString::number( unit.value(0), unit.registerType() <= QModbusDataUnit::Coils ? 10 : 16 );
            QString two = QString::number( unit.value(1), unit.registerType() <= QModbusDataUnit::Coils ? 10 : 16 );
            one = QString(4 - one.length(), QChar('0')).append(one); // prefill leading 0's
            QString combined = two.append(one);
            float reading = toFloat(combined, true);

            // cutoff to 2 digits
            QString cutoff = QString::number(reading, 'f', 2);
            //reading = toFloat(cutoff, true);
            // read address to find sensor type
            switch ( unit.startAddress() ) {
                case 28682 :
                    m_clampPosition = reading;
                    emit clampPositionChanged();
                    QTimer::singleShot(100,this, [this,unit]{
                        read_loop(unit.registerType(), unit.startAddress(), unit.valueCount(), 2 );
                    });
                    break;
                case 28680 :
                    m_plungerPosition = reading;
                    emit plungerPositionChanged();
                    QTimer::singleShot(100,this, [this,unit]{
                        read_loop(unit.registerType(), unit.startAddress(), unit.valueCount(), 2 );
                    });                    break;
                case 28672 :
                    m_injectionPressure = reading;
                    emit injectionPressureChanged();
                    QTimer::singleShot(100,this, [this,unit]{
                        read_loop(unit.registerType(), unit.startAddress(), unit.valueCount(), 2 );
                    });                    break;
                case 28674 :
                    m_clampPressure = reading;
                    emit clampPressureChanged();
                    QTimer::singleShot(100,this, [this,unit]{
                        read_loop(unit.registerType(), unit.startAddress(), unit.valueCount(), 2 );
                    });                     break;
                case 28688 :
                    m_hydraulicOilTemperature = reading;
                    emit hydraulicOilTemperatureChanged();
                    QTimer::singleShot(100,this, [this,unit]{
                        read_loop(unit.registerType(), unit.startAddress(), unit.valueCount(), 2 );
                    });                     break;
            }
//            qInfo() << "readAddress:" << unit.startAddress() << "one" << one <<
//                       "two" << two <<
//                       "combined reading" << reading <<
//                       "# values:" << unit.valueCount() << endl;
            break;
    }

    reply->deleteLater();
}

void ClickPLCClient::read_loop(QModbusDataUnit::RegisterType type, quint16 address, quint16 values, int serverAddress ) {


    auto *reply = m_modbusDevice->sendReadRequest(createReadRequest(type,
                        address, values), serverAddress);

    if (reply) {
        connect(reply, &QModbusReply::finished, this, &ClickPLCClient::readReady);
    } else {
        qCritical() << "read error: " << m_modbusDevice->errorString() << endl;
    }
}


void ClickPLCClient::startWriting(){
    m_writeTimer->start();
}

QModbusDataUnit ClickPLCClient::createWriteRequest() const
{
    const auto holding_register = static_cast<QModbusDataUnit::RegisterType> (4);

    return QModbusDataUnit(holding_register, 2, 1);
}

void ClickPLCClient::writeLoop( QModbusDataUnit writeUnit ){
    if (!m_modbusDevice)
        return;
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

void ClickPLCClient::setMeteringTemperature( quint16 temperature) {
    QModbusDataUnit writeUnit = QModbusDataUnit(holding_register, 2, 2);
    writeUnit.setValue(0, temperature);
}

void ClickPLCClient::setNozzleTemperature( quint16 temperature) {
    QModbusDataUnit writeUnit = QModbusDataUnit(holding_register, 0, 2);
    writeUnit.setValue(0, temperature);
}


void ClickPLCClient::setInjectionTemperature( quint16 temperature) {
    QModbusDataUnit writeUnit = QModbusDataUnit(holding_register, 1, 2);
    writeUnit.setValue(0, temperature);
}


ClickPLCClient::~ClickPLCClient()
{
    if (m_modbusDevice)
            m_modbusDevice->disconnectDevice();
        delete m_modbusDevice;
}
