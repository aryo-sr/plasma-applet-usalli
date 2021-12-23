import QtQuick 2.0
import QtQuick.Layouts 1.0
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
//import org.kde.plasma.components 3.0 as PlasmaComponents3
import "../lib/PrayTimes.js" as PrayTimes

ColumnLayout {
    id: kolomutama

    Component {
        id: listDelegate

        PlasmaComponents.ListItem {
            //Layout.alignment: Qt.AlighCenter
            height: contentRow.implicitHeight + 2 * 5
            //width: parent.width
            Layout.minimumWidth: parent.width
    //         anchors.left: kolomutama.left
    //         anchors.right: kolomutama.right

            RowLayout {
                id: contentRow
                anchors.fill: parent

                ColumnLayout {
                    id: infoNama
                    Layout.fillWidth: true
                    spacing: -1
                    Layout.preferredWidth: 40

                    PlasmaComponents.Label {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignLeft
                        width: parent.width

                        text: modelData.name
                        font.weight: Font.Black
                    }
                }

                ColumnLayout {
                    id: infoWaktu
                    Layout.fillWidth: true
                    spacing: -1

                    PlasmaComponents.Label {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter

                        text: modelData.time
                        // Sometimes it has HTML encoded characters
                        // StyledText will render them nicely (and more performant than RichText)
                        textFormat: Text.StyledText
                        elide: Text.ElideMiddle
                    }
                }

                ColumnLayout {
                    id: infoKanan
                    Layout.alignment: Qt.AlignRight
                    spacing: -1

                    PlasmaComponents.Label {
                        Layout.alignment: Qt.AlignRight

                        text: 'sisa waktu'
                        color: 'orange'
                        clip: true
                        textFormat: Text.StyledText
                        elide: Text.ElideMiddle
                    }
                }
            }
        }
    }

    Layout.minimumWidth : plasmoid.formFactor == PlasmaCore.Types.Horizontal ? height : 1
    Layout.minimumHeight : plasmoid.formFactor == PlasmaCore.Types.Vertical ? width  : 1
    Layout.preferredWidth: 320 * PlasmaCore.Units.devicePixelRatio
    Layout.preferredHeight: 360 * PlasmaCore.Units.devicePixelRatio

    property var waktuSholats: [
        {
            "nama": "Subuh",
            "waktu": "04.20 WIB"
        },
        {
            "nama": "Syuruq",
            "waktu": "05.20 WIB"
        },
        {
            "nama": "Zhuhur",
            "waktu": "11.50 WIB"
        },
        {
            "nama": "Ashar",
            "waktu": "14.50 WIB"
        },
        {
            "nama": "Magrib",
            "waktu": "17.40 WIB"
        },
        {
            "nama": "Isya",
            "waktu": "19.00 WIB"
        },
    ]

    //property var locale: Qt.locale()
    property date now: new Date()
    property var prayTime: new PrayTimes.PrayTimes('Egypt')
    property var times: prayTime.getTimes([now.getFullYear(), now.getMonth() + 1, now.getDate()], [-6.2088, 106.8456], 7)
    //Component.onCompleted: {
        //prayTimes.setMethod('Egypt')
        //prayTimes.adjust({fajr: 20, isha: 18})
    //}
    //property var times: prayTimes.getTimes(now, [-6.2088, 106.8456], 7)
    //property var times: PrayerTimes.getTimes()

    property var timesModel: [
        { name: "Subuh", time: times.fajr },
        { name: "Zhuhur", time: times.dhuhr },
        { name: "Ashar", time: times.asr },
        { name: "Maghrib", time: times.maghrib },
        { name: "Isya", time: times.isha }
    ]

    //Component {
        //id: timesDelegate

        //PlasmaComponents.Label {
            //text: modelData.name

            //Component.onCompleted: {
                //console.log(modelData)
            //}
        //}
    //}

    //Repeater {
        //model: kolomutama.timesModel
        //delegate: timesDelegate
    //}

    RowLayout {
        id: labelatas
        width: parent.width
        height: parent.height
        Layout.minimumHeight: 40

        PlasmaComponents.Label {
            id: labeltanggal
//                 anchors.fill: parent
            text: "Ahad, 14 Jumadil Awal 1443 H"
            horizontalAlignment: Text.AlignHCenter
//                 verticalAlignment: Text.AlignVCenter
            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
            Layout.fillWidth: true
        }
    }

    Repeater {
        model: kolomutama.timesModel
        delegate: listDelegate
    }

    RowLayout {
        id: labelbawah
        width: parent.width
        height: parent.height
        Layout.minimumHeight: 40

        PlasmaComponents.Label {
            id: labelkota
//                 anchors.fill: parent
            text: "Batang -6.9 LS 110 BT"
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

        PlasmaComponents.Label {
            id: labelinstansi
//                 anchors.fill: parent
            text: "Perhitungan Waktu Kemenag Indonesia"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
        }
    }
}

