# IqVirtualKeyboard
Простая виртуальная клавиатура для Qt.

## Установка
В папке с проектом выполните:
~~~~~~{.sh}
git clone https://github.com/ItQuasarOrg/IqVirtualKeyboard.git
git submodule init
git submodule update
~~~~~~

## Использование (QML):

Создайте пользовательский TextField на подобии следующего
~~~~~~{.qml}
//MyTextField.qml
import QtQuick 2.4
import QtQuick.Controls 1.3
TextField {
  id: myTextField
  onActiveFocusChanged: {
    if (activeFocus)
      virtualKeyboard.textField = myTextField
    else if (virtualKeyboard.textField === myTextField)
      virtualKeyboard.textField = null
  }
}
~~~~~~

Добавьте IqVirtualKeyboard в main.qml
~~~~~~{.qml}
//main.qml
import QtQuick 2.4
import QtQuick.Window 2.2
import "IqVirtualKeyboard"

Window {
  Item {
    id: content
    width: parent.width      //в главном элементе с содержимым не используйте для позиционирования 
                             //layouts или anchors, используйте только width = parent.width
    height: parent.height    //в главном элементе с содержимым не используйте для позиционирования 
                             //layouts или anchors, используйте только height = parent.height
    
    //какое-то содержимое, в котором присутствует MyTextField
    MyTextField {
    }
  }
  
  IqVirtualKeyboard {
    id: virtualKeyboard
    contentItem: content
    anchors.fill: parent
  }
}
~~~~~~
