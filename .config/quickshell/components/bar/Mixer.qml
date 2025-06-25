import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import "./elements" as Elements
import "../../" // for Constants.qml

RowLayout {
  id: mixerButton

  function determineIconName(node) {
    // Return recommended one if exists
    if (node.properties["application.icon-name"]) return node.properties["application.icon-name"];
    // Figure out volume level
    if (node.isSink) { // Audio Output
      if (node.audio.muted) return "audio-volume-muted";
      if (node.audio.volume < 0.3) return "audio-volume-low";
      else if (node.audio.volume < 0.7) return "audio-volume-medium";
      return "audio-volume-high";
    } else { // Audio Input (mic)
      //if (node.audio.muted) return "audio-input-microphone-muted";
      //if (node.audio.volume < 0.3) return "audio-input-microphone-low";
      //else if (node.audio.volume < 0.7) return "audio-input-microphone-medium";
      return "audio-input-microphone-high";
    }
    return "audio-input-microphone-high";
  }

  MouseArea {
    acceptedButtons: Qt.RightButton
    implicitWidth: childrenRect.width
    implicitHeight: childrenRect.height

    onClicked: event => {
      Pipewire.defaultAudioSink.audio.muted = !Pipewire.defaultAudioSink.audio.muted;
    }

    onWheel: (event) => {
      Pipewire.defaultAudioSink.audio.muted = false;
      Pipewire.defaultAudioSink.audio.volume += event.angleDelta.y / (120 * 10);
    }
    RowLayout {
      Image {
        source: `image://icon/${determineIconName(Pipewire.defaultAudioSink)}`

        sourceSize.width: 16
        sourceSize.height: 16
      }

      Label {
        text: `${Math.floor(Pipewire.defaultAudioSink.audio.volume * 100)}%`
        color: Pipewire.defaultAudioSink.audio.muted ? "#5affffff" : palette.active.text
      }

    }
  }

  //RowLayout {
  //  Image {
  //    source: `image://icon/${determineIconName(Pipewire.defaultAudioSource)}`
  //
  //    sourceSize.width: 16
  //    sourceSize.height: 16
  //  }
  //
  //  MouseArea {
  //    anchors.fill: parent
  //    acceptedButtons: Qt.RightButton
  //
  //    onClicked: event => {
  //      Pipewire.defaultAudioSource.audio.muted = !Pipewire.defaultAudioSource.audio.muted;
  //    }
  //  }
  //}

  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.LeftButton

    onClicked: event => {
      mixerPopup.visible = !mixerPopup.visible;
    }
  }

  PopupWindow {
    id: mixerPopup

    // match the system theme background color
    color: "transparent"
    anchor.window: barWindow
    anchor.rect.x: parentWindow.width
    anchor.rect.y: parentWindow.height
    width: 600
    height: 300
    visible: false

    Rectangle {
      color: Constants.windowColor
      anchors.fill: parent
      radius: 12

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

          Elements.MixerEntry {
            node: Pipewire.defaultAudioSink
          }

          Rectangle {
            Layout.fillWidth: true
            color: palette.active.text
            implicitHeight: 1
          }

          Repeater {
            model: linkTracker.linkGroups

            Elements.MixerEntry {
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
}

