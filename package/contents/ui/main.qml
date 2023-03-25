import QtQuick 2.0
import QtQuick.Layouts 1.0
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.components 3.0 as PlasmaComponents3

Item {
    id: root

    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
    //Plasmoid.compactRepresentation: CompactView {}
    Plasmoid.fullRepresentation: FullRepresentation {}

}
