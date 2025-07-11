import Quickshell // for ShellRoot and PanelWindow
import QtQuick // for Text
import QtQuick.Layouts
import "../components/bar"
import "../"

import Quickshell.Hyprland

PanelWindow {
  id: barWindow

  anchors {
    top: true
    left: true
    right: true
  }

  height: Constants.barHeight
  color: "transparent"

  Rectangle {
    id: bar
    anchors.fill: parent
    color: Constants.windowColor

    // Left
    RowLayout {
      id: barLeft

      anchors.bottom: parent.bottom
      anchors.left: parent.left
      anchors.top: parent.top
      //anchors.leftMargin: 5

      spacing: 12

      // Left-aligned items go here
      Workspaces {}
      Resources {}
      Important {}
    }

    // Middle
    RowLayout {
      id: barMiddle

      anchors.bottom: parent.bottom
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: parent.top

      spacing: 5

      // Center-aligned items go here
      CurrentApp {}
    }

    // Right
    RowLayout {
      id: barRight

      anchors.bottom: parent.bottom
      anchors.right: parent.right
      anchors.top: parent.top
      anchors.rightMargin: 12

      spacing: 10

      // Right-aligned items go here
      Tray {}
      //Brightness {}
      Mixer {}
      Power {}
      Clock {}
    }
  }
}

