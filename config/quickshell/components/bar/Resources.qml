import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../../utils/bar" as Utils

RowLayout {
  id: resources
  spacing: 10

  RowLayout {
    id: cpu_usage
    property int cores: 8

    Image {
      source: "image://icon/cpu-frequency-indicator"
      sourceSize.width: 16
      sourceSize.height: 16
    }
    Rectangle {
      width: 4 * cpu_usage.cores + 4  // Utils.Resources.cpu_cores_percent.length
      height: 20
      color: "transparent"
      border.color: Utils.Resources.cpu_percent > 90 ? "red" : "gray"
      border.width: 1

      RowLayout {
        anchors.fill: parent
        anchors.margins: 2
        spacing: 0

        Repeater {
          model: Utils.Resources.cpu_cores_percent
          Rectangle {
            width: 4
            height: (modelData / 100) * 16
            color: Qt.hsla((1/3) - (modelData/300), 1, .5, .75)
            anchors.bottom: parent.bottom
          }
        }
      }
    }
    //Label {
    //  color: palette.active.text
    //  text: Utils.Resources.cpu_percent + "%"
    //  Layout.alignment: Qt.AlignCenter
    //}
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

