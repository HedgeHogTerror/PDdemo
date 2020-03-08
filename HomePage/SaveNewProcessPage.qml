import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Styles 1.4
import "../"
import QtQuick.LocalStorage 2.0
import "../Scripts/ProcessDB.js" as DB
import QtQuick.Controls.Material 2.1


Page {
    id: page
    property string pageName: "Save As New Process"

    width: window.width
    height: window.height
    background: Rectangle {
        color: Style.colorPalleteLighter
    }

    title: qsTr(pageName)
    Rectangle {
        id: inputContainer
        width: 300
        height: 30
        radius: 5
        color: Style.colorPalleteLightest
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 100
        TextInput {
            id: saveAsTextInput
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10
            font.pixelSize: 24
            width: 280
            height: 30
            color: Style.colorPalleteDarkest
        }
    }

    Button {
        id: saveAsButton
        text: "Save Project As"
        enabled: saveAsTextInput.length > 0 ? true : false
        anchors.right: inputContainer.left
        anchors.rightMargin: 10
        anchors.verticalCenter: inputContainer.verticalCenter
        onClicked: {
            var t = new Date();
            var date = t.toLocaleString('en-US', { timeZone: 'PST' });
            console.log(currentMachineSettings.get(0).set)
            //WIP
            DB.dbInsert(date,
                        date,
                        saveAsTextInput.text,
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
            saveNewProcessPage.visible = false;
            currentProcessName.text = saveAsTextInput.text;
            saveAsTextInput.text = "";
        }
    }

}
