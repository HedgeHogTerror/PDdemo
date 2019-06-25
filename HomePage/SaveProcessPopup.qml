import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Styles 1.4
import "../"
import QtQuick.LocalStorage 2.0
import "../Scripts/ProcessDB.js" as DB

Popup {
    id: popup
   width: parent.width
   height: 200
   modal: inputPanel.state == "visible" ? false : true
   focus: inputPanel.state == "visible" ? false : true
   closePolicy: inputPanel.state == "visible" ? Popup.CloseOnEscape : Popup.CloseOnPressOutside
   Text {
       id: name
       text: "Save Current Settings"
       anchors.horizontalCenter: parent.horizontalCenter
       anchors.top: parent.top
       anchors.topMargin: 5
   }
   background: Rectangle {
       color: Style.colorPalleteHeader
    }
   onOpened:
    {
       inputPanel.tempParent = popup
    }

   onClosed:
    {
       inputPanel.tempParent = ApplicationWindow.overlay
       inputPanel.state = ""
    }

    TextInput {
        id: saveAsTextInput
        width: 150
        height: 30
        visible: true
        color: Style.colorPalleteLightest
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: - 50
        anchors.top: parent.top
        anchors.topMargin: 50
    }
    Button {
        id: saveAs
        text: "Save As"
        enabled: false
        anchors.left: saveAsTextInput.right
        anchors.leftMargin: 10
        anchors.top: saveAsTextInput.top
    }

    Button {
        id: save
        text: "Save"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        onClicked: {
            var t = new Date();
            var date = t.toLocaleString('en-US', { timeZone: 'PST' });
            console.log(machineSettings.model.get(0).set)
            currentProcessName.text = saveAsTextInput.text;
            //WIP
            DB.dbGetLength(function(length){
                DB.dbInsert(date,
                            date,
                            saveAsTextInput.text,
                            "PLA",
                            "widget",
                            machineSettings.model.get(0).set,
                            machineSettings.model.get(1).set,
                            machineSettings.model.get(2).set,
                            machineSettings.model.get(3).set,
                            machineSettings.model.get(4).set,
                            machineSettings.model.get(5).set,
                            machineSettings.model.get(6).set,
                            machineSettings.model.get(7).set,
                            machineSettings.model.get(8).set,
                            machineSettings.model.get(9).set,
                            ptSettingsTop.model.get(0).set,
                            ptSettingsTop.model.get(1).set,
                            ptSettingsTop.model.get(2).set,
                            ptSettingsTop.model.get(3).set,
                            ptSettingsTop.model.get(4).set,
                            ptSettingsBottom.model.get(0).set,
                            ptSettingsBottom.model.get(1).set,
                            ptSettingsBottom.model.get(2).set,
                            ptSettingsBottom.model.get(3).set);
            });
        }
    }
}
