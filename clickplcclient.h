#ifndef CLICKPLCCLIENT_H
#define CLICKPLCCLIENT_H
#include <QTimer>
#include <QModbusTcpClient>
#include <QModbusDataUnit>
#include <QUrl>
#include <QObject>
#include <QStandardItemModel>
#include "sensorInfo.h"
#include <memory>
#include <map>

class QModbusClient;
class QModbusReply;

//class SensorUpdateMessage : public QObject
//{
//    Q_OBJECT
//    Q_PROPERTY(QString sensorName READ name WRITE setSensorName)
//    Q_PROPERTY(float value READ value WRITE setValue)

//public:
//    QString m_sensorName;
//    float m_value;
//    float m_setValue;
//};

class ClickPLCClient : public QObject
{
    Q_OBJECT
    Q_PROPERTY(float plungerPosition READ plungerPosition NOTIFY plungerPositionChanged )
    Q_PROPERTY(float injectionPressure READ injectionPressure NOTIFY injectionPressureChanged )

    Q_PROPERTY(float clampPosition READ clampPosition NOTIFY clampPositionChanged )
    Q_PROPERTY(float clampPressure READ clampPressure NOTIFY clampPressureChanged )

    Q_PROPERTY(float hydraulicOilTemperature READ hydraulicOilTemperature NOTIFY hydraulicOilTemperatureChanged )

    Q_PROPERTY(float meteringTemperature READ meteringTemperature NOTIFY meteringTemperatureChanged )
    Q_PROPERTY(float injectionTemperature READ injectionTemperature NOTIFY injectionTemperatureChanged )
    Q_PROPERTY(float nozzleTemperature READ nozzleTemperature NOTIFY nozzleTemperatureChanged )


    //Q_PROPERTY(SensorUpdateMessage* sensorUpdateMessage READ sensorUpdateMessage NOTIFY wValueChanged)
public:
    ClickPLCClient(QObject *parent=Q_NULLPTR);
    ~ClickPLCClient();

    float plungerPosition() const{
        return m_plungerPosition;
    }
    float clampPosition() const{
        return m_clampPosition;
    }
    float injectionPressure() const{
        return m_injectionPressure;
    }
    float clampPressure() const{
        return m_clampPressure;
    }
    float hydraulicOilTemperature() const{
        return m_hydraulicOilTemperature;
    }
    float meteringTemperature() const{
        return m_meteringTemperature;
    }
    float injectionTemperature() const{
        return m_injectionTemperature;
    }
    float nozzleTemperature() const{
        return m_nozzleTemperature;
    }
    Q_INVOKABLE void setMeteringTemperature( quint16 temperature);
    Q_INVOKABLE void setInjectionTemperature( quint16 temperature);
    Q_INVOKABLE void setNozzleTemperature( quint16 temperature);


    //TBD catelog of sensors to be read
    typedef enum Sensor {
        NOZZLE_TEMPERATURE,
        BARREL_TEMPERATURE,
        METERING_TEMPERATURE,
        CLAMP_POSITION,
        PLUNGER_POSITION,
        CLAMP_PRESSURE,
        INJECTION_PRESSURE,
        HYDRAULILC_OIL_TEMPERATURE
    } Sensor;

    void init();

    QModbusDataUnit createReadRequest(QModbusDataUnit::RegisterType type, quint16 address, quint16 values) const;
    QModbusDataUnit createWriteRequest() const;
    signals:
    void plungerPositionChanged();
    void clampPositionChanged();
    void injectionPressureChanged();
    void clampPressureChanged();
    void hydraulicOilTemperatureChanged();
    void meteringTemperatureChanged();
    void nozzleTemperatureChanged();
    void injectionTemperatureChanged();

    private slots:
    // TBD
    void connectLoop();
    void start_reading( Sensor setting );
    void read_loop(QModbusDataUnit::RegisterType type, quint16 address, quint16 values, int delay);
    
    void readReady();

    void startWriting();
    void writeLoop(QModbusDataUnit writeUnit );

private:

    std::map<Sensor, std::shared_ptr<SensorInfo>> m_sensorParameters;
    QModbusClient *m_modbusDevice;
    QTimer * m_connectionTimer;
    QTimer * m_readTimer;
    QTimer * m_writeTimer;

    uint m_writeValue;

    // read values
    float m_clampPosition;
    float m_plungerPosition;
    float m_clampPressure;
    float m_injectionPressure;
    float m_hydraulicOilTemperature;
    float m_meteringTemperature;
    float m_injectionTemperature;
    float m_nozzleTemperature;

};

#endif // CLICKPLCCLIENT_H
