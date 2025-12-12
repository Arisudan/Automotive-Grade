import QtQuick

Item {
    id: root
    width: 400
    height: 400
    property real value: 0
    property real maxValue: 260
    
    // Background Glow/Ring
    Canvas {
        id: dialCanvas
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();
            var cx = width / 2;
            var cy = height / 2;
            var radius = width / 2 - 40;

            // Arc settings
            var startAngle = Math.PI * 0.75; 
            var endAngle = Math.PI * 2.25;   
            var step = (endAngle - startAngle) / 26; // 26 steps for 260kmh

            // Ticks
            for (var i = 0; i <= 26; i++) {
                var angle = startAngle + i * step;
                var isMajor = (i % 2 === 0);

                var innerR = radius - (isMajor ? 20 : 10);
                var outerR = radius;
                
                var x1 = cx + Math.cos(angle) * innerR;
                var y1 = cy + Math.sin(angle) * innerR;
                var x2 = cx + Math.cos(angle) * outerR;
                var y2 = cy + Math.sin(angle) * outerR;

                ctx.beginPath();
                ctx.moveTo(x1, y1);
                ctx.lineTo(x2, y2);
                ctx.lineWidth = isMajor ? 3 : 1;
                ctx.strokeStyle = "white";
                ctx.stroke();

                // Numbers
                if (isMajor) {
                    var val = Math.round((i / 26) * root.maxValue);
                    var textR = radius - 40;
                    var tx = cx + Math.cos(angle) * textR;
                    var ty = cy + Math.sin(angle) * textR;
                    
                    ctx.fillStyle = "white";
                    ctx.font = "bold 16px sans-serif";
                    ctx.textAlign = "center";
                    ctx.textBaseline = "middle";
                    ctx.fillText(val.toString(), tx, ty);
                }
            }
        }
    }

    // Center Text (ECHO)
    Column {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -40
        spacing: 5
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 5
            Text {
                text: "🌿" 
                font.pixelSize: 20
                color: "#44ff44"
            }
            Text {
                text: "Echo"
                color: "#44ff44"
                font.pixelSize: 20
                font.bold: true
            }
        }
    }

    // Needle
    Item {
        anchors.fill: parent
        rotation: 135 + (root.value / root.maxValue) * 270

        Behavior on rotation {
            NumberAnimation { duration: 300; easing.type: Easing.OutQuad }
        }

        Rectangle {
            width: 140
            height: 4
            color: "red"
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: -70
            antialiasing: true
        }
    }
    
    // Center Cap
    Rectangle {
        width: 30
        height: 30
        radius: 15
        color: "#222"
        border.color: "#444"
        border.width: 2
        anchors.centerIn: parent
    }

    // Label - digital readout or just text? Image has "MM/S" label.
    // I will add a digital readout too, usually nice.
    Column {
         anchors.centerIn: parent
         anchors.verticalCenterOffset: 60
         
         Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Math.round(root.value)
            color: "white"
            font.pixelSize: 32
            font.bold: true
            visible: true 
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "km/h"
            color: "white"
            font.pixelSize: 18
            font.bold: true
            font.family: "Eurostile"
        }
    }
}
