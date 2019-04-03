import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls 1.4

Page {
    id: page
    property string pageName: "Monitoring"
    width: window.width
    height: window.height

    title: qsTr(pageName)

        //TBD:  List Items dynamically generated data...
    ListModel {
        id: monitoringModel
        ListElement {
            timestamp: "YY/MM/DD HH:MM:SS"
            filltime: "?"
            cusion: "?"
            recoverytime: "?"
            peakPSI: "?"
            transferPSI: "?"
            cycletime: "?"
            backpressure: "?"
            packpressure: "?"
            packtime: "?"
        }

    }

    TableView {
        id: monitoring
        width: parent.width
        anchors.top: parent.top
        anchors.bottom: button.top

        TableViewColumn {
            role: "timestamp"
            title: "Time Stamp"
            width: 100
        }
        TableViewColumn {
            role: "filltime"
            title: "Fill Time"
            width: 100
        }
        TableViewColumn {
            role: "cousin"
            title: "Cousin"
            width: 50
        }
        TableViewColumn {
            role: "recoverytime"
            title: "Recovery Time"
            width: 50
        }
        TableViewColumn {
            role: "recoveryposition"
            title: "Recovery Position"
            width: 50
        }
        TableViewColumn {
            role: "peakPSI"
            title: "Peak PSI"
            width: 50
        }
        TableViewColumn {
            role: "transferPSI"
            title: "Transfer PSI"
            width: 50
        }
        TableViewColumn {
            role: "cycletime"
            title: "Cycle Time"
            width: 50
        }
        TableViewColumn {
            role: "backpressure"
            title: "Back Pressure"
            width: 50
        }
        TableViewColumn {
            role: "packpressure"
            title: "Pack Pressure"
            width: 50
        }
        TableViewColumn {
            role: "packtime"
            title: "Pack Time"
            width: 50
        }
        model: monitoringModel
    }

    Button {
        id: button
        width: 180
        height: 37
        text: qsTr("Clear History")
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
    }


}
