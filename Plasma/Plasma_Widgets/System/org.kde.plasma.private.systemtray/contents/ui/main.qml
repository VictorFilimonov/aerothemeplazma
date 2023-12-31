/*
 *   Copyright 2011 Marco Martin <mart@kde.org>
 *   Copyright 2020 Konrad Materka <materka@gmail.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Library General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 2.5
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.1 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.draganddrop 2.0 as DnD
import org.kde.kirigami 2.5 as Kirigami

import "items"

MouseArea {
    id: root

    // Is the plasmoid oriented vertically (is the taskbar vertical)?
    readonly property bool vertical: plasmoid.formFactor === PlasmaCore.Types.Vertical

    Layout.minimumWidth: vertical ? PlasmaCore.Units.iconSizes.small : mainLayout.implicitWidth + PlasmaCore.Units.smallSpacing
    Layout.minimumHeight: vertical ? mainLayout.implicitHeight + PlasmaCore.Units.smallSpacing : PlasmaCore.Units.iconSizes.small

    LayoutMirroring.enabled: !vertical && Qt.application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    readonly property alias systemTrayState: systemTrayState
    readonly property alias itemSize: tasksGrid.itemSize
    readonly property alias visibleLayout: tasksGrid
    readonly property alias hiddenLayout: expandedRepresentation.hiddenLayout

    onWheel: {
        // Don't propagate unhandled wheel events
        wheel.accepted = true;
    }

    // Used to know when the system tray is expanded.
    SystemTrayState {
        id: systemTrayState
    }

    // Being there forces the items to fully load, and they will be reparented in the popup one by one, this item is *never* visible.
    Item {
        id: preloadedStorage
        visible: false
    }

    // This object is used to highlight the currently active system tray item. It only has one instance and is technically moved around as different items are expanded.
    CurrentItemHighLight {
        id: cur_item_highlight
        location: plasmoid.location
        parent: root
    }

    DnD.DropArea {
        anchors.fill: parent

        preventStealing: true;

        /** Extracts the name of the system tray applet in the drag data if present
         * otherwise returns null*/
        function systemTrayAppletName(event) {
            if (event.mimeData.formats.indexOf("text/x-plasmoidservicename") < 0) {
                return null;
            }
            var plasmoidId = event.mimeData.getDataAsByteArray("text/x-plasmoidservicename");

            if (!plasmoid.nativeInterface.isSystemTrayApplet(plasmoidId)) {
                return null;
            }
            return plasmoidId;
        }

        onDragEnter: {
            if (!systemTrayAppletName(event)) {
                event.ignore();
            }
        }

        onDrop: {
            var plasmoidId = systemTrayAppletName(event);
            if (!plasmoidId) {
                event.ignore();
                return;
            }

            if (plasmoid.configuration.extraItems.indexOf(plasmoidId) < 0) {
                var extraItems = plasmoid.configuration.extraItems;
                extraItems.push(plasmoidId);
                plasmoid.configuration.extraItems = extraItems;
            }
        }
    }

    // Main Layout, this is what appears as the "compact representation" in the taskbar itself.
    GridLayout {
        id: mainLayout

        rowSpacing: 0 // Disable unnecessary padding
        columnSpacing: 0
        anchors.fill: parent

        flow: vertical ? GridLayout.TopToBottom : GridLayout.LeftToRight

        // This is the "Show hidden items" arrow that toggles the visibility of the expanded representation.
        ExpanderArrow {
            id: expander
            Layout.fillWidth: vertical
            Layout.fillHeight: !vertical
            Layout.alignment: vertical ? Qt.AlignVCenter : Qt.AlignHCenter
            visible: root.hiddenLayout.itemCount > 0 // We only want to show this arrow if there are hidden tray icons.
        }
        // This is the view that contains all the visible system tray icons.
        GridView {
            id: tasksGrid

            Layout.alignment: Qt.AlignCenter

            interactive: false // Disable features we don't need.
            flow: vertical ? GridView.LeftToRight : GridView.TopToBottom

            // The icon size to display when not using the auto-scaling setting, it has been set to a resolution of 16x16 on regular DPI displays.
            readonly property int smallIconSize: PlasmaCore.Units.iconSizes.small
            readonly property bool autoSize: plasmoid.configuration.scaleIconsToFit

            readonly property int gridThickness: root.vertical ? root.width : root.height
            // Should change to 2 rows/columns on a 56px panel (in standard DPI)
            readonly property int rowsOrColumns: autoSize ? 1 : Math.max(1, Math.min(count, Math.floor(gridThickness / (smallIconSize + PlasmaCore.Units.smallSpacing))))

            // Add margins only if the panel is larger than a small icon (to avoid large gaps between tiny icons)
            readonly property int smallSizeCellLength: gridThickness < smallIconSize ? smallIconSize : smallIconSize + PlasmaCore.Units.smallSpacing * 2
            cellHeight: {
                if (root.vertical) {
                    return autoSize ? root.width + PlasmaCore.Units.smallSpacing : smallSizeCellLength
                } else {
                    return autoSize ? root.height : Math.floor(root.height / rowsOrColumns)
                }
            }
            cellWidth: {
                if (root.vertical) {
                    return autoSize ? root.width : Math.floor(root.width / rowsOrColumns)
                } else {
                    return autoSize ? root.height + PlasmaCore.Units.smallSpacing : smallSizeCellLength
                }
            }

            //depending on the form factor, we are calculating only one dimention, second is always the same as root/parent
            implicitHeight: root.vertical ? cellHeight * Math.ceil(count / rowsOrColumns) : root.height
            implicitWidth: !root.vertical ? cellWidth * Math.ceil(count / rowsOrColumns) : root.width

            // Used only by AbstractItem, but it's easiest to keep it here since it
            // uses dimensions from this item to calculate the final value
            readonly property int itemSize: {
                if (autoSize) {
                    const size = Math.min(implicitWidth / rowsOrColumns, implicitHeight / rowsOrColumns)
                    return PlasmaCore.Units.roundToIconSize(Math.min(size, PlasmaCore.Units.iconSizes.enormous))
                } else {
                    return smallIconSize
                }
            }

            model: PlasmaCore.SortFilterModel {
                sourceModel: plasmoid.nativeInterface.systemTrayModel
                filterRole: "effectiveStatus"
                filterCallback: function(source_row, value) {
                    return value === PlasmaCore.Types.ActiveStatus
                }
            }

            delegate: ItemLoader {}

            add: Transition {
                enabled: itemSize > 0

                NumberAnimation {
                    property: "scale"
                    from: 0
                    to: 1
                    easing.type: Easing.InOutQuad
                    duration: PlasmaCore.Units.longDuration
                }
            }

            displaced: Transition {
                //ensure scale value returns to 1.0
                //https://doc.qt.io/qt-5/qml-qtquick-viewtransition.html#handling-interrupted-animations
                NumberAnimation {
                    property: "scale"
                    to: 1
                    easing.type: Easing.InOutQuad
                    duration: PlasmaCore.Units.longDuration
                }
            }

            move: Transition {
                NumberAnimation {
                    properties: "x,y"
                    easing.type: Easing.InOutQuad
                    duration: PlasmaCore.Units.longDuration
                }
            }
        }

    }
    // Used for getting the margins so that we can properly pad out the expanded representation.
    PlasmaCore.FrameSvgItem {
        id : panelSvg

        visible: false

        imagePath: "widgets/panel-background"
    }
    // Function used for positioning the floating expanded representation.
    function popupPosition(width, height) {
        var screenAvail = plasmoid.availableScreenRect;
        var screen = plasmoid.screenGeometry;
        var offset = PlasmaCore.Units.smallSpacing;

        // Fall back to bottom-left of screen area when the applet is on the desktop or floating.
        var x = offset;
        var y = screen.height - height - offset;
        var horizMidPoint = screen.x + (screen.width / 2);
        var vertMidPoint = screen.y + (screen.height / 2);
        var appletTopLeft = root.mapToGlobal(0, 0);
        var appletBottomLeft = root.mapToGlobal(0, root.height);

        x = (appletTopLeft.x < horizMidPoint) ? screen.x : (screen.x + screen.width) - width;
          
        if (appletTopLeft.x < horizMidPoint) {
            x += offset
        } else if (appletTopLeft.x + width > horizMidPoint){
            x -= offset
        }

        if (plasmoid.location == PlasmaCore.Types.TopEdge) {
            // This is floatingAvatar.width
            offset = PlasmaCore.Units.smallSpacing*2;
            y = screen.y + parent.height + panelSvg.margins.bottom + offset;
        } else {
            offset = PlasmaCore.Units.smallSpacing*2;
            y = screen.y + screen.height - parent.height - height - panelSvg.margins.top - offset;
        }

        return Qt.point(x, y);
    }
    
   
    // Main popup, a.k.a the expanded representation.
    PlasmaCore.Dialog {
        id: dialog

        flags: Qt.WindowStaysOnTopHint
        location: PlasmaCore.Types.Floating;
        hideOnWindowDeactivate: !plasmoid.configuration.pin
        visible: systemTrayState.expanded

        onVisibleChanged: {
            // The next three statements simply set the position of the dialog every time its state is changed.
            var pos = popupPosition(dialog.width, dialog.height);
            dialog.x = pos.x;
            dialog.y = pos.y;
            systemTrayState.expanded = visible;
        }
        onHeightChanged: {
            var pos = popupPosition(dialog.width, dialog.height);
            dialog.x = pos.x;
            dialog.y = pos.y;
        }

        onWidthChanged: {
            var pos = popupPosition(dialog.width, dialog.height);
            dialog.x = pos.x;
            dialog.y = pos.y;
        }
        mainItem: ExpandedRepresentation {
            id: expandedRepresentation

            Keys.onEscapePressed: {
                systemTrayState.expanded = false
            }

            LayoutMirroring.enabled: Qt.application.layoutDirection === Qt.RightToLeft
            LayoutMirroring.childrenInherit: true
        }
        
        Component.onCompleted: {
            /*
             * Here, we set the backgroundHints property of the Dialog to 2, which is actually PlasmaQuick::Dialog::BackgroundHints::SolidBackground.
             * By doing this we are telling the dialog to render with the solid variant of the background SVG texture.
             * More details on PlasmaCore.Dialog can be found here: https://api.kde.org/frameworks/plasma-framework/html/classPlasmaQuick_1_1Dialog.html
             */
            dialog.backgroundHints = 2;
            var pos = popupPosition(dialog.width, dialog.height);
            dialog.x = pos.x;
            dialog.y = pos.y;
        }
    }
}
