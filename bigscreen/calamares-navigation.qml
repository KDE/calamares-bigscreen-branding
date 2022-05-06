/* Sample of QML navigation.
   SPDX-FileCopyrightText: 2020 Adriaan de Groot <groot@kde.org>
   SPDX-License-Identifier: GPL-3.0-or-later
   The navigation panel is generally "horizontal" in layout, with
   buttons for next and previous; this particular one copies
   the layout and size of the widgets panel.
*/
import io.calamares.ui 1.0
import io.calamares.core 1.0

import QtQuick 2.10
import QtQuick.Controls 2.10
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.7 as Kirigami

import Libfakeqevents 1.0 as LQ

Rectangle {
    id: fakeProgress;
    color: Branding.styleString( Branding.SidebarBackground );
    height: 2;

    Repeater {
        id: viewProgressRepeater
        model: ViewManager

        Rectangle {
            width: 2;
            height: 2;
            visible: false
            color: Branding.styleString( index == ViewManager.currentStepIndex ? Branding.SidebarBackgroundSelected : Branding.SidebarBackground );

            Text {
                anchors.verticalCenter: parent.verticalCenter;
                anchors.horizontalCenter: parent.horizontalCenter;
                property bool selected: index == ViewManager.currentStepIndex ? 1 : 0

                onSelectedChanged: {
                    if(index == ViewManager.currentStepIndex) {
                        LQ.FakeEvent.messageCaller(display)
                    }
                }

                color: Branding.styleString( index == ViewManager.currentStepIndex ? Branding.SidebarTextSelected : Branding.SidebarText );
                text: display;
            }
        }
    }
}
