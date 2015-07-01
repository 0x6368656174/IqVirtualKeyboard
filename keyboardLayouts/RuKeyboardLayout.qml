import QtQuick 2.4

Item {
    id: layout
    readonly property string name: "ru"

    property alias row1: row1Model
    property alias row2: row2Model
    property alias row3: row3Model
    property alias row4: row4Model
    property alias row5: row5Model

    ListModel {
        readonly property string layoutName: layout.name
        id: row1Model

        ListElement {
            value: "ё"
            width: 30
        }
        ListElement {
            value: "1"
            shiftValue: "!"
            disableShiftOnCapsLock: true
        }
        ListElement {
            value: "2"
            shiftValue: "\""
            disableShiftOnCapsLock: true
        }
        ListElement {
            value: "3"
            shiftValue: "№"
            disableShiftOnCapsLock: true
        }
        ListElement {
            value: "4"
            shiftValue: ";"
            disableShiftOnCapsLock: true
        }
        ListElement {
            value: "5"
            shiftValue: "%"
            disableShiftOnCapsLock: true
        }
        ListElement {
            value: "6"
            shiftValue: ":"
            disableShiftOnCapsLock: true
        }
        ListElement {
            value: "7"
            shiftValue: "?"
            disableShiftOnCapsLock: true
        }
        ListElement {
            value: "8"
            shiftValue: "*"
            disableShiftOnCapsLock: true
        }
        ListElement {
            value: "9"
            shiftValue: "("
            disableShiftOnCapsLock: true
        }
        ListElement {
            value: "0"
            shiftValue: ")"
            disableShiftOnCapsLock: true
        }
        ListElement {
            value: "-"
            shiftValue: "_"
            disableShiftOnCapsLock: true
        }
        ListElement {
            value: "="
            shiftValue: "+"
            disableShiftOnCapsLock: true
        }
        ListElement {
            name: "backspace"
            value: "Backspace"
            shiftValue: "Backspace"
            width: 95
            backgroundColor: "#1C1C1C"
            iconName: "longArrowLeft"
            iconPosition: "bottom"
            textHeightPrc: 0.3
        }
    }

    ListModel {
        readonly property string layoutName: layout.name
        id: row2Model

        ListElement {
            name: "tab"
            value: "Tab"
            shiftValue: "Tab"
            width: 55
            backgroundColor: "#1C1C1C"
            iconName: "exchange"
            iconPosition: "left"
            textHeightPrc: 0.3
        }
        ListElement {
            value: "й"
        }
        ListElement {
            value: "ц"
        }
        ListElement {
            value: "у"
        }
        ListElement {
            value: "к"
        }
        ListElement {
            value: "е"
        }
        ListElement {
            value: "н"
        }
        ListElement {
            value: "г"
        }
        ListElement {
            value: "ш"
        }
        ListElement {
            value: "щ"
        }
        ListElement {
            value: "з"
        }
        ListElement {
            value: "х"
        }
        ListElement {
            value: "ъ"
        }
        ListElement {
            value: "\\"
            shiftValue: "/"
            width: 70
        }
    }

    ListModel {
        readonly property string layoutName: layout.name
        id: row3Model

        ListElement {
            name: "capsLock"
            value: "CapsLock"
            shiftValue: "CapsLock"
            backgroundColor: "#1C1C1C"
            width: 80
            checkable: true
            textHeightPrc: 0.3
        }
        ListElement {
            value: "ф"
        }
        ListElement {
            value: "ы"
        }
        ListElement {
            value: "в"
        }
        ListElement {
            value: "а"
        }
        ListElement {
            value: "п"
        }
        ListElement {
            value: "р"
        }
        ListElement {
            value: "о"
        }
        ListElement {
            value: "л"
        }
        ListElement {
            value: "д"
        }
        ListElement {
            value: "ж"
        }
        ListElement {
            value: "э"
        }
        ListElement {
            name: "enter"
            value: "Enter"
            shiftValue: "Enter"
            width: 100
            backgroundColor: "#1C1C1C"
            textHeightPrc: 0.3
        }
    }

    ListModel {
        readonly property string layoutName: layout.name
        id: row4Model
        ListElement {
            name: "shift"
            value: "Shift"
            shiftValue: "Shift"
            width: 105
            checkable: true
            iconName: "arrowUp"
            iconPosition: "left"
            textHeightPrc: 0.3
        }
        ListElement {
            value: "я"
        }
        ListElement {
            value: "ч"
        }
        ListElement {
            value: "с"
        }
        ListElement {
            value: "м"
        }
        ListElement {
            value: "и"
        }
        ListElement {
            value: "т"
        }
        ListElement {
            value: "ь"
        }
        ListElement {
            value: "б"
        }
        ListElement {
            value: "ю"
        }
        ListElement {
            value: "."
            shiftValue: ","
        }
        ListElement {
            name: "shift"
            value: "Shift"
            shiftValue: "Shift"
            width: 130
            checkable: true
            iconName: "arrowUp"
            iconPosition: "left"
            textHeightPrc: 0.3
        }
    }

    ListModel {
        readonly property string layoutName: layout.name
        id: row5Model
        ListElement {
            name: "copy"
            value: "Copy"
            shiftValue: "Copy"
            backgroundColor: "#1C1C1C"
            iconName: "copy"
            iconPosition: "top"
            textHeightPrc: 0.3
        }
        ListElement {
            name: "cut"
            value: "Cut"
            shiftValue: "Cut"
            backgroundColor: "#1C1C1C"
            iconName: "cut"
            iconPosition: "top"
            textHeightPrc: 0.3
        }
        ListElement {
            name: "paste"
            value: "Paste"
            shiftValue: "Paste"
            backgroundColor: "#1C1C1C"
            iconName: "paste"
            iconPosition: "top"
            textHeightPrc: 0.3
        }
        ListElement {
            name: "layout"
            backgroundColor: "#1C1C1C"
            iconName: "globe"
            iconPosition: "top"
            textHeightPrc: 0.3
        }
        ListElement {
            value: " "
            shiftValue: " "
            width: 275
        }
        ListElement {
            name: "layout"
            backgroundColor: "#1C1C1C"
            iconName: "globe"
            iconPosition: "top"
            textHeightPrc: 0.3
        }
        ListElement {
            name: "undo"
            value: "Undo"
            shiftValue: "Undo"
            backgroundColor: "#1C1C1C"
            iconName: "undo"
            iconPosition: "top"
            textHeightPrc: 0.3
        }
        ListElement {
            name: "redo"
            value: "Redo"
            shiftValue: "Redo"
            backgroundColor: "#1C1C1C"
            iconName: "repeat"
            iconPosition: "top"
            textHeightPrc: 0.3
        }
        ListElement {
            name: "left"
            value: "Left"
            shiftValue: "Left"
            width: 60
            backgroundColor: "#1C1C1C"
            iconName: "longArrowLeft"
            iconPosition: "top"
            textHeightPrc: 0.3
        }
        ListElement {
            name: "right"
            value: "Right"
            shiftValue: "Right"
            width: 60
            backgroundColor: "#1C1C1C"
            iconName: "longArrowRight"
            iconPosition: "top"
            textHeightPrc: 0.3
        }
    }
}
