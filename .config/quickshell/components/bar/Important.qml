import QtQuick
import QtQuick.Layouts

RowLayout {
  Image {
    source: `image://icon/dialog-information`
    sourceSize.width: 16
    sourceSize.height: 16
  }

  Text {

    function randomMessage() {
      const items = [
        "GNU Plus Linux!🐧",
        "💍💞2025/05/31💖👫",
        "hahaha funny poopoo",
        "Did you work out today?",
        "Don't forget to pray!",
        "Remember to drink water",
        "Potatoooooooes🥔🥔🥔",
        "20 GOTO 10",
        "Robert'); DROP TABLE Students; --",
        "Written in Qt/QML!",
        "I use Arch btw",
        "Learn some Rust",
        "'MURICA 🇺🇸",
        "I love Skylar! 🥰",
      ];
      return items[Math.floor(Math.random() * items.length)];
    }

    text: randomMessage()
    color: palette.active.text

    Timer {
      interval: 10000 // 10 seconds
      running: true
      repeat: true
      onTriggered: parent.text = parent.randomMessage()
    }
  }
}

