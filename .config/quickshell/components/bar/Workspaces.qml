import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "../../"

// TODO: Sort the workspaces by their `id` attribute (they currently just vibe with whatever order)

RowLayout {
  id: workspaces

  spacing: 0 // Spacing for between each of those `Rectangle`s

  // Proxy model to handle sorting
  //SortFilterProxyModel {
  //  id: sortedWorkspaces
  //  sourceModel: Hyprland.workspaces
  //  sortRole: "id"  // Ensure this role exists in your model
  //  sortOrder: Qt.AscendingOrder
  //}

  //Component.onCompleted: {
  //  // Assuming the "id" attribute is in column 0:
  //  Hyprland.workspaces.values.sort(0, Qt.AscendingOrder)
  //}

  Repeater {
    model: Hyprland.workspaces.values

    Rectangle {
      required property HyprlandWorkspace modelData

      width: Constants.barHeight
      height: Constants.barHeight
      color: Hyprland.focusedMonitor?.activeWorkspace.id == modelData.id ? "#444444" : "transparent"

      Text {
        anchors.centerIn: parent
        text: modelData.name
        color: palette.active.text
      }

      MouseArea {
        anchors.fill: parent
        onClicked: { Hyprland.dispatch(`workspace ${modelData.id}`) }
      }
    }
  }
}
