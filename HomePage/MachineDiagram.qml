import QtQuick 2.10
import "../"

Rectangle {
    anchors.left: parent.left
    width: parent.width * .2
    height: parent.height
    color: Style.colorPalleteMedium
    Connections {
        target: pressureData
    }
    Rectangle {
        id: topClamp
        height: 50
        width: parent.width * .8
        color: Style.colorPalleteDarkest
        anchors.horizontalCenter: parent.horizontalCenter
        y: ( parent.height -150) + pressureData.wValue.y
    }
    Rectangle {
        id: bottomClamp
        height: 50
        width: parent.width * .8
        color: Style.colorPalleteDarkest
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
