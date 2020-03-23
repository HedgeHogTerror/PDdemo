#ifndef SENSOR_INFO_H
#define SENSOR_INFO_H
#include <QStandardItemModel>
#include <QModbusDataUnit>

class SensorInfo
{
public:
    SensorInfo(QString n, QModbusDataUnit::RegisterType rT, quint16 s = 0, quint16 nR = 0) {
        m_name = n;
        m_registerType = rT;
        m_startModBusAddress = s;
        m_numRegisters = nR;
    }
    QString getName(){
        return m_name;
    }
    QModbusDataUnit::RegisterType getRegisterType(){
        return m_registerType;
    }
    quint16 getStartModBusAddress(){
        return m_startModBusAddress;
    }
    quint16 getNumRegisters(){
        return m_numRegisters;
    }

    ~SensorInfo(){}

private:
    QString m_name;
    QModbusDataUnit::RegisterType m_registerType;
    quint16 m_startModBusAddress;
    quint16 m_numRegisters;
};

#endif // SENSOR_INFO_H
