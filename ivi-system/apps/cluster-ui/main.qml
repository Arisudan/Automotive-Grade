import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "components"

Window {
    id: window
    width: 1280
    height: 720
    visible: true
    title: "ASTER Cluster"
    color: "black"

    // Bindings to C++ context
    property real speedVal: carData ? carData.speed : 0
    property real rpmVal: carData ? carData.rpm : 0
    property int gearVal: carData ? carData.gear : 0

    // Top Bar
    Item {
        id: topBar
        width: parent.width
        height: 100
        anchors.top: parent.top
        z: 10
        
        // Simple Gradient Background
        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#111" }
                GradientStop { position: 1.0; color: "transparent" }
            }
            opacity: 0.8
        }

        // Left: Weather
        Row {
            anchors.left: parent.left
            anchors.leftMargin: 40
            anchors.verticalCenter: parent.verticalCenter
            spacing: 15
            Text { text: "☁️"; font.pixelSize: 30; color: "white" }
            Text { text: "12 °C"; font.pixelSize: 24; color: "white"; font.bold: true }
        }

        // Center: BRANDING (ASTER)
        Rectangle {
            width: 80; height: 80
            radius: 40
            color: "black"
            border.color: "#444"
            border.width: 2
            anchors.centerIn: parent
            
            Text {
                anchors.centerIn: parent
                text: "ASTER"
                color: "#00aaff"
                font.bold: true
                font.pixelSize: 16
            }
        }

        // Right: Time
        Text {
            anchors.right: parent.right
            anchors.rightMargin: 40
            anchors.verticalCenter: parent.verticalCenter
            text: "12:00" // Placeholder or bind to timer
            color: "white"
            font.pixelSize: 24
            font.bold: true
        }
    }

    // Main Content (Gauges)
    Row {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 20
        spacing: 150

        // Left Gauge: RPM
        RpmGauge {
            width: 400; height: 400
            value: rpmVal
            maxValue: 8000
        }

        // Right Gauge: Speed
        Speedometer {
            width: 400; height: 400
            value: speedVal
            maxValue: 260
        }
    }

    // Gear Indicator (Left Side)
    GearIndicator {
        anchors.left: parent.left
        anchors.leftMargin: 50
        anchors.verticalCenter: parent.verticalCenter
        currentGear: gearVal
    }

    // Bottom Bar (Warnings)
    WarningIcons {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
