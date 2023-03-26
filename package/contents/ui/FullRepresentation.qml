import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQml 2.15
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.extras 2.0 as PlasmaExtras


ColumnLayout {
    id: fullView

    // Component.onDestruction: {
    //     //console.log(alternateDate)
    // }

    SystemPalette {
        id: myPalette
        colorGroup: SystemPalette.Active
    }
    property color system_text_color: myPalette.text

    Component {
        id: listDelegate

        PlasmaComponents.ListItem {
            id: itemListDelegate
            height: contentRow.implicitHeight + 2 * 5
            Layout.minimumWidth: parent.width
            property bool imsak: modelData === 'imsak'
            property var timeC: imsak ? root.adjustImsakTime(root.times['fajr']) : root.times[modelData]
            property bool next: root.nextPray === modelData
            property bool current: root.nowPray === modelData

            RowLayout {
                id: contentRow
                anchors.fill: parent

                ColumnLayout {
                    id: infoNama
                    Layout.fillWidth: false
                    spacing: -1
                    Layout.preferredWidth: parent.width / 3

                    PlasmaComponents.Label {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignLeft
                        width: parent.width

                        text: root.timeNames[modelData]
                        color: root.currentDateTime < timeC ? (next ? '#FF372A' : system_text_color) : (current ? 'green' : 'pink')
                        font.weight: Font.Black
                    }
                }

                ColumnLayout {
                    id: infoWaktu
                    Layout.fillWidth: true
                    spacing: -1

                    PlasmaComponents.Label {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignLeft

                        text: Qt.formatTime(timeC)
                        color: root.currentDateTime < timeC ? (next ? '#FF372A' : system_text_color) : (current ? 'green' : 'pink')
                        font.weight: (modelData === root.nowPray || modelData === root.nextPray) ? Font.Black : Font.Normal
                    }
                }

                ColumnLayout {
                    id: infoKanan
                    Layout.alignment: Qt.AlignRight
                    Layout.fillWidth: true
                    spacing: -1

                    PlasmaComponents.Label {
                        Layout.alignment: Qt.AlignRight
                        property int remaining: timeC - root.currentDateTime

                        text: getRemainingTimeLabel(remaining)
                        color: remaining > 0 ? (next ? '#FF372A' : system_text_color) : (current ? 'green' : 'pink')
                        clip: true
                        textFormat: Text.StyledText
                        elide: Text.ElideMiddle
                    }
                }
            }
        }
    }

    Layout.minimumWidth: 320 * PlasmaCore.Units.devicePixelRatio
    Layout.minimumHeight: 360 * PlasmaCore.Units.devicePixelRatio

    RowLayout {
        id: labelTop
        width: parent.width
        height: parent.height
        Layout.minimumHeight: 40
        Layout.alignment: Qt.AlignTop

        ColumnLayout {
            id: plasmoidName
            Layout.fillWidth: false
            Layout.preferredWidth: parent.width / 2
            PlasmaExtras.Heading {
                text: "Jadwal Shalat"
                level: 1 
            }
        }

        ColumnLayout {
            id: dateInfo
            Layout.fillWidth: true
            spacing: -1
            Layout.preferredWidth: parent.width / 2
            property var titleDate: Qt.formatDate(root.prayTimesDate, "dd/MMM/yyyy")

            PlasmaExtras.Heading {
                text: dateInfo.titleDate
                level: 4 
                horizontalAlignment: Text.AlignRight
                Layout.alignment: Qt.AlignRight
            }
        }
    }

    Repeater {
        model: root.timesModel
        delegate: listDelegate
    }

    RowLayout {
        id: labelbawah
        width: parent.width
        height: parent.height
        Layout.minimumHeight: 40
        Layout.alignment: Qt.AlignBottom

        PlasmaComponents.Label {
            id: labelkota
            text: 'Koordinat ' + plasmoid.configuration.longitude + ', ' + plasmoid.configuration.latitude
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom
            Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter
            Layout.fillWidth: true
        }

    }

    RowLayout {
        id: labelsubbawah
        width: parent.width
        height: parent.height
        Layout.minimumHeight: 30
        Layout.alignment: Qt.AlignTop

        PlasmaComponents.Label {
            id: labelinstansi
            text: "Perhitungan Waktu Kemenag Indonesia"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
        }
    }
}

