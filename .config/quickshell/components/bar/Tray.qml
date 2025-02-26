import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import "../../"

RowLayout {
  //id: trayIcons

  //Text {
  //  text: `This many apps: ${SystemTray.items.values.length}`
  //}

  Repeater {
    model: SystemTray.items

    RowLayout {
      required property SystemTrayItem modelData

      Image {
        source: modelData.icon
    //source: `image://icon/emblem-information`
        sourceSize.width: 16
        sourceSize.height: 16
      }

      MouseArea {
        anchors.fill: parent
        onClicked: event => {
          event.accepted = true;

          if (event.button == Qt.LeftButton) {
            modelData.activate();
          } else if (event.button == Qt.MiddleButton) {
            modelData.secondaryActivate();
          }
        }
      }

      //Text {
      //  id: content
      //  anchors.centerIn: parent
      //  text: modelData.icon
      //  color: palette.active.text
      //}
    }
  }
}

