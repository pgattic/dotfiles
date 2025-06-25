import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

// NOTE: This is currently a stub, it has no interaction with the desktop.

RowLayout {

  function determineIconName(brightness) {
    if (brightness >= 0.7) {
      return "brightness-high-symbolic"
    }
    if (brightness >= 0.3) {
      return "brightness-medium-symbolic"
    }
    return "brightness-low-symbolic"
  }

  Image {
    source: `image://icon/${determineIconName(0.2)}`

    sourceSize.width: 16
    sourceSize.height: 16
  }

  Label {
    text: `20%`
  }

}

