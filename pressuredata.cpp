#include "pressuredata.h"
#include <QtMath>

void PressureData::wTimeout(){
    if ( m_wValue.x() >= 1000) m_wValue.setX(0);

    m_wValue.setX(m_wValue.x()+1);
    double val = qSin( qRadiansToDegrees(m_wValue.x() / 300));
    m_wValue.setY(val);
    emit wValueChanged();
}

PressureData::PressureData(QObject *parent):QObject(parent){
    m_wTimer = new QTimer(this);
    m_wTimer->setInterval(10);
    connect(m_wTimer, &QTimer::timeout, this, &PressureData::wTimeout);
    m_wTimer->start();
}
