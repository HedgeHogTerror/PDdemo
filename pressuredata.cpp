#include "pressuredata.h"
#include <QtMath>

void PressureData::wTimeout(){
    if ( m_wValue.x() >= 1000) m_wValue.setX(0);

    m_wValue.setX(m_wValue.x()+1);
#ifdef __arm__
    int val = i2cReadByte(m_i2cHandle);
#else
    double val = qSin( qRadiansToDegrees(m_wValue.x() / 300));
#endif
    //if (val > 0) fprintf(stderr, val + "\n");
    m_wValue.setY(val);
    emit wValueChanged();
}

PressureData::PressureData(QObject *parent):QObject(parent){
    m_wTimer = new QTimer(this);
    m_wTimer->setInterval(1);
    connect(m_wTimer, &QTimer::timeout, this, &PressureData::wTimeout);

#ifdef __arm__
    m_i2cHandle = i2cOpen(1, 0x10, 0);
#endif

    m_wTimer->start();
}
