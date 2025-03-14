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

      function formatSecs(seconds) {

        let plural = (x) => {return x == 1 ? "" : "s"}

        let hours = Math.floor(seconds / 3600);
        let minutes = Math.floor((seconds / 60) % 60);
        let result = []
        if (hours != 0) {
          result.push(hours + " hour" + plural(hours));
        }
        if (minutes != 0) {
          result.push(minutes + " minute" + plural(minutes));
        }
        if (result.length == 0 || seconds % 60 != 0) {
          result.push(seconds % 60 + " second" + plural(seconds % 60));
        }
        return result.join(", ");
      }

      function toolTipText() {
        if (modelData.timeToFull != 0) { // Charging
          return `${formatSecs(modelData.timeToFull)} until full`;
        } else if (modelData.timeToEmpty != 0) { // Discharging
          return `${formatSecs(modelData.timeToEmpty)} until empty`;
        } else if (modelData.percentage == 1) {
          return "Full";
        } else if (modelData.percentage == 0) {
          return "Empty";
        }
        return "Idle";
      }

      function batIcon(percentage, charging) {
        const range = Math.round(percentage * 10) * 10;
        const rangeStr = ("" + range).padStart(3, '0');
        return `image://icon/battery-${rangeStr}${charging ? "-charging" : ""}`
      }

      MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        ToolTip.visible: containsMouse
        ToolTip.text: toolTipText()
        ToolTip.delay: 100
      }

      Image {
        source: batIcon(modelData.percentage, modelData.state == UPowerDeviceState.Charging)
        sourceSize.width: 16
        sourceSize.height: 16
      }

      Label {
        text: `${Math.round(modelData.percentage * 100)}%`
        color: modelData.state == UPowerDeviceState.Charging ? "#4caf50" : modelData.percentage < 0.15 ? "#f44336" : palette.active.text // Colors stolen from Papirus Icon Theme
      }
    }
  }
}

