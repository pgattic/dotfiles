import Quickshell
import QtQuick
//import "../../utils/bar"

Rectangle {
  implicitWidth: clockText.width

  // CLOCK & CLOCK WIDGET
  // https://quickshell.outfoxxed.me/docs/types/Quickshell/SystemClock
  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }

  Text {
    id: clockText
    anchors.centerIn: parent
    color: palette.active.text
    // formatDateTime reference: https://doc.qt.io/qt-6/qml-qtqml-qt.html#formatDateTime-method
    text: Qt.formatDateTime(clock.date, "ddd MMM d h:mm:ss AP")
  }
}

