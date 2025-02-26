import Quickshell
pragma Singleton

Singleton {
  property int barHeight: 32 // NOTE: My Waybar's height was 24
  // This somehow gets the QT window color :) Will have to read up on this:
  // palette.active.window
  property var windowColor: "#7F000000"
  property var textColor: "#FFFFFF"
}

