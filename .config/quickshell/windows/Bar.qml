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
    // This somehow gets the QT window color :) Will have to read up on this
    color: palette.active.window

    // Left
    RowLayout {
      id: barLeft

      anchors.bottom: parent.bottom
      anchors.left: parent.left
      anchors.top: parent.top
      //anchors.leftMargin: 5

      spacing: 5

      // Left-aligned items go here
      Workspaces {}
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
      anchors.rightMargin: 5

      spacing: 8

      // Right-aligned items go here
      Tray {}
      Mixer {}
      Power {}
      Clock {}
    }
  }
}

