import QtQuick
import QtQuick.Layouts

RowLayout {
  Image {
    source: `image://icon/emblem-information`
    sourceSize.width: 16
    sourceSize.height: 16
  }

  Text {
    function randomMessage() {
      const items = [
        "GNU Plus Linux!",
        "💍💞2025/05/31💖👫",
        "hahaha funny poopoo",
        "Did you work out today?",
        "Don't forget to pray!",
        "Remember to drink water",
        "Potatoooooooes🥔🥔🥔",
        "20 GOTO 10",
        "Robert'); DROP TABLE Students; --",
        "Written in QML!",
      ];
      return items[Math.floor(Math.random() * items.length)];
    }
    text: randomMessage()
    color: palette.active.text

    Timer {
      interval: 5000 // 5 seconds
      running: true
      repeat: true
      onTriggered: parent.text = parent.randomMessage()
    }
  }
}

