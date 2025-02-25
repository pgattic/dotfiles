import QtQuick
import Quickshell

Text {
  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }
  text: Qt.formatDateTime(clock.date, "ddd MMM d h:mm:ss AP")
  color: palette.active.text
}

