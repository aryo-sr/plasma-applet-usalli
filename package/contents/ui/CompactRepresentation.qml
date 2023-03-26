import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQml 2.15
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.components 2.0 as PlasmaComponents

Loader {
    id: simpleView
    property string countdownLabel
    sourceComponent: plasmoid.configuration.showAsIcon ? iconView : textCountdown

    Layout.fillWidth: false
    Layout.fillHeight: false
    Layout.minimumWidth: item.Layout.minimumWidth
    Layout.minimumHeight: item.Layout.minimumHeight

    MouseArea {
        id: compactMouseArea
        anchors.fill: parent

        hoverEnabled: true

        onClicked: {
            if (mouse.button == Qt.LeftButton) {
                Plasmoid.expanded = !Plasmoid.expanded;
            }
        }
    }

    Component {
        id: textCountdown

        RowLayout {
            id: labelSingle
            width: parent.width
            height: parent.height

            PlasmaComponents3.Label {
                id: labelOnly

                text: simpleView.countdownLabel
            }
        }
    }

    Component {
        id: iconView

        PlasmaCore.IconItem {
            id: iconSingle
            readonly property int minimumIconSize: PlasmaCore.Units.iconSizes.small
            readonly property int iconSize: width
            readonly property int implicitMinimumIconSize: Math.max(iconSize, minimumIconSize)

            source: "kaaba-svgrepo-com.svg"

            implicitWidth: minimumIconSize
            implicitHeight: minimumIconSize

            Layout.fillWidth: false
            Layout.fillHeight: true
            Layout.minimumWidth: implicitMinimumIconSize
            Layout.minimumHeight: minimumIconSize
        }
    }

}
