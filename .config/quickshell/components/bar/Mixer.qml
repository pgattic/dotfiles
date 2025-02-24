import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import "./elements"

Button {
  id: mixerButton
  text: "audio stuff"
  onClicked: mixerPopup.visible = !mixerPopup.visible

  PopupWindow {
    id: mixerPopup

    // match the system theme background color
    color: contentItem.palette.active.window
    anchor.window: barWindow
    anchor.rect.x: parentWindow.width
    anchor.rect.y: parentWindow.height
    width: 500
    height: 300
    visible: false

    ScrollView {
      anchors.fill: parent
      contentWidth: availableWidth

      ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10

        // get a list of nodes that output to the default sink
        PwNodeLinkTracker {
          id: linkTracker
          node: Pipewire.defaultAudioSink
        }

        MixerEntry {
          node: Pipewire.defaultAudioSink
        }

        Rectangle {
          Layout.fillWidth: true
          color: palette.active.text
          implicitHeight: 1
        }

        Repeater {
          model: linkTracker.linkGroups

          MixerEntry {
            required property PwLinkGroup modelData
            // Each link group contains a source and a target.
            // Since the target is the default sink, we want the source.
            node: modelData.source
          }
        }
      }
    }
  }
}

