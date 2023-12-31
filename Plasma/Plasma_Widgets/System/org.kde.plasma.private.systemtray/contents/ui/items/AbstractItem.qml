/*
 *   Copyright 2016 Marco Martin <mart@kde.org>
 *   Copyright 2020 Konrad Materka <materka@gmail.com>
 *   Copyright 2020 Nate Graham <nate@kde.org>
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

import QtQuick 2.2
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3

/*
 * This is the base item used for all system tray items.
 * It appears in both the compact and expanded representations (Status and Notifications).
 * Its appearance changes significantly compared
 */

PlasmaCore.ToolTipArea {
    id: abstractItem

    height: inVisibleLayout ? visibleLayout.cellHeight : hiddenTasks.cellHeight
    width: inVisibleLayout ? visibleLayout.cellWidth : hiddenTasks.cellWidth

    property var model: itemModel

    property string itemId
    property alias text: label.text
    property alias iconContainer: iconContainer
    property int status: model.status || PlasmaCore.Types.UnknownStatus
    property int effectiveStatus: model.effectiveStatus || PlasmaCore.Types.UnknownStatus
    readonly property bool inHiddenLayout: effectiveStatus === PlasmaCore.Types.PassiveStatus
    readonly property bool inVisibleLayout: effectiveStatus === PlasmaCore.Types.ActiveStatus

    signal clicked(var mouse)
    signal pressed(var mouse)
    signal wheel(var wheel)
    signal contextMenu(var mouse)

    /* subclasses need to assign to this tooltip properties
    mainText:
    subText:
    */
    

    location: {
        if (inHiddenLayout) {
            if (LayoutMirroring.enabled && plasmoid.location !== PlasmaCore.Types.RightEdge) {
                return PlasmaCore.Types.LeftEdge;
            } else if (plasmoid.location !== PlasmaCore.Types.LeftEdge) {
                return PlasmaCore.Types.RightEdge;
            }
        }

        return plasmoid.location;
    }

//BEGIN CONNECTIONS

    onContainsMouseChanged: {
        if (inHiddenLayout && containsMouse) {
            root.hiddenLayout.currentIndex = index
        }
        else if (inHiddenLayout && !containsMouse) { // Done to prevent the GridView highlight from lingering when no item is hovered over.
            root.hiddenLayout.currentIndex = -1
        }
        else if(!inHiddenLayout) {
            itemHighLight.opacity = containsMouse ? 1 : 0
        }
        
    }

//END CONNECTIONS

    /*
     * The highlight texture which is used in the compact representation.
     * It only uses the default SVG prefix, as the transition between states
     * needs to be done while animated. In order to do this, instead of using
     * SVG prefixes, a Rectangle with a gradient fades in and out when the user
     * presses on a tray icon.
     */
    PlasmaCore.FrameSvgItem {
        id: itemHighLight
        anchors.fill: parent
        property int location

        property bool animationEnabled: true
        property var highlightedItem: null

        z: -1 // always draw behind icons
        opacity: 0

        imagePath: "widgets/tabbar"
        prefix: {
            var prefix = ""
            switch (location) {
                case PlasmaCore.Types.LeftEdge:
                    prefix = "west-active-tab";
                    break;
                case PlasmaCore.Types.TopEdge:
                    prefix = "north-active-tab";
                    break;
                case PlasmaCore.Types.RightEdge:
                    prefix = "east-active-tab";
                    break;
                default:
                    prefix = "south-active-tab";
            }
            if (!hasElementPrefix(prefix)) {
                prefix = "active-tab";
            }
            return prefix;
        }
        Behavior on opacity {
            NumberAnimation {
                duration: PlasmaCore.Units.longDuration
                easing.type: Easing.InOutQuad
            }
        }
        Rectangle {
            id: pressRect
            property alias activatedPress: pressRect.opacity
            anchors.fill: parent
            anchors.leftMargin: 2; // We don't want the rectangle to draw over the highlight texture itself.
            anchors.rightMargin: 2;
            gradient: Gradient {
                // The first and last gradient stops are offset by +/-0.1 to avoid a sudden gradient "cutoff".
                GradientStop { position: 0.1; color: "transparent"; }
                GradientStop { position: 0.5; color: "#66000000"; }
                GradientStop { position: 0.9; color: "transparent"; }
            }
            opacity: 0
            Behavior on opacity {
                NumberAnimation {
                    duration: 150;
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }
    PulseAnimation {
        targetItem: iconContainer
        running: (abstractItem.status === PlasmaCore.Types.NeedsAttentionStatus ||
            abstractItem.status === PlasmaCore.Types.RequiresAttentionStatus ) &&
            PlasmaCore.Units.longDuration > 0
    }

    function activated() {
        // When activated, a tray icon will no longer perform a "pop" animation.
        //activatedAnimation.start()
    }

    // Deprecated, to be removed.
    SequentialAnimation {
        id: activatedAnimation
        loops: 1

        ScaleAnimator {
            target: iconContainer
            from: 1
            to: 0.5
            duration: PlasmaCore.Units.shortDuration
            easing.type: Easing.InQuad
        }

        ScaleAnimator {
            target: iconContainer
            from: 0.5
            to: 1
            duration: PlasmaCore.Units.shortDuration
            easing.type: Easing.OutQuad
        }
    }

    // Internal MouseArea that handles interactions with a tray icon in either the compact or expanded representation.
    MouseArea {
        id: ma
        z: 5
        anchors.fill: abstractItem
        drag.filterChildren: true

        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
        onClicked: {
            abstractItem.clicked(mouse)
            pressRect.activatedPress = 0;
        }
        onPressed: {
            abstractItem.hideToolTip()
            abstractItem.pressed(mouse)
            // Prevent a weird visual bug where the rectangle stays visible when the user presses the left mouse button, followed almost immediately by the right/middle
            // mouse button.
            if(ma.pressedButtons != Qt.LeftButton) pressRect.activatedPress = 0;
            else pressRect.activatedPress = ma.pressedButtons & Qt.LeftButton; // When the user presses on a tray icon with the left mouse button, make the gradient appear.
        }
        onReleased: {
            pressRect.activatedPress = 0; // Makes the rectangle gradient invisible.
        }
        onPressAndHold: {
            abstractItem.contextMenu(mouse)
            pressRect.activatedPress = 0;
        }
        onWheel: {
            abstractItem.wheel(wheel);
            //Don't accept the event in order to make the scrolling by mouse wheel working
            //for the parent scrollview this icon is in.
            wheel.accepted = false;
        }
    }

    ColumnLayout {
        anchors.fill: abstractItem
        spacing: 0

        Item {
            id: iconContainer

            property alias container: abstractItem
            property alias inVisibleLayout: abstractItem.inVisibleLayout
            readonly property int size: abstractItem.inVisibleLayout ? root.itemSize : PlasmaCore.Units.iconSizes.smallMedium

            Layout.alignment: Qt.Bottom | Qt.AlignHCenter
            Layout.fillHeight: abstractItem.inHiddenLayout ? true : false
            implicitWidth: root.vertical && abstractItem.inVisibleLayout ? abstractItem.width : size
            implicitHeight: !root.vertical && abstractItem.inVisibleLayout ? abstractItem.height : size
            Layout.topMargin: abstractItem.inHiddenLayout ? Math.round(PlasmaCore.Units.smallSpacing * 1.5): 0
        }
        // The label that appears in the expanded representation below the icon.
        PlasmaComponents3.Label {
            id: label

            Layout.fillWidth: true
            Layout.fillHeight: abstractItem.inHiddenLayout ? true : false
            Layout.leftMargin: abstractItem.inHiddenLayout ? PlasmaCore.Units.smallSpacing : 0
            Layout.rightMargin: abstractItem.inHiddenLayout ? PlasmaCore.Units.smallSpacing : 0
            Layout.bottomMargin: abstractItem.inHiddenLayout ? PlasmaCore.Units.smallSpacing : 0

            visible: abstractItem.inHiddenLayout

            verticalAlignment: Text.AlignTop
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
            wrapMode: Text.Wrap
            maximumLineCount: 3

            opacity: visible ? 1 : 0
            Behavior on opacity {
                NumberAnimation {
                    duration: PlasmaCore.Units.longDuration
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }
}

