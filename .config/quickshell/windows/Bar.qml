import Quickshell // for ShellRoot and PanelWindow
import QtQuick // for Text
import QtQuick.Layouts
import "../components/bar"

PanelWindow {
  id: barWindow
  anchors {
    top: true
    left: true
    right: true
  }

  height: 30 // NOTE: My Waybar's height was 24

  Rectangle {
    id: bar
    anchors.fill: parent
    // This somehow gets the QT window color :) Will have to read up on this
    color: contentItem.palette.active.window

    // Left
    RowLayout {
      id: barLeft
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      anchors.top: parent.top
      anchors.leftMargin: 5

      spacing: 5

      // Left-aligned items go here
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
      Important {}
    }

    // Right
    RowLayout {
      id: barRight

      anchors.bottom: parent.bottom
      anchors.right: parent.right
      anchors.top: parent.top
      anchors.rightMargin: 5

      spacing: 5

      // Right-aligned items go here
      Clock {}
    }
  }
}

// https://quickshell.outfoxxed.me/docs/types/Quickshell/PopupWindow
//PopupWindow {
//  anchor.window: main
//  anchor.rect.x: parentWindow.width / 2 - width / 2
//  anchor.rect.y: parentWindow.height
//  width: 500
//  height: 500
//  visible: false
//}
