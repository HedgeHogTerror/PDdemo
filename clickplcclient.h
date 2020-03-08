#ifndef CLICKPLCCLIENT_H
#define CLICKPLCCLIENT_H
#include <QTimer>
#include <QModbusTcpClient>
#include <QModbusDataUnit>
#include <QUrl>
#include <QStandardItemModel>
#include "sensorInfo.h"

class QModbusClient;
class QModbusReply;

class ClickPLCClient : public QObject
{
    Q_OBJECT
        //Q_PROPERTY(uint rClampPosition READ rClampPosition NOTIFY rClampPosition)
       // Q_PROPERTY(QPointF wValue READ wValue NOTIFY wValueChanged) //temp
public:
    ClickPLCClient(QObject *parent=Q_NULLPTR);
    ~ClickPLCClient();
    //temp
    /*QPointF wValue() const{
        return m_wValue;
    }*/

    //TBD catelog of sensors to be read
    typedef enum Sensor {
        NOZZLE_TEMPERATURE,
        BARREL_TEMPERATURE,
        CLAMP_POSITION,
        PLUNGER_POSITION
    } Sensor;

    uint rClampPosition() const{
        return m_rClampPosition;
    }

    void init();

    QModbusDataUnit createReadRequest(QModbusDataUnit::RegisterType type, quint16 address, quint16 values) const;
    QModbusDataUnit createWriteRequest() const;

private slots:
    // TBD
    void connectLoop();

    bool write_value( Sensor setting, float value );
    
    void start_reading();
    void read_loop();
    void readReady();

    void startWriting();
    void writeLoop();

private:

    std::map<Sensor, std::shared_ptr<SensorInfo>> m_sensorParameters;
    QModbusClient *m_modbusDevice;
    QTimer * m_connectionTimer;
    QTimer * m_readTimer;
    QTimer * m_writeTimer;

    uint m_writeValue;

    // read values
    uint m_rClampPosition;
};

#endif // CLICKPLCCLIENT_H
