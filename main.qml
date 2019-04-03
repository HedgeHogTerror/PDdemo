import QtQuick 2.10
import QtQuick.Controls 2.3
import "."
ApplicationWindow {
    id: window
    visible: true
    width: 800
    height: 480

    header: ToolBar {
        id: headerBar
        visible: false
        contentHeight: drawerButton.implicitHeight
        property variant currentStackView: null

        background: Rectangle {
                    color: Style.colorPalleteLighter
                }

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
                    stackView.clear()
            }
        }

        Label {
            text: {
                if( stackView.currentItem !== null) return stackView.currentItem.title;
                else return "Home";
            }
            anchors.centerIn: parent
        }

        Label {
            id: currentProcessName
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 100
            text: "Current Process Name"
            font.italic: true
        }
    }

    HomePage {}

    Drawer {
        id: drawer
        width: window.width * 0.2
        height: window.height
        background: Rectangle {
            color: Style.colorPalleteDarkest
        }

        Column {
            anchors.fill: parent

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
}


