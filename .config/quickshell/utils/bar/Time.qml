pragma Singleton

import Quickshell
import QtQuick

// Keeps track of time and stores it in a variable.
// https://quickshell.outfoxxed.me/docs/types/Quickshell/SystemClock
Singleton {
  property string time

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }

  Timer {
    interval: 1000
    running: true
    repeat: true

    // formatDateTime reference: https://doc.qt.io/qt-6/qml-qtqml-qt.html#formatDateTime-method
    onTriggered: time = Qt.formatDateTime(clock.date, "ddd MMM d h:mm:ss AP")
  }
}

