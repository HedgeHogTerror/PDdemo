import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls 1.4

Page {
    id: page
    property string pageName: "Part Count Page"

    width: window.width
    height: window.height

    title: qsTr(pageName)

    //TBD:  List Items dynamically generated data...
    ListModel {
        id: directoryModel
        ListElement {
            batchname: "Batch Cycle"
            good: "0"
            bad: "0"
            currenttotal: "0"
            targettotal: "0"
        }
        ListElement {
            batchname: "Batch Parts"
            good: "0"
            bad: "0"
            currenttotal: "0"
            targettotal: "0"
        }
    }

    TableView {
        id: directory
        width: parent.width
        anchors.bottom: setCavitation.top
        anchors.top: parent.top

        TableViewColumn {
            role: "batchname"
            title: ""
            width: 200
        }
        TableViewColumn {
            role: "good"
            title: "Good"
            width: 200
        }
        TableViewColumn {
            role: "bad"
            title: "Bad"
            width: 200
        }
        TableViewColumn {
            role: "currenttotal"
            title: "Current Total"
            width: 200
        }
        TableViewColumn {
            role: "targettotal"
            title: "Target Total"
            width: 200
        }
        model: directoryModel
    }

    Button {
        id: setCavitation
        anchors.bottom: parent.bottom
        anchors.right: setBatchQuantity.left
        anchors.rightMargin: 50
        width: 180
        height: 37
        text: qsTr("Set Cavitation")
    }
    Button {
        id: setBatchQuantity
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.leftMargin: 50
        width: 180
        height: 37
        text: qsTr("Set Batch Quantity")
    }
    Button {
        id: clearBatch
        anchors.bottom: parent.bottom
        anchors.left: setBatchQuantity.left
        anchors.leftMargin: 50
        width: 180
        height: 37
        text: qsTr("Clear Batch")
    }

}
