import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../../utils/bar" as Utils

RowLayout {
  id: resources

  RowLayout {
    Image {
      source: "image://icon/cpu"
      sourceSize.width: 16
      sourceSize.height: 16
    }
    Label {
      color: palette.active.text
      text: Utils.Resources.cpu_percent + "%"
      Layout.alignment: Qt.AlignCenter
    }
    Rectangle {
      id: cpu_box
      width: 4 * 8 + 4  // Adjust width to fit the bars, Utils.Resources.cpu_cores_percent.length
      height: 20 // Box height
      color: "transparent"
      border.color: "gray"
      border.width: 1

      RowLayout {
        id: cpu_bars
        anchors.fill: parent
        anchors.margins: 2
        spacing: 0

        Repeater {
          model: Utils.Resources.cpu_cores_percent
          Rectangle {
            width: 4
            height: (modelData / 100) * 16
            color: Qt.hsla((1/3) - (modelData/300), 1, .5, .75)
            anchors.bottom: parent.bottom // Align bars to the bottom
          }
        }
      }
    }
  }

  RowLayout {
    Image {
      source: "image://icon/gnome-dev-memory"
      sourceSize.width: 16
      sourceSize.height: 16
    }
    Label {
      color: palette.active.text
      text: Utils.Resources.mem_used
      Layout.alignment: Qt.AlignCenter
    }
  }
}

