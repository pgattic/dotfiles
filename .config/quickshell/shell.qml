import Quickshell
import Quickshell.Wayland
import "./windows" as Windows

ShellRoot {
  Variants {
    // For each monitor
    model: Quickshell.screens

    Scope {
      required property ShellScreen modelData

      Windows.Bar { screen: modelData }
      Windows.ActivateLinux { screen: modelData }
      Windows.BackgroundImage { screen: modelData }
    }
  }
}

