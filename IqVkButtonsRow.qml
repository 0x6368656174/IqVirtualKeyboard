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

ListView {
    property bool shift: false
    property bool capsLock: false
    property var checkedNames: []

    signal clicked(var key)
    signal clickedNamed(var name)
    signal clickedCheckableNamed(var name)

    id: rowListView
    spacing: height/10
    orientation: ListView.Horizontal
    implicitHeight: 50
    interactive: false


    delegate: IqVkButton {
        value: {
            if (typeof model.value !== 'undefined')
                return model.value
            if (typeof model.name !== 'undefined'
                    && model.name === "layout")
                return rowListView.model.layoutName.toUpperCase()
            return ""
        }
        shiftValue: {
            if (typeof model.shiftValue !== 'undefined'
                    && model.shiftValue !== "")
                return model.shiftValue
            if (typeof model.name !== 'undefined'
                    && model.name === "layout")
                return rowListView.model.layoutName.toUpperCase()
            return value.toUpperCase()
        }
        width: {
            if (typeof model.width !== 'undefined'
                    && model.width !== 0)
                return parent.height / 50 * model.width
            return parent.height
        }
        textHeightPrc: {
            if (typeof model.textHeightPrc !== 'undefined'
                    && model.textHeightPrc !== 0)
                return model.textHeightPrc
            return 0.5
        }
        backgroundColor: {
            if (typeof model.backgroundColor !== 'undefined'
                    && model.backgroundColor !== "")
                return model.backgroundColor
            return "#363636"
        }
        iconName: {
            if (typeof model.iconName !== 'undefined')
                return model.iconName
            return ""
        }
        iconPosition: {
            if (typeof model.iconPosition !== 'undefined')
                return model.iconPosition
            return ""
        }
        shift: {
            if (typeof model.disableShiftOnCapsLock !== 'undefined'
                    && model.disableShiftOnCapsLock)
                return rowListView.shift
            return rowListView.shift | rowListView.capsLock
        }
        isCheckable: {
            if (typeof model.checkable !== 'undefined')
                return model.checkable
            return false
        }

        height: parent.height

        isChecked: {
            if (typeof model.name !== 'undefined'
                    && model.name !== "") {
                return checkedNames.indexOf(model.name) !== -1
            }
            return false
        }

        onClicked: {
            if (typeof model.name !== 'undefined'
                    && model.name !== "") {
                if (isCheckable)
                    rowListView.clickedCheckableNamed(model.name)
                else
                    rowListView.clickedNamed(model.name)
            } else {
                if (shift)
                    rowListView.clicked(shiftValue)
                else
                    rowListView.clicked(value)
            }
        }
    }
}
