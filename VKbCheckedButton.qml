import QtQuick 2.0

VKbButton {
    id: button
    property bool checked: false

    width: 50
    height: 50
    color: {
        if (!checked)
        {
            return "#1C1C1C"
        } else
        {
            return "#9C9C9C"
        }
    }
    valueColor: {
        if (!checked)
        {
            return "#E8E8E8"
        } else
        {
            return "#1C1C1C"
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            checked = !checked
        }
    }
}
