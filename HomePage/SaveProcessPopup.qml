import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Styles 1.4
import "../"
import QtQuick.LocalStorage 2.0
import "../Scripts/ProcessDB.js" as DB

Popup {
    id: popup
   width: 200
   height: 160
   x: (parent.width - width)/2
   y: (parent.height - height)/2
   modal: true
   closePolicy: Popup.CloseOnPressOutside


   Text {
       id: name
       text: "Save Current Settings"
       anchors.horizontalCenter: parent.horizontalCenter
       anchors.top: parent.top
       anchors.topMargin: 5
   }
   background: Rectangle {
       radius: 5
       color: Style.colorPalleteHeader
    }

    Button {
        id: saveAs
        text: "Save As New Process"
        anchors.topMargin: 10
        anchors.top: name.bottom
        onClicked: {
            saveNewProcessPage.visible = true
            drawer.close()
            popup.close()
        }
    }

    Button {
        id: saveChanges
        text: "Save Changes"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 10
        anchors.top: saveAs.bottom
        onClicked: {
            var t = new Date();
            var date = t.toLocaleString('en-US', { timeZone: 'PST' });
            console.log(machineSettings.model.get(0).set)

            //WIP
            DB.dbUpdate(date,
                        date,
                        currentProcessName.text,
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

        }
    }
}
