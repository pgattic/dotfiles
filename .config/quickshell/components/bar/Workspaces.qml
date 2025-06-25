import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "../../" // For `Constants`

RowLayout {
  id: workspaces

  spacing: 0 // Spacing for between each of those `Rectangle`s

  Repeater {
    model: Hyprland.workspaces.values

    Rectangle {
      required property HyprlandWorkspace modelData

      width: 24
      height: Constants.barHeight
      color: "transparent"
      //color: Hyprland.focusedMonitor?.activeWorkspace.id == modelData.id ? "#2FFFFFFF" : "transparent"

      Text {
        anchors.centerIn: parent
        text: modelData.id == -98 ? "S" : modelData.name
        color: Hyprland.focusedMonitor?.activeWorkspace.id == modelData.id ? "#4488FF" : palette.active.text
      }

      MouseArea {
        anchors.fill: parent
        onClicked: { Hyprland.dispatch(`workspace ${modelData.id}`) }
      }
    }
  }
}

