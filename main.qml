import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.LocalStorage 2.0
import "./Scripts/ProcessDB.js" as DB
import "."
import "./HomePage"
import QtQuick.VirtualKeyboard 2.2
import QtQuick.VirtualKeyboard.Settings 2.2
import "Keyboard"
import QtQuick.Controls.Material 2.1

ApplicationWindow {
    id: window
    visible: true
    width: 1600
    height: 1200

    Material.theme: Material.Light
    Material.accent: Style.colorPalleteHeader

    header: ToolBar {
        id: headerBar
        visible: false
        contentHeight: drawerButton.implicitHeight
        property variant currentStackView: null

        background: Rectangle {
            color: Style.colorPalleteHeader
        }
        Material.foreground: Style.colorPalleteHeaderFont
        ToolButton {
            id: drawerButton
            text: "\u2630"
            font.pixelSize: Qt.application.font.pixelSize * 1.6
            onClicked: drawer.open()
        }

        ToolButton {
            id: backButton
            anchors.left: drawerButton.right
            leftPadding: 10
            text: "\u25C0"
            font.pixelSize: Qt.application.font.pixelSize * 1.6
            visible: stackView.depth > 2
            onClicked: stackView.pop()
        }

        ToolButton {
            id: homeButton
            anchors.left: backButton.right
            leftPadding: 10
            text: "\u2302"
            font.pixelSize: Qt.application.font.pixelSize * 1.6
            onClicked: {
                stackView.clear();
            }
        }

        Label {
            text: {
                if( stackView.currentItem !== null) return stackView.currentItem.title;
                else return "Home";
            }
            font.bold: true
            anchors.centerIn: parent
        }

        Label {
            id: currentProcessName
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 100
            text: "Default Process Name"
            font.italic: true
        }
    }

    HomePage { id: homePage }

    MachineSettingsModel{ id: currentMachineSettings }
    PTSettingsTopModel{ id: currentPTSettingsTop }
    PTSettingsBottomModel{ id: currentPTSettingsBottom }

    Drawer {
        id: drawer
        width: window.width * 0.2
        height: window.height

        background: Rectangle {
            color: Style.colorPalleteDarkest
        }

        Column {
            anchors.fill: parent
            Material.foreground:  Style.colorPalleteLightest
            ItemDelegate {
                text: qsTr("Monitoring")
                width: parent.width
                onClicked: {
                    stackView.clear()
                    stackView.push("MonitoringPage.qml")
                    drawer.close()
                }
            }
            ItemDelegate {
                text: qsTr("Processes")
                width: parent.width
                onClicked: {
                    stackView.clear()
                    stackView.push("ProcessPage.qml")
                    drawer.close()
                }
            }
            ItemDelegate {
                text: qsTr("Cycle/Part Count")
                width: parent.width
                onClicked: {
                    stackView.clear()
                    stackView.push("PartCountPage.qml")
                    drawer.close()
                }
            }
            ItemDelegate {
                text: qsTr("Alarms")
                width: parent.width
                onClicked: {
                    stackView.clear()
                    stackView.push("AlarmsPage.qml")
                    drawer.close()
                }
            }
            ItemDelegate {
                text: qsTr("Settings")
                width: parent.width
                onClicked: {
                    stackView.clear()
                    stackView.push("SettingsPage.qml")
                    drawer.close()
                }
            }
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent
    }

    Image {
        id: splash
        source: "/images/PD_LOGO.jpg"
        anchors.fill: parent

    }

    Timer {
        interval: 0; running: true; repeat: false
        onTriggered: {
            splash.visible = false
            headerBar.visible = true
        }
    }
    InputPanel {
       id: inputPanel
       z: 10000
       y: window.height
       x: 0
       visible: true
       width: window.width
       property var contentPoint: inputPanel.tempParent.mapFromGlobal(0, window.height)
       property var tempParent: ApplicationWindow.overlay

       Component.onCompleted:
       {
           inputPanelHeight = inputPanel.height;
       }

       states: State {
                name: "visible"
                /*  The visibility of the InputPanel can be bound to the Qt.inputMethod.visible property,
                   but then the handwriting input panel and the keyboard input panel can be visible
                   at the same time. Here the visibility is bound to InputPanel.active property instead,
                   which allows the handwriting panel to control the visibility when necessary.
                */
                when: inputPanel.active

                PropertyChanges
                {
                    target: inputPanel
                    parent: tempParent
                }
                PropertyChanges {
                   target: inputPanel
                   y: contentPoint.y 
                   x: contentPoint.x
                }
                PropertyChanges {
                   target: inputPanel
                }
           }
           transitions: Transition {
               id: inputPanelTransition
               from: ""
               to: "visible"
               reversible: true
               enabled: !VirtualKeyboardSettings.fullScreenMode
               ParallelAnimation {
                   NumberAnimation {
                       properties: "y"
                       duration: 500
                       easing.type: Easing.InOutQuad
                   }
               }
           }
    }
}


