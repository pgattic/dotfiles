import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.UPower

RowLayout {

  id: power
  // Only want laptop batteries
  property var batteries: UPower.devices.values.filter((device) => device.isLaptopBattery && device.isPresent)
  visible: batteries.filter((bat) => bat.percentage != 1).length > 0

  Repeater {
    model: power.batteries

    RowLayout {
      required property UPowerDevice modelData
      spacing: 2

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
        const range = Math.floor(percentage * 10) * 10;
        const rangeStr = ("" + range).padStart(3, '0');
        return `image://icon/battery-${rangeStr}${charging ? "-charging" : ""}-symbolic`
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
        // Colors stolen from Papirus Icon Theme
        color: modelData.state == UPowerDeviceState.Charging ? "#4caf50" :
          modelData.percentage < 0.20 ? "#f44336" :
          modelData.percentage < 0.30 ? "#ff9800" :
          palette.active.text
      }
    }
  }
}

