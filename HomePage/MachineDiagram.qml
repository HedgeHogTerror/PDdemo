import QtQuick 2.10
import "../"

Rectangle {
    anchors.left: parent.left
    width: parent.width * .2
    height: parent.height
    color: Style.colorPalleteDarkest
    Connections {
        target: pressureData
    }

    Rectangle {
        id: clampBlock
        height: parent.height * .2
        width: parent.width * .2
        border.color: Style.colorPalleteMachine
        color: Style.colorPalleteDarkest
        anchors.bottom: footer.top
        anchors.right: parent.right
    }

    Rectangle {
        id: moldBlock
        height: parent.height * .18
        width: parent.width * .4
        border.width: 2
        border.color: Style.colorPalleteMachine
        color: Style.colorPalleteDarkest
        anchors.bottom: footer.top
        anchors.bottomMargin: parent.height * .01
        anchors.left: parent.left
    }

    Rectangle {
        id: hopperBlock
        height: parent.height * .2
        width: parent.width * .3
        border.width: 2
        border.color: Style.colorPalleteMachine
        color: Style.colorPalleteDarkest
        anchors.bottom: parent.verticalCenter
        anchors.left: parent.left
    }
    Rectangle {
        id: screwBlock
        height: parent.height * .2
        width: parent.width * .15
        border.width: 2
        border.color: Style.colorPalleteMachine
        color: Style.colorPalleteDarkest
        anchors.top: hopperBlock.bottom
        anchors.horizontalCenter: hopperBlock.horizontalCenter
    }

    Rectangle {
        id: plungerBlock
        height: parent.height * .05
        width: parent.width * .3
        border.width: 2
        border.color: Style.colorPalleteMachine
        color: Style.colorPalleteDarkest
        anchors.bottom: screwBlock.bottom 
        anchors.left: screwBlock.right
    }

    Rectangle {
        id: footer
        height: parent.height * .05
        width: parent.width 
        border.width: 2
        border.color: Style.colorPalleteMachine
        color: Style.colorPalleteDarkest
        anchors.bottom: parent.bottom 
        anchors.left: parent.left
    }
}
