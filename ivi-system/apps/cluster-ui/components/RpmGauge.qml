import QtQuick
import QtQuick.Shapes

Item {
    id: root
    width: 400
    height: 400
    property real value: 0
    property real maxValue: 8000
    property string label: "RPM"

    // Background Glow
    Rectangle {
        anchors.fill: parent
        radius: width/2
        color: "transparent"
        visible: false // Optimization
    }

    // Ticks and Numbers
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
            var startAngle = Math.PI * 0.75; // 135 degrees
            var endAngle = Math.PI * 2.25;   // 405 degrees (Span 270)
            var step = (endAngle - startAngle) / 40; // 40 small ticks

            // Draw Blue Glow Arc
            var gradient = ctx.createLinearGradient(0, 0, width, 0);
            gradient.addColorStop(0, "blue");
            gradient.addColorStop(1, "cyan");
            
            // Outer Ring
            ctx.beginPath();
            ctx.arc(cx, cy, radius, startAngle, endAngle);
            ctx.lineWidth = 2;
            ctx.strokeStyle = "#333";
            ctx.stroke();

            // Ticks
            for (var i = 0; i <= 40; i++) {
                var angle = startAngle + i * step;
                var isMajor = (i % 5 === 0);
                var isRedline = (i > 30); // Last 25%

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
                ctx.strokeStyle = isRedline ? "red" : "white";
                ctx.stroke();

                // Numbers
                if (isMajor) {
                    var val = Math.round((i / 40) * root.maxValue);
                    if (root.label === "RPM") val = val / 1000; // 0-8 format
                    
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
                text: "🌿" // Leaf emoji as icon substitute
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
        id: needleWrapper
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
            anchors.horizontalCenterOffset: -70 // Shift so pivot is center
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

    // Label
    Text {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 60
        text: root.label
        color: "white"
        font.pixelSize: 24
        font.bold: true
        font.family: "Eurostile" // or similar
    }
}
