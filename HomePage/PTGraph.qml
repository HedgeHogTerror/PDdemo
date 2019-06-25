import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtCharts 2.2

import "../"

Rectangle {

    Label {
        anchors.centerIn: parent
        text: qsTr("Pressure Time Graph")
    }
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    width: parent.width / 2
    height: parent.height / 2
    color: Style.colorPalleteDarker
    Connections {
            target: pressureData
            onWValueChanged: {
                lineSeries1.append(pressureData.wValue.x, pressureData.wValue.y)
                if(lineSeries1.count >= 1000)
                    lineSeries1.clear();
            }
        }

        ChartView {
            id: chartView
            width: parent.width
            height: parent.height
            anchors.fill: parent
            animationOptions: ChartView.NoAnimation
            antialiasing: true
            backgroundColor: Style.colorPalleteDarkest

            ValueAxis {
                id: axisY1
                min: 0
                max: 50

                gridVisible: false
                color: Style.colorPalleteLightest
                labelsColor: Style.colorPalleteLightest
                labelFormat: "%.0f"
                tickCount: 3
            }

            ValueAxis {
                id: axisX
                min: 0
                max: 1000
                gridVisible: false
                color: Style.colorPalleteLightest
                labelsColor: Style.colorPalleteLightest
                labelFormat: "%.0f"
                tickCount: 1
            }

            LineSeries {
                id: lineSeries1
                name: "signal 1"
                color: Style.colorPalleteLightest
                axisX: axisX
                axisY: axisY1
            }
        }

}
