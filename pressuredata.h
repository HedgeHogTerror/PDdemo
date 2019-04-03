#ifndef PRESSUREDATA_H
#define PRESSUREDATA_H

#include <QObject>
#include <QPointF>
#include <QTimer>

class PressureData : public QObject
{
    Q_OBJECT
        Q_PROPERTY(QPointF wValue READ wValue NOTIFY wValueChanged)

    public:
        PressureData(QObject *parent=Q_NULLPTR);
        QPointF wValue() const{
            return m_wValue;
        }
    signals:
        void wValueChanged();
    private slots:
        void wTimeout();
    private:
        QTimer * m_wTimer;
        QPointF m_wValue;
};

#endif // PRESSUREDATA_H
