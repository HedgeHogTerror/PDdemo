import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls 1.4
import QtQuick.LocalStorage 2.0
import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Layouts 1.1
import "./Scripts/ProcessDB.js" as DB
import "./ProcessPage"

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
                        text: "Select"
                        anchors.leftMargin: 10
                        enabled: !creatingNewEntry && listView.currentIndex != -1
                        onClicked: {
                            console.log(listView.model.get(listView.currentIndex).processName);
                        }
                    }

                    Button {
                        id: deleteButton
                        text: "Delete"
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

                    header: Component {
                        Text {
                            text: "Saved processes"
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
    Component.onCompleted: {
        DB.dbInit()
    }


}
