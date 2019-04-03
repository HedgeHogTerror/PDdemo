import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls 1.4

import "./ProcessPage"

Page {
    id: page
    property string pageName: "Process Page"

    width: window.width
    height: window.height

    title: qsTr(pageName)

    //TBD:  List Items dynamically generated data...
    ListModel {
        id: directoryModel
        ListElement {
            filename: "Process 1"
            materialname: "unobtanium"
            moldnumber: "42"
            lastsaveddate: "YY/MM/DD HH:MM:SS"
        }
    }

    TableView {
        id: directory
        width: parent.width
        anchors.top: parent.top
        anchors.bottom: moldDBButton.top

        TableViewColumn {
            role: "filename"
            title: "File Name"
            width: 200
        }
        TableViewColumn {
            role: "materialname"
            title: "Material Name"
            width: 100
        }
        TableViewColumn {
            role: "moldnumber"
            title: "Mold Number"
            width: 100
        }
        TableViewColumn {
            role: "lastsaveddate"
            title: "Last saved Date"
            width: 100
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
        id: moldDBButton
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 50
        width: 180
        height: 37
        text: qsTr("Mold/Part Database")
    }

    Button {
        id: materialDBBUtton
        anchors.bottom: parent.bottom
        anchors.left: moldDBButton.left
        anchors.leftMargin: 50
        width: 180
        height: 37
        text: qsTr("Material Database")
    }

    Button {
        id: previewButton
        anchors.bottom: parent.bottom
        anchors.left: materialDBBUtton.left
        anchors.leftMargin: 50
        width: 180
        height: 37
        text: qsTr("Preview Selected Process")
    }

    Button {
        id: loadButton
        anchors.bottom: parent.bottom
        anchors.left: previewButton.left
        anchors.leftMargin: 50
        width: 180
        height: 37
        text: qsTr("Load Selected Process")
    }
}
