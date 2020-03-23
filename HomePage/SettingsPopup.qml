import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Styles 1.4
import "../"
import "../Scripts/Calculator.js" as CalcEngine

Popup {
    id: popup
   x: (parent.width - width)/2
   y: (parent.height - height)/2
   property string popupTitle: "default"
   property double currentValue: 0
   property int settingIndex: 0
   width: 400
   height: 300
   modal: true
   focus: true
   closePolicy: Popup.CloseOnPressOutside | Popup.CloseOnEscape

   Connections {
       target: plcClient
    }

   background: Rectangle {
       radius: 5
       color: Style.colorPalleteHeader
     }
    onOpened: {
        setValue.text = currentValue;
    }
    onClosed: {
        setValue.text = "";
        CalcEngine.op("C");
        // call set sensor values here popupTitle == Sensor Name
        if (popupTitle == "Open Position") plcClient.sethydraulicOilTemperature(currentValue);
    }

   Text {
       id: name
       text: popupTitle
       anchors.horizontalCenter: parent.horizontalCenter
       anchors.top: parent.top
       anchors.topMargin: 5
   }

   Rectangle {
       id: valueContainer
       color: Style.colorPalleteDarker
       anchors.bottom: display.top
       anchors.bottomMargin: 10
       anchors.horizontalCenter: parent.horizontalCenter
       width: 100
       height: 30
        Text {
            id: setValue
            text: ""
            anchors.centerIn: parent
        }
   }

   Button {
       id: upleft
       width: 40
       height: 40
       text: "\u21b0"
       anchors.verticalCenter: valueContainer.verticalCenter
       anchors.left: valueContainer.right
       anchors.leftMargin: 5
       onClicked: {
            set(currentValueDisplay.text)
       }
   } // up->left arrow

   Button {
       text: "MAX"
       width: 60
       height: 40
       anchors.verticalCenter: valueContainer.verticalCenter
       anchors.right: parent.right
       anchors.rightMargin: 10
       Text {
           id: maxValue
           text: "100"
           anchors.horizontalCenter: parent.horizontalCenter
           anchors.top: parent.bottom
           anchors.topMargin: 10
       }
       onClicked: {
            set(maxValue.text);
       }
   }


   Button {
       text: "MIN"
       width: 60
       height: 40
       anchors.verticalCenter: valueContainer.verticalCenter
       anchors.left: parent.left
       anchors.leftMargin: 10
       Text {
           id: minValue
           text: "5"
           anchors.horizontalCenter: parent.horizontalCenter
           anchors.top: parent.bottom
           anchors.topMargin: 10
       }
       onClicked: {
            set(minValue.text);
       }
   }


   Rectangle {
       id: display
       color: Style.colorPalleteLightest
       anchors.bottom: numberButtons.top
       anchors.horizontalCenter: parent.horizontalCenter
       width: 200
       height: 20
        Text {
            id: currentValueDisplay
            text: currentValue
            anchors.right: parent.right
            anchors.rightMargin: 2
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 2
        }
        Text {
            id: currentOperation
            text: ""
            anchors.left: parent.left
            anchors.leftMargin: 2
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 2
        }
   }

   Grid {
       id: numberButtons
       columns: 3
       spacing: 5
       anchors.left: parent.left
       anchors.leftMargin: 40
       anchors.bottom: parent.bottom
       anchors.bottomMargin: 5
       Repeater {
           model: 10
           Button { width: 40; height: 40; text: index; onClicked: CalcEngine.op(text)}
       }
       Button { width: 40; height: 40; text: "."; onClicked: CalcEngine.op(text) }
       Button { width: 40; height: 40; text: "C"; onClicked: CalcEngine.op(text) }

   }
   Grid {
       id: operatorButtons
      columns: 2
      spacing: 5
      anchors.left: numberButtons.right
      anchors.leftMargin: 5
      anchors.bottom: parent.bottom
      anchors.bottomMargin: 5
      Button { width: 40; height: 40; text: "+"; onClicked: CalcEngine.op(text) }
      Button { width: 40; height: 40; text: "-" }
      Button { width: 40; height: 40; text: "\u00F7"; onClicked: CalcEngine.op(text) } // division
      Button { width: 40; height: 40; text: "\u00D7"; onClicked: CalcEngine.op(text) } // multiplication
      Button { width: 40; height: 40; text: "\u221A"; onClicked: CalcEngine.op(text) } // sqrt
      Button { width: 40; height: 40; text: "\u00B2"; onClicked: CalcEngine.op(text) } // squared
      Button { width: 40; height: 40; text: "="; onClicked: CalcEngine.op(text) } // squared
   }

   Button {
       id: setButton
       width: 75
       height: 85
       text: "SET"
       anchors.top: operatorButtons.top
       anchors.left: operatorButtons.right
       anchors.leftMargin: 5
       onClicked: {
            set(currentValueDisplay.text)
       }
   } // big set

   Button {
       id: calcButton
       width: 75
       height: 85
       text: "ENTER"
       anchors.bottom: operatorButtons.bottom
       anchors.left: operatorButtons.right
       anchors.leftMargin: 5
       onClicked: {
            CalcEngine.op("=")
       }
   } // big enter



   function set( newValue ){
       currentValue = newValue;
       setValue.text = newValue;
       currentMachineSettings.get(settingIndex).set = parseFloat(newValue);
   }
}
