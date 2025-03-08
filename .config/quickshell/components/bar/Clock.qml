import QtQuick
import Quickshell
import Quickshell.Io
import "../../" // for Constants.qml

Text {
  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }
  text: Qt.formatDateTime(clock.date, "ddd MMM d  h:mm:ss AP")
  color: palette.active.text

  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.LeftButton

    onClicked: event => {
      calendarPopup.visible = !calendarPopup.visible;
    }
  }

  // The ugliest calendar widget you have ever seen (works tho)
  PopupWindow {
    id: calendarPopup

    // match the system theme background color
    color: "transparent"
    anchor.window: barWindow
    anchor.rect.x: parentWindow.width
    anchor.rect.y: parentWindow.height
    width: 632
    height: 196
    visible: false

    Rectangle {
      color: Constants.windowColor
      radius: 12
      anchors.fill: parent
      Rectangle {
        color: "transparent"
        anchors.fill: parent
        anchors.margins: 8
        Text {
          id: calendarText
          font.family: "monospace"
          color: "white"
        }
        Process {
          id: process_calendar
          running: true
          command: ["sh", "-c", "cal -3"]
          stdout: SplitParser {
            onRead: data => calendarText.text += data + "\n"
          }
        }
      }
    }
  }
}

