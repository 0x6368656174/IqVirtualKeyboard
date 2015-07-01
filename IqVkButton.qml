import QtQuick 2.4
import QtQuick.Controls 1.3 as QtControls
import QtQuick.Controls.Styles 1.3 as QtControlsStyles
import "fontawesomechars.js" as FontAwesomeChars

QtControls.Button {
    id: button
    property string value: ""
    property string shiftValue: ""
    property bool shift: false
    property bool isCheckable: false
    property bool isChecked: false

    property color checkedOffBackgroundColor: "#1C1C1C"
    property color checkedOnBackgroundColor: "#9C9C9C"
    property color checkedOffLabelColor: "#E8E8E8"
    property color checkedOnLabelColor: "#1C1C1C"

    property color labelColor: "#E8E8E8"
    property color backgroundColor: "#363636"
    property color backgroundPressedColor: "#828282"

    property string iconName: ""
    property string iconPosition: ""

    property real textHeightPrc: 0.5

    implicitHeight: 50
    implicitWidth: 50
    activeFocusOnTab: false

    style: QtControlsStyles.ButtonStyle {
        id: buttonStyle
        property color backgroundColor: {
            if (!isCheckable)
                return button.backgroundColor
            if (isChecked)
                return checkedOnBackgroundColor
            return checkedOffBackgroundColor
        }

        property color labelColor: {
            if (!isCheckable)
                return button.labelColor
            if (isChecked)
                return checkedOnLabelColor
            return checkedOffLabelColor
        }

        background: Rectangle {
            id: backgroundRect
            anchors.fill: parent
            color: buttonStyle.backgroundColor

            SequentialAnimation {
                alwaysRunToEnd: true
                running: control.pressed && ! isCheckable
                id: pressedAnimation
                PropertyAnimation {
                    target: backgroundRect
                    property: "color"
                    to: backgroundPressedColor
                    duration: 0
                }
                PropertyAnimation {
                    target: backgroundRect
                    property: "color"
                    to: buttonStyle.backgroundColor
                    duration: 300
                }
            }

            QtControls.Label {
                visible: iconPosition !== ""
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: iconPosition === "top" || iconPosition === "bottom"?parent.horizontalCenter:undefined
                anchors.verticalCenterOffset: {
                    if (iconPosition === "top")
                        return -parent.height / 5
                    else if (iconPosition === "bottom")
                        return parent.height / 5
                    return 0
                }

                anchors.left: iconPosition === "left"?parent.left:undefined
                anchors.right: iconPosition === "right"?parent.right:undefined
                anchors.leftMargin: parent.height * 0.15
                anchors.rightMargin: parent.height * 0.15

                font.pixelSize: parent.height * textHeightPrc
                font.family: "FontAwesome"
                color: buttonStyle.labelColor
                text: FontAwesomeChars.getChar(iconName)
            }
        }
        label: Item {
            QtControls.Label {
                id: textText
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: iconPosition !== "left" && iconPosition !== "right"?parent.horizontalCenter:undefined
                anchors.verticalCenterOffset: {
                    if (iconPosition === "top")
                        return parent.height / 5
                    else if (iconPosition === "bottom")
                        return -parent.height / 5
                    return 0
                }
                anchors.left: iconPosition === "left" || iconPosition == "right"?parent.left:undefined
                anchors.right: iconPosition === "left" || iconPosition == "right"?parent.right:undefined
                anchors.leftMargin: iconPosition === "left"? parent.height*0.5:0
                anchors.rightMargin: iconPosition === "right"? parent.height*0.5:0

                text: shift?shiftValue:value
                font.pixelSize: parent.height * textHeightPrc
                color: buttonStyle.labelColor
            }
        }
    }
}
