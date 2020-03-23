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
import QtQuick.Controls.Material 2.1


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
    Connections {
        target: plcClient
        onMeteringTemperatureChanged: {
            currentMachineSettings.get(0).actual = plcClient.meteringTemperature.toFixed(2);
        }
        onNozzleTemperatureChanged: {
            currentMachineSettings.get(1).actual = plcClient.nozzleTemperature.toFixed(2);
        }
        onInjectionTemperatureChanged: {
            currentMachineSettings.get(2).actual = plcClient.injectionTemperature.toFixed(2);
        }
        onHydraulicOilTemperatureChanged: {
            currentMachineSettings.get(3).actual = plcClient.hydraulicOilTemperature;
        }
        onClampPositionChanged: {
            console.log(plcClient.clampPosition);
            currentMachineSettings.get(4).actual = plcClient.clampPosition;
        }
        onPlungerPositionChanged: {
            currentMachineSettings.get(5).actual = plcClient.plungerPosition;
        }
        onClampPressureChanged: {
            currentMachineSettings.get(6).actual = plcClient.clampPressure;
        }
        onInjectionPressureChanged: {
            currentMachineSettings.get(7).actual = plcClient.injectionPressure;
        }
    }

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

        model: currentMachineSettings

        itemDelegate: Item {
            height: parent.height / parent.rowCount
            Text {
                anchors.verticalCenter: parent.verticalCenter
                color: "black"
                elide: styleData.elideMode
                text: styleData.value
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    settingsPopup.currentValue = currentMachineSettings.get(styleData.row).set;
                    settingsPopup.popupTitle = currentMachineSettings.get(styleData.row).settingName;
                    settingsPopup.settingIndex = styleData.row;
                    settingsPopup.open();
                }
            }
        }
        rowDelegate: Item {
            height: (homePage.height / currentMachineSettings.rowCount()) - 2
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
            model: currentPTSettingsTop
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
            model: currentPTSettingsBottom
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
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: ptSettingsTop.cellWidth / 3
                    wrapMode: Text.WordWrap
                }
                Text{
                    text: units
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: ptSettingsTop.cellWidth / 10
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
                    anchors.bottom: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: ptSettingsTop.cellWidth / 3
                }
                Text{
                    text: set.toString()
                    anchors.left: setText.right
                    anchors.top: setText.top
                    anchors.leftMargin: ptSettingsTop.cellWidth / 10
                }
                Text{
                    id: actualText
                    text: "Actual:"
                    anchors.top: setText.bottom
                    anchors.left: parent.left
                    anchors.leftMargin: ptSettingsTop.cellWidth / 3
                }
                Text{
                    text: actual
                    anchors.left: actualText.right
                    anchors.top: actualText.top
                    anchors.leftMargin: ptSettingsTop.cellWidth / 10
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
        Material.background: Style.colorPalleteDarkest
        Text {
            Material.elevation: 6

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

    SaveNewProcessPage {
        id: saveNewProcessPage
        visible: false
    }

    SaveProcessPopup {
        id: saveProcessPopup
    }

    Component.onCompleted: {
        DB.dbInit("process_db","","Process Tracker");
        //currentProcessName.text =
    }
    Component.onDestruction: {
        setDefaultProcess();
    }

    function setDefaultProcess() {
        // save current as default
        var t = new Date();
        var date = t.toLocaleString('en-US', { timeZone: 'PST' });
        console.log(currentMachineSettings.get(0).set)
        DB.defaultProcessUpdate(date,
                    date,
                    currentProcessName.text,
                    "PLA",
                    "widget",
                    currentMachineSettings.get(0).set,
                    currentMachineSettings.get(1).set,
                    currentMachineSettings.get(2).set,
                    currentMachineSettings.get(3).set,
                    currentMachineSettings.get(4).set,
                    currentMachineSettings.get(5).set,
                    currentMachineSettings.get(6).set,
                    currentMachineSettings.get(7).set,
                    currentMachineSettings.get(8).set,
                    currentMachineSettings.get(9).set,
                    currentPTSettingsTop.get(0).set,
                    currentPTSettingsTop.get(1).set,
                    currentPTSettingsTop.get(2).set,
                    currentPTSettingsTop.get(3).set,
                    currentPTSettingsTop.get(4).set,
                    currentPTSettingsBottom.get(0).set,
                    currentPTSettingsBottom.get(1).set,
                    currentPTSettingsBottom.get(2).set,
                    currentPTSettingsBottom.get(3).set);
    }
}
