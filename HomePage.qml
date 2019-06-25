import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import QtCharts 2.2
import QtQuick.LocalStorage 2.0
import "./Scripts/ProcessDB.js" as DB

import "./HomePage"
import "."

Page {
    id: homePage
    width: parent.width
    height: parent.height
    font.family: "Arial"
    font.pixelSize: 10
    background: Rectangle {
        width: parent.width
        height: parent.height
        color: Style.colorPalleteMedium
    }

    title: qsTr("Home")

    // Machine Diagram

    MachineDiagram {
        id: machineDiagram
    }

    // Machine Settings

    TableView {
        id: machineSettings
        anchors.left: machineDiagram.right
        width: parent.width * .3
        height: parent.height

        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        TableViewColumn {
            role: "settingName"
            title: ""
            width: machineSettings.width * .65
        }
        TableViewColumn {
            role: "set"
            title: "Set"
            width: machineSettings.width *.15
        }
        TableViewColumn {
            role: "actual"
            title: "Actual"
            width: machineSettings.width *.2
        }

        model: MachineSettingsModel {}
        itemDelegate: Item {
            height: parent.height/ parent.rowCount
            Text {
                anchors.verticalCenter: parent.verticalCenter
                color: "black"
                elide: styleData.elideMode
                text: styleData.value
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    settingsPopup.currentValue = machineSettings.model.get(styleData.row).set;
                    settingsPopup.popupTitle = machineSettings.model.get(styleData.row).settingName;
                    settingsPopup.settingIndex = styleData.row;
                    settingsPopup.open();
                }
            }
        }
        rowDelegate: Item {
            height: 42
            Rectangle {
                height: parent.height
                width: parent.width
                color: (styleData.row % 2) ? Style.colorPalleteMedium : Style.colorPalleteLighter
            }
        }
    }

    // PT Top  SettingsPage
    Rectangle {
        color: Style.colorPalleteDarker
        anchors.right: parent.right
        anchors.top:  parent.top
        width: parent.width * .5
        height: parent.height / 4
        GridView {
            id: ptSettingsTop
            anchors.fill: parent
            delegate: settingsObject
            cellHeight: homePage.height / 4
            cellWidth: homePage.width * .2 * .5
            highlightFollowsCurrentItem: true
            highlight: Rectangle { color: Style.colorPalleteLighter; radius: 5 }
            model: PTSettingsTopModel {}
        }
    }

    // PT Bottom  SettingsPage
    Rectangle {
        color: Style.colorPalleteDarker
        anchors.bottom: parent.bottom
        anchors.left: machineSettings.right
        anchors.right: saveCurrentSettings.left
        width: parent.width * .4
        height: parent.height / 4
        GridView {
            id: ptSettingsBottom
            anchors.fill: parent
            delegate: settingsObject
            cellHeight: homePage.height / 4
            cellWidth: homePage.width * .2 * .5
            highlightFollowsCurrentItem: true
            highlight: Rectangle { color: Style.colorPalleteLighter; radius: 5 }
            model: PTSettingsBottomModel {}
        }
    }

    //

    Component {
       id: settingsObject
       Rectangle {
           id: settingsContainer
           height: ptSettingsTop.cellHeight
           width: ptSettingsTop.cellWidth
           color: Style.colorPalleteDarker
           MouseArea {
               anchors.fill: parent
               onClicked: {
                   settingsPopup.currentValue = set;
                   settingsPopup.popupTitle = settingName;
                   settingsPopup.settingIndex = index;
                   settingsPopup.open();
               }
           }
           Rectangle {
               id: settingsTitleBox
               height: ptSettingsTop.cellHeight / 2
               width: ptSettingsTop.cellWidth
               radius: 5
               border.color: Style.colorPalleteDarker
               color: Style.colorPalleteMedium
               Text {
                    text: settingName
                    width: 5
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.leftMargin: 5
                    anchors.topMargin: 10
                    wrapMode: Text.WordWrap
               }
               Text{
                   text: units
                   anchors.right: parent.right
                   anchors.verticalCenter: parent.verticalCenter
                   anchors.rightMargin: 5
               }
           }
           Rectangle {
               id: settingsValueBox
               height: ptSettingsTop.cellHeight / 2
               width: ptSettingsTop.cellWidth
               radius: 5
               border.color: Style.colorPalleteDarker
               color: Style.colorPalleteMedium
               anchors.top: settingsTitleBox.bottom
               Text{
                   id: setText
                   text: "Set:"
                   anchors.left: parent.left
                   anchors.top: parent.top
                   anchors.leftMargin: 5
                   anchors.topMargin: 10
               }
               Text{
                   text: set.toString()
                   anchors.left: setText.right
                   anchors.top: parent.top
                   anchors.leftMargin: 5
                   anchors.topMargin: 10
               }
               Text{
                   id: actualText
                   text: "Actual:"
                   anchors.left: parent.left
                   anchors.top: setText.bottom
                   anchors.leftMargin: 5
                   anchors.topMargin: 5
               }
               Text{
                   text: actual
                   anchors.left: actualText.right
                   anchors.top: setText.bottom
                   anchors.leftMargin: 5
                   anchors.topMargin: 5
               }
           }

       }

   }

    Button {
        id: saveCurrentSettings
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        height: parent.height / 4
        width: parent.width * .1
        text: ""
        Text {
            wrapMode: Text.WordWrap
            width: parent.width - 10
            horizontalAlignment: Text.AlignHCenter
            anchors.centerIn: parent
            id: saveSettingsButton
            text: qsTr("Save Current Settings")
        }
        onClicked: {
            saveProcessPopup.open()
        }
    }


    // PT live graph
    PTGraph { id: ptGraph }

    SettingsPopup {
        id: settingsPopup
        popupTitle: ""
        currentValue: 0
    }

    SaveProcessPopup {
        id: saveProcessPopup
    }

    Component.onCompleted: {
        DB.dbInit()
    }
    Component.onDestruction: {
        //remeber stuff
    }
}
