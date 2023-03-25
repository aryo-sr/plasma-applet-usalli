import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQml 2.15

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.extras 2.0 as PlasmaExtras
//import org.kde.plasma.workspace.calendar 2.0 as PlasmaCalendar
import org.kde.notification 1.0
import "../lib/adhan.esm.js" as PrayTimes

ColumnLayout {
    id: fullView

    readonly property date currentDateTime: dataSource.data.Local ? dataSource.data.Local.DateTime : new Date()
    //property date currentDateTime: new Date('2023-03-23T11:49:00')

    PlasmaCore.DataSource {
        id: dataSource
        engine: "time"
        connectedSources: ["Local"]
        interval: 60000
        intervalAlignment: PlasmaCore.Types.AlignToMinute
    }

    Component.onCompleted: {
        // console.log(nowPray)
        // console.log(currentDateTime)
        // console.log(endOfDay)
        fullView.endOfDay = (nowPray == 'isha') ? true : false
    }

    function adjustImsakTime(time) {
        var imsak = new Date(time.getTime())
        imsak.setMinutes(time.getMinutes() - 10)
        // console.log(imsak)
        return imsak
    }

    // function debugTimeChange(time, addition) {
    //     var newtime = new Date(time.getTime())
    //     newtime.setMinutes(time.getMinutes() + addition)
    //     return newtime
    // }

    function getRemainingTime(milliseconds) {
        console.log('mili :' + milliseconds)
        if (isNaN(milliseconds)) {
            return {h: 0, m: 0}
        }
        var secRem = Math.floor(milliseconds / 1000)
        var houRem = Math.floor(secRem / 3600 )
        var secRem2 = secRem % 3600
        var minRem = Math.floor(secRem2 / 60)

        return {h: houRem, m: minRem}
    }

    function getRemainingTimeLabel(diff) {
        var label = '-'
        var remaining = getRemainingTime(diff)
        if (diff > 0) {
            if ( remaining.h > 0) {
                label += remaining.h + ' jam ' + remaining.m + ' mnt'
            } else {
                label += remaining.m + ' mnt'
            }
        } else if ( remaining.h == -1 && remaining.m > -60) {
            label = '+' + Math.abs(remaining.m) + ' mnt'
        }
        return label
    }

    function getNextPrayTime(name) {
        if (name == 'none') {
            name = 'fajr'
            // if (plasmoid.configuration.showImsak) {
            //     name = 'imsak'
            // }
        }
        // var sunnahTimes = new PrayTimes.SunnahTimes(times)
        // console.log('midnight ' + sunnahTimes.middleOfTheNight)
        // console.log('last third night ' + sunnahTimes.lastThirdOfTheNight)
        return times.timeForPrayer(name)
    }

    function setPrayTimesDate(nextDay = true) {
        if (nextDay) {
            fullView.prayTimesDate = new Date(new Date().setDate(currentDateTime.getDate() + 1))
        } else {
            fullView.prayTimesDate = fullView.currentDateTime
            fullView.newDay = false
        }
    }

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
            property bool imsak: modelData == 'imsak'
            property var timeC: imsak ? fullView.adjustImsakTime(times['fajr']) : times[modelData]
            property bool next: nextPray == modelData
            property bool current: nowPray == modelData

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

                        text: timeNames[modelData]
                        color: fullView.currentDateTime < timeC ? (next ? '#FF372A' : system_text_color) : (current ? 'green' : 'pink')
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
                        color: fullView.currentDateTime < timeC ? (next ? '#FF372A' : system_text_color) : (current ? 'green' : 'pink')
                        font.weight: (modelData == fullView.nowPray || modelData == fullView.nextPray) ? Font.Black : Font.Normal
                    }
                }

                ColumnLayout {
                    id: infoKanan
                    Layout.alignment: Qt.AlignRight
                    Layout.fillWidth: true
                    spacing: -1

                    PlasmaComponents.Label {
                        Layout.alignment: Qt.AlignRight
                        property var remaining: timeC - fullView.currentDateTime

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

    Component {
        id: notificationComponent
        Notification {
            componentName: "plasma_workspace"
            eventId: "notification"
            text: "Selamat mendirikan sholat. Semoga kita dijadikan hamba Allah yang bertakwa."
            iconName: 'kalarm'
            autoDelete: true
        }
    }

    Layout.minimumWidth: 320 * PlasmaCore.Units.devicePixelRatio
    Layout.minimumHeight: 360 * PlasmaCore.Units.devicePixelRatio

    property bool endOfDay: false
    property bool newDay: false
    property date prayTimesDate: currentDateTime


    readonly property var timeNames: {
        'imsak': "Imsak",
        'fajr': "Subuh",
        'sunrise': "Terbit",
        'dhuhr': "Zhuhur",
        'asr': "Ashar",
        'maghrib': "Maghrib",
        'isha': "Isya'"
    }

    readonly property var longitude: plasmoid.configuration.longitude
    readonly property var latitude: plasmoid.configuration.latitude
    readonly property var coordinates: new PrayTimes.Coordinates(longitude, latitude)
    readonly property var params: new PrayTimes.CalculationMethod.Singapore()
    property var times: new PrayTimes.PrayerTimes(coordinates, prayTimesDate, params)
    property var nowPrayComp: ''
    property var nowPray: times.currentPrayer(currentDateTime)
    property var nextPray: times.nextPrayer(currentDateTime)
    property var nextTime: getNextPrayTime(nextPray)
    property var difTime: nextTime - currentDateTime

    property var nextSubText: getRemainingTimeLabel(difTime)
    Plasmoid.toolTipMainText: (nextPray == 'none') ? 'Waktunya istirahat' : 'Menunggu waktu ' + timeNames[nextPray]
    Plasmoid.toolTipSubText: nextSubText == '-' ? '' : nextSubText + ' lagi'

    onNowPrayChanged: {
        var notification = notificationComponent.createObject(parent);
        notification.title = "Waktunya " + timeNames[nowPray];
        if (nowPrayComp && nowPray != nowPrayComp && nowPray != 'sunrise' && nowPray != 'none')
            notification.sendEvent();

        nowPrayComp = nowPray
    }

    onCurrentDateTimeChanged: {
        if (prayTimesDate.getDate() != currentDateTime.getDate()) {
            // console.log('new day')
            fullView.newDay = true
            setPrayTimesDate(false)
        }
    }

    readonly property var timeKeys: Object.keys(timeNames)
    property var timesModel: plasmoid.configuration.showImsak ? timeKeys : timeKeys.slice(1)

    RowLayout {
        id: labelTop
        width: parent.width
        height: parent.height
        Layout.minimumHeight: 40

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
            property var titleDate: Qt.formatDate(prayTimesDate, "dd/MMM/yyyy")

            PlasmaExtras.Heading {
                text: (endOfDay) ? '(Besok) ' + dateInfo.titleDate : dateInfo.titleDate
                level: 4 
                horizontalAlignment: Text.AlignRight
                Layout.alignment: Qt.AlignRight
            }
        }
    }

    Repeater {
        model: fullView.timesModel
        delegate: listDelegate
    }

    RowLayout {
        id: labelbawah
        width: parent.width
        height: parent.height
        Layout.minimumHeight: 40

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

