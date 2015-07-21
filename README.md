# IqVirtualKeyboard
Simle virtual keyboard for Qt.

![Image of IqVirtualKeyboard]
(http://itquasar.ru/github_images/IqVirtualKeyboard.png)

## Install
In project folder run command:
~~~~~~{.sh}
git clone https://github.com/ItQuasarOrg/IqVirtualKeyboard.git
git submodule init
git submodule update
~~~~~~

##Usage (QML):

Create custom TextField like this
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

Append IqVirtualKeyboard to main.qml
~~~~~~{.qml}
//main.qml
import QtQuick 2.4
import QtQuick.Window 2.2
import "IqVirtualKeyboard"

Window {
  Item {
    id: content
    width: parent.width      //in root content item don't use layouts or anchors,
                             //use only width = parent.width
    height: parent.height    //in root content item don't use layouts or anchors, 
                             //use only height = parent.height
    
    //some content childs with MyTextField
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

