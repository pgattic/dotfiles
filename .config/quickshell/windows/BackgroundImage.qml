import QtQuick
import Quickshell
import Quickshell.Wayland

// Screen Wallpaper

PanelWindow {
  exclusionMode: ExclusionMode.Ignore
  WlrLayershell.layer: WlrLayer.Background
  WlrLayershell.namespace: "shell:background"
  color: "transparent"

  anchors {
    top: true
    bottom: true
    left: true
    right: true
  }

	Image {
    anchors.fill: parent
		source: Qt.resolvedUrl("../assets/wallpapers/rexburg_temple.png")
    fillMode: Image.PreserveAspectCrop
	}
}

