import QtQuick 2.0
import QtQuick.Controls 2.5 as QQC2
import org.kde.kirigami 2.4 as Kirigami

Kirigami.FormLayout {
    id: pageGeneral
  
    property alias cfg_showImsak: showImsak.checked
    property alias cfg_longitude: longText.text
    property alias cfg_latitude: latText.text

    QQC2.CheckBox {
        id: showImsak
        Kirigami.FormData.label: i18n("Imsak Time:")
        text: i18n("Show time")
    }

    QQC2.TextField {
        id: longText
        Kirigami.FormData.label: i18n("Longitude:")
        placeholderText: i18n("Garis Lintang")
    }
    
    QQC2.TextField {
        id: latText
        Kirigami.FormData.label: i18n("Latitude:")
        placeholderText: i18n("Garis Bujur")
    }
}
