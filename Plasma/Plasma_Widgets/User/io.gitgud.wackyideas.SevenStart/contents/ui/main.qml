/***************************************************************************
 *   Copyright (C) 2014-2015 by Eike Hein <hein@kde.org>                   *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .        *
 ***************************************************************************/

import QtQuick 2.0
import QtQuick.Layouts 1.1

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.private.kicker 0.1 as Kicker

Item {
    id: kicker

    signal reset

    anchors.fill: parent
    property bool isDash: false
    property Item dragSource: null

    // With this we can make the compact representation be any
    // item we want.
    Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation
    Plasmoid.compactRepresentation: null
    Plasmoid.fullRepresentation: compactRepresentation

    property QtObject globalFavorites: rootModel.favoritesModel
    property QtObject systemFavorites: rootModel.systemFavoritesModel

    // Runs KMenuEdit.
    function action_menuedit() {
        processRunner.runMenuEditor();
    }

    function action_taskman() {
        menu_executable.exec("ksysguard");
    }
  
    Component {
        id: compactRepresentation
        CompactRepresentation {}
    }

    Component {
        id: menuRepresentation
        MenuRepresentation {}
    }

    // Used to run separate programs through this plasmoid.
    PlasmaCore.DataSource {
    	id: menu_executable
    	engine: "executable"
    	connectedSources: []
    	onNewData: {
    	    var exitCode = data["exit code"]
    	    var exitStatus = data["exit status"]
    	    var stdout = data["stdout"]
    	    var stderr = data["stderr"]
    	    exited(sourceName, exitCode, exitStatus, stdout, stderr)
    	    disconnectSource(sourceName)
    	}
    	function exec(cmd) {
    	    if (cmd) {
    	        connectSource(cmd)
    	    }
    	}
    	signal exited(string cmd, int exitCode, int exitStatus, string stdout, string stderr)
    }

    Kicker.RootModel {
        id: rootModel

        autoPopulate: false

        appNameFormat: plasmoid.configuration.appNameFormat
        flat: true
        sorted: true
        showSeparators: true
        appletInterface: plasmoid

        paginate: false
        pageSize: plasmoid.configuration.numberColumns *  plasmoid.configuration.numberRows

        showAllApps: false
        showRecentApps: true
        showRecentDocs: false
        showRecentContacts: false
        showPowerSession: false

        onFavoritesModelChanged: {
            if ("initForClient" in favoritesModel) {
                favoritesModel.initForClient("org.kde.plasma.kicker.favorites.instance-" + plasmoid.id)

                if (!plasmoid.configuration.favoritesPortedToKAstats) {
                    favoritesModel.portOldFavorites(plasmoid.configuration.favoriteApps);
                    plasmoid.configuration.favoritesPortedToKAstats = true;
                }
            } else {
                favoritesModel.favorites = plasmoid.configuration.favoriteApps;
            }
            favoritesModel.maxFavorites = pageSize;
        }

        onSystemFavoritesModelChanged: {
            systemFavoritesModel.enabled = false;
            systemFavoritesModel.favorites = plasmoid.configuration.favoriteSystemActions;
            systemFavoritesModel.maxFavorites = 8;
        }

        Component.onCompleted: {
            if ("initForClient" in favoritesModel) {
                favoritesModel.initForClient("org.kde.plasma.kicker.favorites.instance-" + plasmoid.id)

                if (!plasmoid.configuration.favoritesPortedToKAstats) {
                    favoritesModel.portOldFavorites(plasmoid.configuration.favoriteApps);
                    plasmoid.configuration.favoritesPortedToKAstats = true;
                }
            } else {
                favoritesModel.favorites = plasmoid.configuration.favoriteApps;
            }

            favoritesModel.maxFavorites = pageSize;
            rootModel.refresh();
        }
    }

    Connections {
        target: globalFavorites

        function onFavoritesChanged() {
            plasmoid.configuration.favoriteApps = target.favorites;
        }
    }

    Connections {
        target: systemFavorites

        function onFavoritesChanged() {
            plasmoid.configuration.favoriteSystemActions = target.favorites;
        }
    }

    Connections {
        target: plasmoid.configuration

        function onFavoriteAppsChanged() {
            globalFavorites.favorites = plasmoid.configuration.favoriteApps;
        }

        function onFavoriteSystemActionsChanged() {
            systemFavorites.favorites = plasmoid.configuration.favoriteSystemActions;
        }
    }

    Kicker.RunnerModel {
        id: runnerModel

        favoritesModel: globalFavorites
        runners: plasmoid.configuration.useExtraRunners ? new Array("services").concat(plasmoid.configuration.extraRunners) : "services"
        appletInterface: plasmoid

        deleteWhenEmpty: false
    }

    Kicker.DragHelper {
        id: dragHelper
    }

    Kicker.ProcessRunner {
        id: processRunner
    }

	// SVGs
    PlasmaCore.FrameSvgItem {
        id : highlightItemSvg
        visible: false
        imagePath: Qt.resolvedUrl("svgs/menuitem.svg")
        prefix: "hover"
    }
    PlasmaCore.FrameSvgItem {
        id : panelSvg
        visible: false
        imagePath: "widgets/panel-background"
    }
    PlasmaCore.Svg {
        id: arrowsSvg
        imagePath: Qt.resolvedUrl("svgs/arrows.svgz")
        size: "16x16"
    }
    PlasmaCore.Svg {
        id: lockScreenSvg
        imagePath: Qt.resolvedUrl("svgs/system-lock-screen.svg")
    }

    PlasmaComponents.Label {
        id: toolTipDelegate

        width: contentWidth
        height: contentHeight

        property Item toolTip

        text: (toolTip != null) ? toolTip.text : ""
    }

    function resetDragSource() {
        dragSource = null;
    }

    Component.onCompleted: {
        plasmoid.setAction("menuedit", i18n("Edit Applications..."));
        plasmoid.setAction("taskman", i18n("Task Manager"));

        rootModel.refreshed.connect(reset);

        dragHelper.dropped.connect(resetDragSource);
    }
}
