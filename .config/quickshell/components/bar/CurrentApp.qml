import QtQuick
import Quickshell.Wayland

Text {
  text: ToplevelManager.activeToplevel?.activated ? ToplevelManager.activeToplevel.title : ""
  color: palette.active.text
}

