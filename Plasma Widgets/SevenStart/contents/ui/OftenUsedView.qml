/*
    Copyright (C) 2011  Martin Gräßlin <mgraesslin@kde.org>
    Copyright (C) 2012 Marco Martin <mart@kde.org>
    Copyright (C) 2015  Eike Hein <hein@kde.org>
    Copyright (C) 2017  Ivan Cukic <ivan.cukic@kde.org>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/
import QtQuick 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents

import org.kde.plasma.private.kicker 0.1 as Kicker

/*Kicker.RecentUsageModel {
        id: recentsModel
        favoritesModel: globalFavorites
        ordering: 1 // Popular / Often Used
        Component.onCompleted: {
            var sectionsCount = 0;
            for(var i = 0; i < recentsModel.count; i++)
            {
                if(recentsModel.get(i).objectName === "SectionDelegate")
                {
                    if(recentsModel.get(i).getName() === "Files")
                    {
                        
                    }
                    sectionsCount++;
                    recentsModel.remove(i);
                    i--;
                    continue;
                }
                if(sectionsCount === 2)
                {
                    
                }
            }
        }
}*/
BaseView {
    id: recentsModel
    objectName: "OftenUsedView"

    model: Kicker.RecentUsageModel { 
        favoritesModel: globalFavorites//rootModel.modelForRow(0)
        ordering: 1
        shownItems: Kicker.RecentUsageModel.OnlyApps
    }
}
