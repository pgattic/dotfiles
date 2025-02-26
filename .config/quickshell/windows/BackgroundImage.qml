import QtQuick
import Quickshell
import Quickshell.Wayland

// Screen Wallpaper
// TODO: Make it "Fill" instead of "Stretch" to fit the screen

PanelWindow {
  exclusionMode: ExclusionMode.Ignore
  WlrLayershell.layer: WlrLayer.Background
  WlrLayershell.namespace: "shell:background"

  anchors {
    top: true
    bottom: true
    left: true
    right: true
  }

	Image {
    anchors.fill: parent
		source: Qt.resolvedUrl("./washington_dc_temple.jpg")
	}
}

