import Quickshell
import QtQuick
import QtQuick.Effects


Item {
  id: root

  required property bool isMain
  required property var desktopColor

  anchors.fill: parent

  StyledRect {
    id: rect

    anchors.fill: parent
    color: desktopColor
    visible: false
  }

  Item {
    id: mask

    anchors.fill: parent
    layer.enabled: true
    visible: false

    Rectangle {
      anchors.fill: parent
      anchors.margins: 4
      anchors.topMargin: isMain ? 40 : 4
      anchors.bottomMargin: !isMain ? 38 : 4
      radius: 24
    }
  }

  MultiEffect {
    anchors.fill: parent
    maskEnabled: true
    maskInverted: true
    maskSource: mask
    source: rect
    maskThresholdMin: 0.5
    maskSpreadAtMin: 1
  }
}
