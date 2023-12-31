/*
 *   Copyright 2016 Marco Martin <mart@kde.org>
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

import QtQuick 2.12
import QtQuick.Layouts 1.12

import org.kde.plasma.core 2.0 as PlasmaCore
// We still need PC2 here for that version of Menu, as PC2 Menu is still very problematic with QActions
// Not being a proper popup window, makes it a showstopper to be used in Plasma
import org.kde.plasma.components 2.0 as PC2
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras
import QtGraphicalEffects 1.12


Item {
    id: popup
    // Set width/height to avoid useless Dialog resize.
    // The constants have been reduced to reduce the overall size of the expanded representation.
    readonly property int defaultWidth: PlasmaCore.Units.gridUnit * 18
    readonly property int defaultHeight: PlasmaCore.Units.gridUnit * 20

    // The popup dialog is not meant to be resizable, so we are fixing its size.
    width: defaultWidth
    Layout.minimumWidth: defaultWidth
    Layout.preferredWidth: defaultWidth
    Layout.maximumWidth: defaultWidth

    height: defaultHeight
    Layout.minimumHeight: defaultHeight
    Layout.preferredHeight: defaultHeight
    Layout.maximumHeight: defaultHeight
    
    property alias hiddenLayout: hiddenItemsView.layout

    // Header
    PlasmaExtras.PlasmoidHeading {
        id: plasmoidHeading
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            leftMargin: PlasmaCore.Units.smallSpacing;
            rightMargin: PlasmaCore.Units.smallSpacing;
        }
        
        height: trayHeading.height + bottomPadding + container.headingHeight + PlasmaCore.Units.smallSpacing
        Behavior on height {
            NumberAnimation { duration: PlasmaCore.Units.shortDuration/2; easing.type: Easing.InOutQuad }
        }
    }

    // Main content layout
    ColumnLayout {
        id: expandedRepresentation
        anchors.fill: parent
        anchors.margins: PlasmaCore.Units.smallSpacing; // Prevent the main item from directly touching the borders of the popup dialog.
        spacing: plasmoidHeading.bottomPadding

        // Header content layout, shows at the top of the expanded representation.
        RowLayout {
            id: trayHeading

            // This is the back button which appears when the expanded representation is showing an actual item.
            PlasmaComponents.ToolButton {
                id: backButton
                visible: systemTrayState.activeApplet && systemTrayState.activeApplet.expanded && (hiddenLayout.itemCount > 0)
                icon.name: LayoutMirroring.enabled ? "go-previous-symbolic-rtl" : "go-previous-symbolic"
                onClicked: systemTrayState.setActiveApplet(null)
            }

            // The header title, by default writes "Status and Notifications". Has been reduced in size.
            PlasmaExtras.Heading {
                Layout.fillWidth: true
                leftPadding: systemTrayState.activeApplet ? 0 : PlasmaCore.Units.smallSpacing * 2

                level: 4
                text: systemTrayState.activeApplet ? systemTrayState.activeApplet.title : i18n("Status and Notifications")
            }

            // This button appears on certain plasmoids like "Battery and Brightness" and "Disks & Devices".
            // It effectively just shows a context menu with actions specific to the plasmoid. Equivalent to right clicking on the system tray icon.
            PlasmaComponents.ToolButton {
                id: actionsButton
                visible: visibleActions > 0
                checked: visibleActions > 1 ? configMenu.status !== PC2.DialogStatus.Closed : singleAction && singleAction.checked
                property QtObject applet: systemTrayState.activeApplet || plasmoid
                onAppletChanged: {
                    configMenu.clearMenuItems();
                    updateVisibleActions();
                }
                property int visibleActions: 0
                property QtObject singleAction

                function updateVisibleActions() {
                    let newSingleAction = null;
                    let newVisibleActions = 0;
                    for (let i in applet.contextualActions) {
                        let action = applet.contextualActions[i];
                        if (action.visible && action !== actionsButton.applet.action("configure")) {
                            newVisibleActions++;
                            newSingleAction = action;
                            action.changed.connect(() => {updateVisibleActions()});
                        }
                    }
                    if (newVisibleActions > 1) {
                        newSingleAction = null;
                    }
                    visibleActions = newVisibleActions;
                    singleAction = newSingleAction;
                }
                Connections {
                    target: actionsButton.applet
                    function onContextualActionsChanged() {
                        Qt.callLater(actionsButton.updateVisibleActions);
                    }
                }
                icon.name: "application-menu"
                checkable: visibleActions > 1 || (singleAction && singleAction.checkable)
                contentItem.opacity: visibleActions > 1
                // NOTE: it needs an IconItem because QtQuickControls2 buttons cannot load QIcons as their icon
                PlasmaCore.IconItem {
                    parent: actionsButton
                    anchors.centerIn: parent
                    active: actionsButton.hovered
                    implicitWidth: PlasmaCore.Units.iconSizes.smallMedium
                    implicitHeight: implicitWidth
                    source: actionsButton.singleAction !== null ? actionsButton.singleAction.icon : ""
                    visible: actionsButton.singleAction
                }
                onToggled: {
                    if (visibleActions > 1) {
                        if (checked) {
                            configMenu.openRelative();
                        } else {
                            configMenu.close();
                        }
                    }
                }
                onClicked: {
                    if (singleAction) {
                        singleAction.trigger();
                    }
                }

                PlasmaComponents.ToolTip {
                    text: actionsButton.singleAction ? actionsButton.singleAction.text : i18n("More actions")
                }
                PC2.Menu {
                    id: configMenu
                    visualParent: actionsButton
                    placement: PlasmaCore.Types.BottomPosedLeftAlignedPopup
                }

                Instantiator {
                    model: actionsButton.applet.contextualActions
                    delegate: PC2.MenuItem {
                        id: menuItem
                        action: modelData
                    }
                    onObjectAdded: {
                        if (object.action !== actionsButton.applet.action("configure")) {
                            configMenu.addMenuItem(object);
                        }
                    }
                }
            }
            // Button that appears when the currently shown plasmoid has additional settings.
            // Equivalent to right clicking the system tray icon and selecting "Configure [Plasmoid name]..."
            // Appears pretty much always.
            PlasmaComponents.ToolButton {
                icon.name: "settings-configure"
                visible: actionsButton.applet && actionsButton.applet.action("configure")
                PlasmaComponents.ToolTip {
                    text: parent.visible ? actionsButton.applet.action("configure").text : ""
                }
                onClicked: actionsButton.applet.action("configure").trigger();
            }
            // Button that pins the expanded representation and prevents it from closing.
            PlasmaComponents.ToolButton {
                id: pinButton
                checkable: true
                checked: plasmoid.configuration.pin
                onToggled: plasmoid.configuration.pin = checked
                icon.name: "pin"
                PlasmaComponents.ToolTip {
                    text: i18n("Keep Open")
                }
            }
        }

        // Grid view of all available items
        HiddenItemsView {
            id: hiddenItemsView
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.topMargin: PlasmaCore.Units.smallSpacing
            visible: !systemTrayState.activeApplet
        }

        // Container for currently visible item
        PlasmoidPopupsContainer {
            id: container
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: systemTrayState.activeApplet

            // We need to add margin on the top so it matches the dialog's own margin
            Layout.topMargin: mergeHeadings ? 0 : dialog.margins.top
            Layout.leftMargin: PlasmaCore.Units.smallSpacing
            Layout.rightMargin: PlasmaCore.Units.smallSpacing
        }
    }

    // Footer
    PlasmaExtras.PlasmoidHeading {
        id: plasmoidFooter
        location: PlasmaExtras.PlasmoidHeading.Location.Footer
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            
            leftMargin: PlasmaCore.Units.smallSpacing;
            rightMargin: PlasmaCore.Units.smallSpacing;
        }
        visible: container.appletHasFooter
        height: container.footerHeight
        // So that it doesn't appear over the content view, which results in
        // the footer controls being inaccessible
        z: -9999
    }
}
