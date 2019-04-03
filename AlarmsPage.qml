import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls 1.4

Page {
    id: page
    property string pageName: "Alarms Page"

    width: window.width
    height: window.height

    title: qsTr(pageName)

    //TBD:  List Items dynamically generated data...
    ListModel {
        id: directoryModel
        ListElement {
            alarmmessage: "*Click on message to open window with reason and possible solutions for this alarm message"
            timestamp: "YY/MM/DD HH:MM:SS"
        }
    }

    TableView {
        id: directory
        width: parent.width
        anchors.top: parent.top
        anchors.bottom: search.top

        TableViewColumn {
            role: "timestamp"
            title: "Date/Time Stamp"
            width: 300
        }
        TableViewColumn {
            role: "alarmmessage"
            title: "Alarm Message"
            width: 500
        }
        model: directoryModel
        rowDelegate: Item {
            height: 42
            Rectangle {
                height: parent.height
                width: parent.width
                color: Style.colorPalleteDarkest
            }
        }
    }

    Button {
        id: search
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: 180
        height: 37
        text: qsTr("Search Time Range")
    }

}
