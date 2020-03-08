import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls 1.4
import QtQuick.LocalStorage 2.0
import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Layouts 1.1

import "./Scripts/ProcessDB.js" as DB

import "./ProcessPage"

import "."
import QtQuick.Controls.Material 2.1


Page {
    id: page
    property string pageName: "Process Page"

    width: window.width
    height: window.height

    title: qsTr(pageName)

    property bool creatingNewEntry: false
    property bool editingEntry: false

    Rectangle {
            anchors.fill: parent
            ColumnLayout {
                anchors.fill: parent
                RowLayout {
                    anchors.leftMargin: 10
                    Button {
                        id: moldDBButton
                        text: qsTr("RESET DB")
                        Material.background: Style.colorPalleteLightest
                        onClicked: {
                            DB.dbDeleteAll();
                            listView.model.clear();
                            if (listView.count == 0) {
                                // ListView doesn't automatically set its currentIndex to -1
                                // when the count becomes 0.
                                listView.currentIndex = -1;
                            }
                        }
                    }

                    Button {
                        id: selectButton
                        text: "Set As Current Process"
                        Material.background: Style.colorPalleteDarkest
                        anchors.leftMargin: 10
                        enabled: !creatingNewEntry && listView.currentIndex != -1
                        onClicked: { //tbd
                            console.log(listView.model.get(listView.currentIndex).processName);

                        }
                    }

                    Button {
                        id: editButton
                        text: "Edit"
                        Material.background: Style.colorPalleteDarkest
                        anchors.leftMargin: 10
                        enabled: !creatingNewEntry && listView.currentIndex != -1
                        onClicked: { //tbd
                            console.log(listView.model.get(listView.currentIndex).processName);

                        }
                    }

                    Button {
                        id: deleteButton
                        text: "Delete"
                        Material.background: Style.colorPalleteDarkest
                        anchors.leftMargin: 10
                        enabled: !creatingNewEntry && listView.currentIndex != -1
                        onClicked: {
                            DB.dbDeleteRow(listView.model.get(listView.currentIndex).processName)
                            listView.model.remove(listView.currentIndex, 1)
                            if (listView.count == 0) {
                                // ListView doesn't automatically set its currentIndex to -1
                                // when the count becomes 0.
                                listView.currentIndex = -1
                            }
                        }
                    }

                }
                Component {
                    id: highlightBar
                    Rectangle {
                        width: listView.currentItem.width
                        height: listView.currentItem.height
                        color: "lightgreen"
                    }
                }
                ListView {
                    id: listView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model: ListModel {
                        id: listModel
                        Component.onCompleted: DB.dbReadAll()
                    }
                    delegate: ProcessDelegate {}
                    // Don't allow changing the currentIndex while the user is creating/editing values.
                    enabled: !creatingNewEntry && !editingEntry

                    highlight: highlightBar
                    highlightFollowsCurrentItem: true
                    focus: true

                    header: Rectangle {
                        height: 25
                        width: parent.width
                        Text {
                            text: "Date"
                            id: dateHeaderLabel
                            anchors.leftMargin: 10
                            anchors.left: parent.left
                        }
                        Text {
                            text: "Name"
                            id: nameHeaderLabel
                            anchors.leftMargin: window.width / 6
                            anchors.left: dateHeaderLabel.right
                        }
                        Text {
                            text: "Material"
                            id: materialHeaderLabel
                            anchors.leftMargin: window.width / 6
                            anchors.left: nameHeaderLabel.right
                        }
                        Text {
                            text: "Part"
                            id: partHeaderLabel
                            anchors.leftMargin: window.width / 6
                            anchors.left: materialHeaderLabel.right
                        }
                        Text {
                            text: "Mold Description"
                            id: moldHeaderLabel
                            anchors.leftMargin: window.width / 6
                            anchors.left: partHeaderLabel.right
                        }
                    }
                }
                Text {
                    id: statustext
                    color: "red"
                    Layout.fillWidth: true
                    font.bold: true
                    font.pointSize: 20

                }
            }
        }
}
