/**********************************************************************************
 * Copyright © 2015 Pavel A. Puchkov                                              *
 *                                                                                *
 * This file is part of IqVirtualKeyboard.                                        *
 *                                                                                *
 * IqVirtualKeyboard is free software: you can redistribute it and/or modify      *
 * it under the terms of the GNU Lesser General Public License as published by    *
 * the Free Software Foundation, either version 3 of the License, or              *
 * (at your option) any later version.                                            *
 *                                                                                *
 * IqVirtualKeyboard is distributed in the hope that it will be useful,           *
 * but WITHOUT ANY WARRANTY; without even the implied warranty of                 *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                  *
 * GNU Lesser General Public License for more details.                            *
 *                                                                                *
 * You should have received a copy of the GNU Lesser General Public License       *
 * along with IqVirtualKeyboard.  If not, see <http://www.gnu.org/licenses/>.     *
 **********************************************************************************/

import QtQuick 2.4
import QtQuick.Controls 1.3
import "keyboardLayouts"

Item {
    property bool interactiveResizeEnabled: true

    property TextField textField
    property Item contentItem

    QtObject {
        id: privateData
        property bool visible: false
        property real lastKeyboardHeight: 280
        property TextField lastTextField

        property bool shift: false
        onShiftChanged: updateChecked("shift")
        property bool capsLock: false
        onCapsLockChanged: updateChecked("capsLock")
        property var checked: []

        function updateChecked(name) {
            var checked = privateData.checked
            var index = checked.indexOf(name);
            if (index > -1) {
                checked.splice(index, 1);
            } else {
                checked.push(name)
            }
            privateData.checked = checked
        }
    }

    id: keyboard

    onTextFieldChanged: {
        if (contentItem === undefined)
            return
        if (textField === null) {
            hide()
            return
        }
        privateData.lastTextField = textField
        show()
        updateContentY()
    }

    function show()
    {
        if (privateData.visible)
            return
        titleRect.anchors.bottomMargin = privateData.lastKeyboardHeight
    }

    function hide()
    {
        if (!privateData.visible)
            return
        privateData.lastKeyboardHeight = titleRect.anchors.bottomMargin
        titleRect.anchors.bottomMargin = 0
    }

    function updateContentY() {
        //Проверим, чтоб редактируемый элемент оставлся видимым
        var globalEditElemetnRect = privateData.lastTextField.parent.mapToItem(contentItem,
                                                                               privateData.lastTextField.x, privateData.lastTextField.y,
                                                                               privateData.lastTextField.width, privateData.lastTextField.height)
        var thisGlobalPoint = parent.mapToItem(null, titleRect.x, titleRect.y)
        if (thisGlobalPoint.y - 20 < globalEditElemetnRect.y + globalEditElemetnRect.height) {
            //Будем подымать страничку
            contentItem.y = -(globalEditElemetnRect.y + globalEditElemetnRect.height - thisGlobalPoint.y + 20)
        } else
            contentItem.y = 0
    }

    Rectangle {
        id: titleRect
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        visible: textField || anchors.bottomMargin !== 0
        height: 20
        color: "#1C1C1C"

        onYChanged: {
            if (y > keyboard.height - height - 10) {
                privateData.visible = false
                contentItem.y = 0
            } else {
                privateData.visible = true
                updateContentY()
            }
        }

        Behavior on anchors.bottomMargin {
            id: anchorsAnimation
            NumberAnimation {duration: 200}
        }


        Image {
            source: "images/dots-button.svg"
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: titlerArrow.left
            anchors.rightMargin: 25
            height: 12
            width: 50
        }

        Image {
            id: titlerArrow
            anchors.centerIn: parent
            source: "images/arrow-270.svg"
            height: 16
            width: 25
            rotation: privateData.visible?0:180

            Behavior on rotation {NumberAnimation {duration: 200} }
        }

        Image {
            source: "images/dots-button.svg"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: titlerArrow.right
            anchors.leftMargin: 25
            height: 12
            width: 50
        }

        MouseArea {
            anchors.fill: parent
            drag.target: parent
            drag.minimumY: keyboard.height - (parent.width / 820 * 280 + 10 + height)
            drag.maximumY: keyboard.height - height
            onClicked: {
                if (titleRect.y >= keyboard.height - titleRect.height) {
                    show()
                } else {
                    hide()
                }
            }
            onPressed: {
                if (!keyboard.interactiveResizeEnabled)
                    return
                titleRect.anchors.bottom = undefined
                if (titleRect.anchors.bottomMargin > 10)
                    keyboardItem.anchors.bottom = keyboardItem.parent.bottom
            }
            onReleased: {
                if (!keyboard.interactiveResizeEnabled)
                    return
                anchorsAnimation.enabled = false
                titleRect.anchors.bottomMargin = keyboard.height - titleRect.y - titleRect.height
                titleRect.anchors.bottom = keyboard.bottom
                anchorsAnimation.enabled = true
                keyboardItem.anchors.bottom = undefined
                if (titleRect.anchors.bottomMargin > 10)
                    privateData.lastKeyboardHeight = titleRect.anchors.bottomMargin
            }
        }
    }


    Rectangle {
        id: backgroundRect
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: titleRect.bottom
        anchors.bottom: parent.bottom
        color: "black"
        MouseArea {
            anchors.fill: parent
        }
    }

    FontLoader {
        id: fontAwesome
        source: "fonts/fontawesome.ttf"
    }

    function processClicked(key) {
        privateData.shift = false
        if (textField.readOnly)
            return
        removeSelected()
        textField.insert(textField.cursorPosition, key)
    }

    function removeSelected() {
        if (textField.selectionStart === textField.selectionEnd)
            return

        var cursorPosition = textField.selectionStart
        var str = textField.text
        var newStr = str.substring(0, textField.selectionStart) + str.substring(textField.selectionEnd)
        textField.text = newStr
        textField.cursorPosition = cursorPosition
    }

    function processClickedNamed(name) {
        switch(name) {
        case "left" :
            textField.cursorPosition--
            break
        case "right" :
            textField.cursorPosition++
            break
        case "tab" :
            //            removeSelected()
            //            textField.insert(textField.cursorPosition, "\t")
            textField.nextItemInFocusChain().forceActiveFocus()
            break
        case "backspace" :
            if (textField.readOnly)
                return
            var cursorPosition = 0
            var str = ""
            var newStr = ""
            if (textField.selectionStart === textField.selectionEnd) {
                cursorPosition = textField.cursorPosition
                str = textField.text
                newStr = str.substring(0, textField.cursorPosition - 1) + str.substring(textField.cursorPosition)
                textField.text = newStr
                textField.cursorPosition = cursorPosition - 1
            } else {
                removeSelected()
            }
            break
        case "copy" :
            textField.copy()
            break
        case "cut" :
            if (textField.readOnly)
                return
            textField.cut()
            break
        case "paste" :
            if (textField.readOnly)
                return
            textField.paste()
            break
        case "undo" :
            if (textField.readOnly)
                return
            textField.undo()
            break
        case "redo" :
            if (textField.readOnly)
                return
            textField.redo()
            break
        case "enter" :
            textField.accepted()
            contentItem.forceActiveFocus()
            break
        case "layout" :
            if (keyboardItem.keyboardLayout === "en") {
                keyboardItem.keyboardLayout = "ru"
                row1.model = ru.row1
                row2.model = ru.row2
                row3.model = ru.row3
                row4.model = ru.row4
                row5.model = ru.row5
            } else {
                keyboardItem.keyboardLayout = "en"
                row1.model = en.row1
                row2.model = en.row2
                row3.model = en.row3
                row4.model = en.row4
                row5.model = en.row5

            }
        }
    }


    function processClickedChackableNamed(name) {
        switch(name) {
        case "shift" :
            privateData.shift = !privateData.shift
            break
        case "capsLock" :
            privateData.shift = false
            privateData.capsLock = !privateData.capsLock
            break
        }
    }

    Item {
        property string keyboardLayout: "en"
        id: keyboardItem
        visible: privateData.visible
        enabled: visible
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: titleRect.bottom
        height: privateData.lastKeyboardHeight
        width: 800 * height / 280

        EnKeyboardLayout {
            id: en
        }

        RuKeyboardLayout {
            id: ru
        }

        IqVkButtonsRow {
            id: row1
            model: en.row1
            y: height * 0.1
            anchors.leftMargin: height * 0.1
            height: keyboardItem.height / 5.6
            anchors.left: parent.left
            anchors.right: parent.right

            capsLock: privateData.capsLock
            shift: privateData.shift
            checkedNames: privateData.checked
            onClicked: keyboard.processClicked(key)
            onClickedNamed: keyboard.processClickedNamed(name)
            onClickedCheckableNamed: keyboard.processClickedChackableNamed(name)
        }

        IqVkButtonsRow {
            id: row2
            model: en.row2
            y: height + height * 0.2
            anchors.leftMargin: height * 0.1
            height: keyboardItem.height / 5.6
            anchors.left: parent.left
            anchors.right: parent.right

            capsLock: privateData.capsLock
            shift: privateData.shift
            onClicked: keyboard.processClicked(key)
            checkedNames: privateData.checked
            onClickedNamed: keyboard.processClickedNamed(name)
            onClickedCheckableNamed: keyboard.processClickedChackableNamed(name)
        }

        IqVkButtonsRow {
            id: row3
            model: en.row3
            y: 2 * height + height * 0.3
            anchors.leftMargin: height * 0.1
            height: keyboardItem.height / 5.6
            anchors.left: parent.left
            anchors.right: parent.right

            capsLock: privateData.capsLock
            shift: privateData.shift
            checkedNames: privateData.checked
            onClicked: keyboard.processClicked(key)
            onClickedNamed: keyboard.processClickedNamed(name)
            onClickedCheckableNamed: keyboard.processClickedChackableNamed(name)
        }

        IqVkButtonsRow {
            id: row4
            model: en.row4
            y: 3 * height + height * 0.4
            anchors.leftMargin: height * 0.1
            height: keyboardItem.height / 5.6
            anchors.left: parent.left
            anchors.right: parent.right

            capsLock: privateData.capsLock
            shift: privateData.shift
            checkedNames: privateData.checked
            onClicked: keyboard.processClicked(key)
            onClickedNamed: keyboard.processClickedNamed(name)
            onClickedCheckableNamed: keyboard.processClickedChackableNamed(name)
        }

        IqVkButtonsRow {
            id: row5
            model: en.row5
            y: 4 * height + height * 0.5
            anchors.leftMargin: height * 0.1
            height: keyboardItem.height / 5.6
            anchors.left: parent.left
            anchors.right: parent.right

            capsLock: privateData.capsLock
            shift: privateData.shift
            checkedNames: privateData.checked
            onClicked: keyboard.processClicked(key)
            onClickedNamed: keyboard.processClickedNamed(name)
            onClickedCheckableNamed: keyboard.processClickedChackableNamed(name)
        }
    }
}
