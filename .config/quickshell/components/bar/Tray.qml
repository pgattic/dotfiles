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
    model: SystemTray.items.values

    Rectangle {
      required property SystemTrayItem trayItem

      color: "transparent"
      width: content.width
      height: Constants.barHeight

      Text {
        id: content
        anchors.centerIn: parent
        text: `yeet`
        color: palette.active.text
      }
    }
  }
}

