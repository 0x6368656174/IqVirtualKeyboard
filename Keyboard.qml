import QtQuick 2.0

Rectangle {
    id: keyboard
    z: 2000
    color: "#00000000"

    property bool shift: false
    property bool ru: false
    property bool num: false
    property bool capsLockPressed: false
    property rect editElementRect: Qt.rect(0, 0, 0, 0)
    property rect permanentElementRect: Qt.rect(0, 0, 0, 0)
    property var editElement: ({})
    property var editElementPage: ({})
    property bool autoHide: true
    property real titleHeight: autoHide?0:titleRect.height

    onEditElementChanged: {
        if (editElementPage === undefined)
            return
        //Сохраним позицию объекта
        var globalEditElemetnRect = editElement.parent.mapToItem(null, editElement.x, editElement.y,
                                                             editElement.width, editElement.height)
        editElementRect = Qt.rect(globalEditElemetnRect.x, globalEditElemetnRect.y,
                                  globalEditElemetnRect.width, globalEditElemetnRect.height)

        permanentElementRect = editElementRect
        //Ищем страницу, которой принадлежит данный элемент
        editElementPage = editElement
        while (!editElementPage.isPageType) {
            editElementPage = editElementPage.parent
        }
    }

    property real lastKeyboardHeight: 270

    onShiftChanged: {
        shiftVKbButton1.checked = shift
        shiftVKbButton2.checked = shift
    }

    signal keyPressed(string key)
    signal backspacePressed()
    signal tabPressed()
    signal enterPressed()
    signal copyPressed()
    signal cutPressed()
    signal pastePressed()
    signal undoPressed()
    signal redoPressed()
    signal leftPressed()
    signal rightPressed()
    signal hidden()

    onKeyPressed: {
        if (shift)
        {
            shift = false
        }
    }

    function show()
    {
        titleRect.anchors.bottomMargin = lastKeyboardHeight
    }

    function hide()
    {
        lastKeyboardHeight = titleRect.anchors.bottomMargin
        titleRect.anchors.bottomMargin = autoHide?-title.height:0
        hidden()
    }

    //Скрывающие моусе ареа
    MouseArea {
        id: hideMA1
        x: 0
        y: 0
        visible: autoHide
        width: parent.width
        height: editElementRect.y
        onClicked: {
            hide()
        }
    }
    MouseArea {
        id: hideMA2
        x: 0
        y: 0
        visible: autoHide
        height: parent.height
        width: editElementRect.x
        onClicked: {
            hide()
        }
    }
    MouseArea {
        id: hideMA3
        x: editElementRect.x + editElementRect.width
        y: 0
        visible: autoHide
        height: parent.height
        width: parent.width - x
        onClicked: {
            hide()
        }
    }
    MouseArea {
        id: hideMA4
        x: 0
        y: editElementRect.y + editElementRect.height
        visible: autoHide
        width: parent.width
        height: parent.height - y
        onClicked: {
            hide()
        }
    }

    Rectangle {
        id: titleRect
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: autoHide?-title.height:0
        height: 20
//        y: keyboard.height - height
        color: "#1C1C1C"

        onYChanged: {
            if (y > keyboard.height - height - 10)
            {
                titlerArrow.rotation = 180
                keyboardItem.visible = false
                hideMA1.visible = false
                hideMA2.visible = false
                hideMA3.visible = false
                hideMA4.visible = false

                if (editElementPage.anchors)
                    editElementPage.anchors.topMargin = 0
            } else
            {
                titlerArrow.rotation = 0
                keyboardItem.visible = true
                hideMA1.visible = autoHide
                hideMA2.visible = autoHide
                hideMA3.visible = autoHide
                hideMA4.visible = autoHide

                //Проверим, чтоб редактируемый элемент оставлся видимым
                if (editElement.mapToItem) {
                    var thisGlobalPoint = parent.mapToItem(null, titleRect.x, titleRect.y)
                    if (thisGlobalPoint.y - 20 < permanentElementRect.y + permanentElementRect.height) {
                        //Будем подымать страничку
                        editElementPage.anchors.topMargin = -(permanentElementRect.y + permanentElementRect.height - thisGlobalPoint.y + 20)

                        //А так же смещать область, не активную для закрытия
                        var globalEditElemetnRect = editElement.parent.mapToItem(null, editElement.x, editElement.y,
                                                                             editElement.width, editElement.height)
                        editElementRect.y = globalEditElemetnRect.y

                    } else
                    {
                        if (editElementPage.anchors)
                            editElementPage.anchors.topMargin = 0

                        editElementRect.y = permanentElementRect.y
                    }
                }
            }
        }

        Behavior on anchors.bottomMargin {
            id: anchorsAnimation
            NumberAnimation {duration: 200}
        }


        Image {
            source: "dots-button.svg"
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: titlerArrow.left
            anchors.rightMargin: 25
            height: 12
            width: 50
        }

        Image {
            id: titlerArrow
            anchors.centerIn: parent
            source: "arrow-270.svg"
            height: 16
            width: 25

            Behavior on rotation {NumberAnimation {duration: 200} }
        }

        Image {
            source: "dots-button.svg"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: titlerArrow.right
            anchors.leftMargin: 25
            height: 12
            width: 50
        }

        MouseArea {
            anchors.fill: parent
            drag.target: parent
            drag.minimumY: keyboard.height - (parent.width / 820 * 270 + 10 + height)
            drag.maximumY: keyboard.height - height
            onClicked: {
                if (titleRect.y >= keyboard.height - titleRect.height)
                {
                    show()
                } else
                {
                    hide()
                }
            }
            onPressed: {
                titleRect.anchors.bottom = undefined
            }
            onReleased: {
                anchorsAnimation.enabled = false
                titleRect.anchors.bottomMargin = keyboard.height - titleRect.y - titleRect.height
                titleRect.anchors.bottom = keyboard.bottom
                anchorsAnimation.enabled = true
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

    Item {
        id: keyboardItem
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: titleRect.bottom
        anchors.topMargin: 5
        width: row1.width
        scale: (keyboard.height - titleRect.y - titleRect.height - 10) / 270

        Row {
            id: row1
            anchors.left: parent.left
            anchors.top: parent.top
            spacing: 5

            VKbButton {
                engValue: "`"
                shiftEngValue: "~"
                ruValue: "ё"
                width: 30
                onClicked: keyPressed(key)
                shift: keyboard.shift | keyboard.capsLockPressed
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "1"
                shiftEngValue: "!"
                ruValue: "1"
                shiftRuValue: "!"
                onClicked: keyPressed(key)
                shift: keyboard.shift
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "2"
                shiftEngValue: "@"
                ruValue: "2"
                shiftRuValue: "\""
                onClicked: keyPressed(key)
                shift: keyboard.shift
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "3"
                shiftEngValue: "#"
                ruValue: "3"
                shiftRuValue: "№"
                onClicked: keyPressed(key)
                shift: keyboard.shift
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "4"
                shiftEngValue: "$"
                ruValue: "4"
                shiftRuValue: ";"
                onClicked: keyPressed(key)
                shift: keyboard.shift
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "5"
                shiftEngValue: "%"
                ruValue: "5"
                shiftRuValue: "%"
                onClicked: keyPressed(key)
                shift: keyboard.shift
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "6"
                shiftEngValue: "^"
                ruValue: "6"
                shiftRuValue: ":"
                onClicked: keyPressed(key)
                shift: keyboard.shift
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "7"
                shiftEngValue: "&"
                ruValue: "7"
                shiftRuValue: "?"
                onClicked: keyPressed(key)
                shift: keyboard.shift
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "8"
                shiftEngValue: "*"
                ruValue: "8"
                shiftRuValue: "*"
                onClicked: keyPressed(key)
                shift: keyboard.shift
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "9"
                shiftEngValue: "("
                ruValue: "9"
                shiftRuValue: "("
                onClicked: keyPressed(key)
                shift: keyboard.shift
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "0"
                shiftEngValue: ")"
                ruValue: "0"
                shiftRuValue: ")"
                onClicked: keyPressed(key)
                shift: keyboard.shift
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "-"
                shiftEngValue: "_"
                ruValue: "-"
                shiftRuValue: "_"
                onClicked: keyPressed(key)
                shift: keyboard.shift
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "="
                shiftEngValue: "+"
                ruValue: "="
                shiftRuValue: "+"
                onClicked: keyPressed(key)
                shift: keyboard.shift
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "Backspace"
                shiftEngValue: "Backspace"
                ruValue: "Backspace"
                shiftRuValue: "Backspace"
                width: 115
                textHeightPrc: 0.3
                backgroundColor: "#1C1C1C"
                onClicked: backspacePressed()
                shift: keyboard.shift | keyboard.capsLockPressed
                ru: keyboard.ru
            }

        }

        Row {
            id: row2
            anchors.left: parent.left
            anchors.top: row1.bottom
            anchors.topMargin: 5
            spacing: 5

            VKbButton {
                engValue: "Tab"
                shiftEngValue: "Tab"
                ruValue: "Tab"
                shiftRuValue: "Tab"
                width: 55
                textHeightPrc: 0.3
                backgroundColor: "#1C1C1C"
                onClicked: tabPressed()
                shift: keyboard.shift | keyboard.capsLockPressed
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "q"
                ruValue: "й"
                onClicked: keyPressed(key)
                shift: keyboard.shift | keyboard.capsLockPressed
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "w"
                ruValue: "ц"
                onClicked: keyPressed(key)
                shift: keyboard.shift | keyboard.capsLockPressed
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "e"
                ruValue: "у"
                onClicked: keyPressed(key)
                shift: keyboard.shift | keyboard.capsLockPressed
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "r"
                ruValue: "к"
                onClicked: keyPressed(key)
                shift: keyboard.shift | keyboard.capsLockPressed
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "t"
                ruValue: "е"
                onClicked: keyPressed(key)
                shift: keyboard.shift | keyboard.capsLockPressed
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "y"
                ruValue: "н"
                onClicked: keyPressed(key)
                shift: keyboard.shift | keyboard.capsLockPressed
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "u"
                ruValue: "г"
                onClicked: keyPressed(key)
                shift: keyboard.shift | keyboard.capsLockPressed
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "i"
                ruValue: "ш"
                onClicked: keyPressed(key)
                shift: keyboard.shift | keyboard.capsLockPressed
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "o"
                ruValue: "щ"
                onClicked: keyPressed(key)
                shift: keyboard.shift | keyboard.capsLockPressed
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "p"
                ruValue: "з"
                onClicked: keyPressed(key)
                shift: keyboard.shift | keyboard.capsLockPressed
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "["
                shiftEngValue: "{"
                ruValue: "х"
                onClicked: keyPressed(key)
                shift: keyboard.shift | keyboard.capsLockPressed
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "]"
                shiftEngValue: "}"
                ruValue: "ъ"
                onClicked: keyPressed(key)
                shift: keyboard.shift | keyboard.capsLockPressed
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "\\"
                shiftEngValue: "|"
                ruValue: "\\"
                shiftRuValue: "/"
                width: 90
                onClicked: keyPressed(key)
                shift: keyboard.shift | keyboard.capsLockPressed
                ru: keyboard.ru
            }
        }

        Row {
            id: row3
            anchors.top: row2.bottom
            anchors.left: parent.left
            anchors.topMargin: 5
            spacing: 5
            VKbCheckedButton {
                engValue: "CapsLock"
                shiftEngValue: "CapsLock"
                ruValue: "CapsLock"
                shiftRuValue: "CapsLock"
                textHeightPrc: 0.3
                backgroundColor: "#1C1C1C"
                width: 80
                onCheckedChanged: keyboard.capsLockPressed = checked
                checked: keyboard.capsLockPressed
            }
            VKbButton {
                engValue: "a"
                ruValue: "ф"
                onClicked: keyPressed(key)
                shift: keyboard.shift | keyboard.capsLockPressed
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "s"
                ruValue: "ы"
                onClicked: keyPressed(key)
                shift: keyboard.shift | keyboard.capsLockPressed
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "d"
                ruValue: "в"
                onClicked: keyPressed(key)
                shift: keyboard.shift | keyboard.capsLockPressed
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "f"
                ruValue: "а"
                onClicked: keyPressed(key)
                shift: keyboard.shift | keyboard.capsLockPressed
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "g"
                ruValue: "п"
                onClicked: keyPressed(key)
                shift: keyboard.shift | keyboard.capsLockPressed
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "h"
                ruValue: "р"
                onClicked: keyPressed(key)
                shift: keyboard.shift | keyboard.capsLockPressed
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "j"
                ruValue: "о"
                onClicked: keyPressed(key)
                shift: keyboard.shift | keyboard.capsLockPressed
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "k"
                ruValue: "л"
                onClicked: keyPressed(key)
                shift: keyboard.shift | keyboard.capsLockPressed
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "l"
                ruValue: "д"
                onClicked: keyPressed(key)
                shift: keyboard.shift | keyboard.capsLockPressed
                ru: keyboard.ru
            }
            VKbButton {
                engValue: ";"
                shiftEngValue: ":"
                ruValue: "ж"
                onClicked: keyPressed(key)
                shift: keyboard.shift | keyboard.capsLockPressed
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "'"
                shiftEngValue: "\""
                ruValue: "э"
                onClicked: keyPressed(key)
                shift: keyboard.shift | keyboard.capsLockPressed
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "Enter"
                shiftEngValue: "Enter"
                ruValue: "Enter"
                shiftRuValue: "Enter"
                width: 120
                textHeightPrc: 0.3
                backgroundColor: "#1C1C1C"
                onClicked: enterPressed()
                shift: keyboard.shift | keyboard.capsLockPressed
                ru: keyboard.ru
            }
        }

        Row {
            id: row4
            anchors.top: row3.bottom
            anchors.left: parent.left
            anchors.topMargin: 5
            spacing: 5

            VKbCheckedButton {
                id: shiftVKbButton1
                engValue: "Shift"
                shiftEngValue: "Shift"
                ruValue: "Shift"
                shiftRuValue: "Shift"
                textHeightPrc: 0.3
                width: 105
                onCheckedChanged: keyboard.shift = checked
            }
            VKbButton {
                engValue: "z"
                ruValue: "я"
                onClicked: keyPressed(key)
                shift: keyboard.shift | keyboard.capsLockPressed
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "x"
                ruValue: "ч"
                onClicked: keyPressed(key)
                shift: keyboard.shift | keyboard.capsLockPressed
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "c"
                ruValue: "с"
                onClicked: keyPressed(key)
                shift: keyboard.shift | keyboard.capsLockPressed
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "v"
                ruValue: "м"
                onClicked: keyPressed(key)
                shift: keyboard.shift | keyboard.capsLockPressed
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "b"
                ruValue: "и"
                onClicked: keyPressed(key)
                shift: keyboard.shift | keyboard.capsLockPressed
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "n"
                ruValue: "т"
                onClicked: keyPressed(key)
                shift: keyboard.shift | keyboard.capsLockPressed
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "m"
                ruValue: "ь"
                onClicked: keyPressed(key)
                shift: keyboard.shift | keyboard.capsLockPressed
                ru: keyboard.ru
            }
            VKbButton {
                engValue: ","
                shiftEngValue: "<"
                ruValue: "б"
                onClicked: keyPressed(key)
                shift: keyboard.shift | keyboard.capsLockPressed
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "."
                shiftEngValue: ">"
                ruValue: "ю"
                onClicked: keyPressed(key)
                shift: keyboard.shift | keyboard.capsLockPressed
                ru: keyboard.ru
            }
            VKbButton {
                engValue: "/"
                shiftEngValue: "?"
                ruValue: "."
                shiftRuValue: ","
                onClicked: keyPressed(key)
                shift: keyboard.shift | keyboard.capsLockPressed
                ru: keyboard.ru
            }
            VKbCheckedButton {
                id: shiftVKbButton2
                engValue: "Shift"
                shiftEngValue: "Shift"
                ruValue: "Shift"
                shiftRuValue: "Shift"
                width: 150
                textHeightPrc: 0.3
                onCheckedChanged: keyboard.shift = checked
            }
        }

        Row {
            id: row5
            anchors.top: row4.bottom
            anchors.left: parent.left
            anchors.topMargin: 5
            spacing: 5
            VKbButton {
                engValue: "Copy"
                shiftEngValue: "Copy"
                ruValue: "Copy"
                shiftRuValue: "Copy"
                textHeightPrc: 0.3
                backgroundColor: "#1C1C1C"
                onClicked: copyPressed()
            }
            VKbButton {
                engValue: "Cut"
                shiftEngValue: "Cut"
                ruValue: "Cut"
                shiftRuValue: "Cut"
                textHeightPrc: 0.3
                backgroundColor: "#1C1C1C"
                onClicked: cutPressed()
            }
            VKbButton {
                engValue: "Paste"
                shiftEngValue: "Paste"
                ruValue: "Paste"
                shiftRuValue: "Paste"
                textHeightPrc: 0.3
                backgroundColor: "#1C1C1C"
                onClicked: pastePressed()
            }
            VKbButton {
                engValue: {
                    if (keyboard.ru)
                    {
                        return "ru"
                    } else
                    {
                        return "eng"
                    }
                }

                shiftEngValue: engValue
                ruValue: engValue
                shiftRuValue: engValue
                textHeightPrc: 0.3
                backgroundColor: "#1C1C1C"
                onClicked: {
                    keyboard.ru = !keyboard.ru
                }
            }
            VKbButton {
                engValue: " "
                shiftEngValue: " "
                ruValue: " "
                shiftRuValue: " "
                width: 265
                onClicked: keyPressed(key)
                shift: keyboard.shift | keyboard.capsLockPressed
                ru: keyboard.ru
            }
            VKbButton {
                engValue: {
                    if (keyboard.ru)
                    {
                        return "ru"
                    } else
                    {
                        return "eng"
                    }
                }

                shiftEngValue: engValue
                ruValue: engValue
                shiftRuValue: engValue
                textHeightPrc: 0.3
                backgroundColor: "#1C1C1C"
                onClicked: {
                    keyboard.ru = !keyboard.ru
                }
            }
            VKbButton {
                engValue: "Undo"
                shiftEngValue: "Undo"
                ruValue: "Undo"
                shiftRuValue: "Undo"
                textHeightPrc: 0.3
                backgroundColor: "#1C1C1C"
                onClicked: undoPressed()
            }
            VKbButton {
                engValue: "Redo"
                shiftEngValue: "Redo"
                ruValue: "Redo"
                shiftRuValue: "Redo"
                textHeightPrc: 0.3
                backgroundColor: "#1C1C1C"
                onClicked: redoPressed()
            }
            VKbButton {
                engValue: "Left"
                shiftEngValue: "Left"
                ruValue: "Left"
                shiftRuValue: "Left"
                textHeightPrc: 0.3
                width: 75
                backgroundColor: "#1C1C1C"
                onClicked: leftPressed()
            }
            VKbButton {
                engValue: "Right"
                shiftEngValue: "Right"
                ruValue: "Right"
                shiftRuValue: "Right"
                textHeightPrc: 0.3
                width: 75
                backgroundColor: "#1C1C1C"
                onClicked: rightPressed()
            }

        }
    }
}
