import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import QtCharts 2.2

import "./HomePage"
import "."

Page {
    width: parent.width
    height: parent.height
    font.family: "Arial"
    font.pixelSize: 10
    background: Rectangle {
        color: Style.colorPalleteMedium
    }

    title: qsTr("Home")

    Rectangle {
        id: machineDiagram
        anchors.left: parent.left
        width: parent.width * .2
        height: parent.height
        color: Style.colorPalleteDarker
        Connections {
            target: pressureData
        }
        Rectangle {
            id: topClamp
            height: 50
            width: parent.width * .8
            color: Style.colorPalleteLighter
            anchors.horizontalCenter: parent.horizontalCenter
            y: ( parent.height - 100 ) + pressureData.wValue.y
        }
        Rectangle {
            id: bottomClamp
            height: 50
            width: parent.width * .8
            color: Style.colorPalleteLighter
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    // Machine Settings

    TableView {
        id: machineSettings
        anchors.left: machineDiagram.right
        width: parent.width * .3
        height: parent.height
        horizontalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        TableViewColumn {
            role: "settingName"
            title: ""
            width: machineSettings.width * .6
        }
        TableViewColumn {
            role: "set"
            title: "Set"
            width: machineSettings.width *.2
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
                color: Style.colorPalleteLightest
                elide: styleData.elideMode
                text: styleData.value
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                     settingsPopup.open(styleData.value)
                }
            }
        }
        style: TableViewStyle {
            rowDelegate: Item {
                Rectangle {
                    width: parent.width
                    height: parent.height
                    color: Style.colorPalleteDarkest
                }
            }
        }

    }

    Popup {
       id: settingsPopup
       x: (parent.width - width)/2
       y: (parent.height - height)/2
       width: 400
       height: 100
       background: Rectangle {
           color: Style.colorPalleteLighter
         }

       Text {
           id: name
           text: ""
           anchors.horizontalCenter: settingsPopup.horizontalCenter

       }

       modal: true
       focus: true
       closePolicy: Popup.CloseOnPressOutside | Popup.CloseOnEscape
   }


    // PT Top  SettingsPage
    GridView {
        id: ptSettingsTop
        anchors.right: parent.right
        anchors.top:  parent.top
        width: parent.width * .5
        height: parent.height / 4
        delegate: settingsObject
        cellHeight: height
        cellWidth: width / 5
        model: PTSettingsTopModel {}
    }

    // PT Bottom  SettingsPage
    GridView {
        id: ptSettingsBottom
        anchors.bottom: parent.bottom
        anchors.left: machineSettings.right
        width: parent.width * .4
        height: parent.height / 4
        delegate: settingsObject
        cellHeight: height
        cellWidth: width / 4
        model: PTSettingsBottomModel {}
    }

    Component {
       id: settingsObject
       Rectangle {
           width: parent.width
           height: parent.height
           border.color: Style.colorPalleteDarker
           color: Style.colorPalleteMedium
           MouseArea {
               anchors.fill: parent
               onClicked: {
                    settingsPopup.open()
               }
           }
           Rectangle {
               id: settingsTitleBox
               width: parent.width
               height: parent.height /3
               border.color: Style.colorPalleteDarker
               color: Style.colorPalleteMedium
               Text {
                    text: setting
                    anchors.centerIn: parent
               }
           }
           Rectangle {
               width: parent.width
               height: parent.height * 2/3
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
                   anchors.topMargin: 10
               }
               Text{
                   text: actual
                   anchors.left: actualText.right
                   anchors.top: setText.bottom
                   anchors.leftMargin: 5
                   anchors.topMargin: 10
               }
               Text{
                   text: units
                   anchors.right: parent.right
                   anchors.verticalCenter: parent.verticalCenter
                   anchors.rightMargin: 10
               }
           }

       }

   }


    Button {
        id: saveCurrentSettings
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        text: ""
        Text {
            wrapMode: Text.WordWrap
            width: parent.width - 10
            horizontalAlignment: Text.AlignHCenter
            anchors.centerIn: parent
            id: saveSettingsButton
            text: qsTr("Save Current Settings")
        }
        height: parent.height / 4
        width: parent.width * .1
    }

    // PT live graph
    PTGraph { id: ptGraph }

    Rectangle {
        id: injectionSettingsContainer
        anchors.top: parent.top
        anchors.right: ptGraph.right
        height: parent / 4
        width: parent.width / 3
        color: Style.colorPalleteLightest
        border.color: Style.colorPalleteDarkest
        border.width: 1

        Rectangle {
            id: rect
            width: parent.width
            height: parent.height / 3
            border.color: Style.colorPalleteDarkest
            border.width: 1
            anchors.top: parent.top

            Label {
                text: "Injection"
                anchors.top: parent.top
                anchors.topMargin: 5
                anchors.verticalCenter: parent.verticalCenter
            }
        }

    }
}
