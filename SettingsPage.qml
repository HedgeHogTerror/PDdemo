import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls 1.4

Page {
    id: page
    property string pageName: "Settings Page"

    width: window.width
    height: window.height

    title: qsTr(pageName)

    Text {
        anchors.centerIn: parent
        text: "Needs More Cowbell!"
    }

}
