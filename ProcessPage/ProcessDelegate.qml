import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import QtQuick.Layouts 1.1
import "../Scripts/ProcessDB.js" as JS
import "../"

Item {
    width: parent.width
    height: rDate.implicitHeight

    Rectangle {
        id: baseRec
        anchors.fill: parent
        opacity: 0.8
        color: index % 2 ? Style.colorPalleteLighter : Style.colorPalleteLightest

        MouseArea {
            anchors.fill: parent
            onClicked: listView.currentIndex = index
        }
        GridLayout {
            anchors.fill:parent
            columns: 4

            Text {
                id: rDate
                text: modifiedDate
                font.pixelSize: 22
                color: "black"
            }
            Text {
                id: rProcess
                text: processName
                font.pixelSize: 22
                color: "black"
            }
            Text {
                id: rMaterial
                text: materialName
                font.pixelSize: 22
                color: "black"
            }
            Text {
                id: rMold
                text: moldName
                font.pixelSize: 22
                color: "black"
            }
        }
    }
}
