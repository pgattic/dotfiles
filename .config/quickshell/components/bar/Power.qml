import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.UPower

RowLayout {

  Repeater {
    // Only want laptop batteries
    model: UPower.devices.values.filter((device) => device.isLaptopBattery && device.isPresent)

    RowLayout {
      required property UPowerDevice modelData
      spacing: 0

      Image {
        source: `image://icon/${modelData.iconName}`
        sourceSize.width: 16
        sourceSize.height: 16
      }

      Label {
        text: `${Math.round(modelData.percentage * 100)}%`
        color: modelData.state == UPowerDeviceState.Charging ? "#00FF00" : modelData.percentage < 0.15 ? "#FF0000" : palette.active.text
      }
    }
  }
}

