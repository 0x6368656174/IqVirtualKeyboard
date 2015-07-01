import QtQuick 2.0

Rectangle {
    id: button
    property string ruValue: ""
    property string engValue: ""
    property string shiftRuValue: ""
    property string shiftEngValue: ""
    property string numValue: ""
    property string shiftNumValue: ""
    property bool shift: false
    property bool ru: true
    property bool num: false
    property color valueColor: "#E8E8E8"
    property color backgroundColor: "#363636"
    property real textHeightPrc: 0.5

    signal clicked(string key)

    width: 50
    height: 50
    color: backgroundColor

    Text {
        id: textText
        anchors.fill: parent
        text: {
            var val = engValue
            if (shift)
            {
                if (shiftEngValue !== "")
                {
                    val = shiftEngValue
                } else
                {
                    val = val.toUpperCase()
                }
            }

            if (ru)
            {
                val = ruValue
                if (shift)
                {
                    if (shiftRuValue !== "")
                    {
                        val = shiftRuValue
                    } else
                    {
                        val = val.toUpperCase()
                    }
                }
            }

            if (num)
                val = numValue
            if (shift && num && shiftNumValue !== "")
                val = shiftNumValue

            return val
        }

        color: valueColor
        font.pixelSize: parent.height * textHeightPrc
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            button.clicked(textText.text)
            pressedAnimation.stop()
            pressedAnimation.start()
        }
    }

    SequentialAnimation {
        id: pressedAnimation
        PropertyAnimation {
            target: button
            property: "color"
            to: "#828282"
            duration: 0
        }
        PropertyAnimation {
            target: button
            property: "color"
            to: backgroundColor
            duration: 300
        }
    }
}
