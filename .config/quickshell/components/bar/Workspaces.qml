import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "../../" // For `Constants`

RowLayout {
  id: workspaces

  spacing: 0 // Spacing for between each of those `Rectangle`s

  function getSortedWorkspaces() {
    var arr = Hyprland.workspaces.values.slice();
    arr.sort((a, b) => { return a.id - b.id; });
    return arr;
  }

  Repeater {
    model: getSortedWorkspaces()

    Rectangle {
      required property HyprlandWorkspace modelData

      width: Constants.barHeight
      height: Constants.barHeight
      color: Hyprland.focusedMonitor?.activeWorkspace.id == modelData.id ? "#444444" : "transparent"

      Text {
        anchors.centerIn: parent
        text: modelData.id == -98 ? "S" : modelData.name
        color: palette.active.text
      }

      MouseArea {
        anchors.fill: parent
        onClicked: { Hyprland.dispatch(`workspace ${modelData.id}`) }
      }
    }
  }
}

