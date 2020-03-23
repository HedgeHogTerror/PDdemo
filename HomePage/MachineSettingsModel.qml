import QtQuick 2.0
ListModel {

    ListElement {
        settingName: "Metering Temperature"
        set: 0.00
        actual: 0.00
        units: "C"
    }
    ListElement {
        settingName: "Nozzle Temperature"
        set: 0.00
        actual: 0.00
        units: "C"
    }
    ListElement {
        settingName: "Injection Temperature"
        set: 0.00
        actual: 0.00
        units: "C"
    }
    ListElement {
        settingName: "Hydraulic Oil Temperature" // was Barrel Temperature 2
        set: 0.00
        actual: 0.00
        units: "C"
    }
    ListElement {
        settingName: "Clamp Position" // was Open Position
        set: ""
        actual: ""
        units: "cm"
    }
    ListElement {
        settingName: "Plunger Position" // was Clamp Tonnage
        set: 0.00
        actual: 0.00
        units: "Pa"
    }
    ListElement {
        settingName: "Clamp Pressure" // was Close Speed
        set: 0.00
        actual: 0.00
        units: "m/s"
    }
    ListElement {
        settingName: "Plunger Pressure" // was Open Speed
        set: 0.00
        actual: 0.00
        units: "m/s"
    }
    ListElement {
        settingName: "Ejector Distance"
        set: 0.00
        actual: 0.00
        units: "cm"
    }
    ListElement {
        settingName: "Ejection Speed"
        set: 0.00
        actual: 0.00
        units: "m/s"
    }
}
