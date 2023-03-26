import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQml 2.15
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.extras 2.0 as PlasmaExtras
// import org.kde.plasma.workspace.calendar 2.0 as PlasmaCalendar
import org.kde.notification 1.0
import "../lib/adhan.esm.js" as PrayTimes

Item {
    id: root

    readonly property date currentDateTime: dataSource.data.Local ? dataSource.data.Local.DateTime : new Date()
    // property date currentDateTime: new Date('2023-03-26T19:45:00')

    property bool endOfDay: false
    property date prayTimesDate: new Date(new Date().setHours(0,0,0,0))

    readonly property var timeNames: {
        'imsak': "Imsak",
        'fajr': "Subuh",
        'sunrise': "Terbit",
        //'duha': "Dhuha",
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
    // property var nextTime: times.timeForPrayer(nextPray)
    property var nextTime: getNextPrayTime(nextPray)
    property var difTime: nextTime - currentDateTime
    property var nextSubText: getRemainingTimeLabel(difTime)
    Plasmoid.toolTipMainText: endOfDay ? 'Waktu istirahat' : 'Menuju waktu ' + timeNames[nextPray]
    Plasmoid.toolTipSubText: nextSubText == '-' ? '' : nextSubText + ' lagi'

    readonly property var timeKeys: Object.keys(timeNames)
    property var timesModel: plasmoid.configuration.showImsak ? timeKeys : timeKeys.slice(1)

    Component {
        id: notificationComponent
        Notification {
            componentName: "plasma_workspace"
            eventId: "notification"
            text: "Selamat mendirikan sholat. Semoga kita dijadikan hamba Allah yang bertakwa."
            iconName: 'kaaba-svgrepo-com'
            autoDelete: true
        }
    }

    Component.onCompleted: {
        // console.log("loaded")
        // console.log(nowPray)
        // console.log(currentDateTime)
        // console.log(endOfDay)
        endOfDay = (nowPray == 'isha') ? true : false
        // setPrayTimesDate(endOfDay)
    }

    function adjustImsakTime(time) {
        var imsak = new Date(time.getTime())
        imsak.setMinutes(time.getMinutes() - 10)
        // console.log(imsak)
        return imsak
    }

    function getRemainingTime(milliseconds) {
        // console.log('mili :' + milliseconds)
        if (isNaN(milliseconds)) {
            return {h: 0, m: 0}
        }
        var secRem = Math.floor(milliseconds / 1000)
        var houRem = Math.floor(secRem / 3600 )
        var secRem2 = secRem % 3600
        var minRem = Math.ceil(secRem2 / 60)

        return {h: houRem, m: minRem}
    }

    function getRemainingTimeLabel(diff, formatted = true) {
        var label = '-'
        var remaining = getRemainingTime(diff)
        if (!formatted) {
            label += `${remaining.h}:${remaining.m > 9 ? remaining.m : "0"+ remaining.m}`
            return label
        }
        if (diff > 0) {
            if ( remaining.h > 0) {
                label += remaining.h + ' jam ' + remaining.m + ' mnt'
            } else {
                label += remaining.m + ' mnt'
            }
        } else if ( remaining.h == -1 && remaining.m < 0 && remaining.m > -60) {
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
        // console.log(times.timeForPrayer(name))
        // console.log('midnight ' + sunnahTimes.middleOfTheNight)
        // console.log('last third night ' + sunnahTimes.lastThirdOfTheNight)
        return times.timeForPrayer(name)
    }

    function setPrayTimesDate(nextDay = true) {
        if (nextDay) {
            root.prayTimesDate = new Date(new Date().setDate(currentDateTime.getDate() + 1))
        } else {
            root.prayTimesDate = root.currentDateTime
        }
    }

    onNowPrayChanged: {
        var notification = notificationComponent.createObject(parent);
        if (nowPray == 'isha')
            endOfDay = true;
        notification.title = "Waktunya " + timeNames[nowPray];
        // console.log(nowPray)
        if (nowPrayComp && nowPray != nowPrayComp && nowPray != 'sunrise' && nowPray != 'none')
            notification.sendEvent();

        nowPrayComp = nowPray
    }

    onCurrentDateTimeChanged: {
        // console.log(prayTimesDate)
        // console.log(currentDateTime)
        if (currentDateTime.getHours() === 0 && currentDateTime.getMinutes() === 0) {
            // console.log('new day')
            root.endOfDay = false
            setPrayTimesDate(false)
        }
    }

    property bool isDesktopContainment: plasmoid.location == PlasmaCore.Types.Floating
    Plasmoid.preferredRepresentation:  isDesktopContainment ? Plasmoid.fullRepresentation : Plasmoid.compactRepresentation
    Plasmoid.compactRepresentation: CompactRepresentation {
        countdownLabel: endOfDay ? "Istirahat" : timeNames[nextPray] + " " + getRemainingTimeLabel(difTime, false)
    }
    Plasmoid.fullRepresentation: FullRepresentation {}

    PlasmaCore.DataSource {
        id: dataSource
        engine: "time"
        connectedSources: ["Local"]
        interval: 60000
        intervalAlignment: PlasmaCore.Types.AlignToMinute
    }
}
