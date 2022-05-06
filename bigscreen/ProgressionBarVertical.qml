/* Sample of QML progress tree.

   SPDX-FileCopyrightText: 2020 Adriaan de Groot <groot@kde.org>
   SPDX-FileCopyrightText: 2021 Anke Boersma <demm@kaosx.us>
   SPDX-FileCopyrightText: 2022 Aditya Mehra <aix.m@outlook.com>
   SPDX-License-Identifier: GPL-3.0-or-later


   The progress tree (actually a list) is generally "vertical" in layout,
   with the steps going "down", but it could also be a more compact
   horizontal layout with suitable branding settings.

   This example emulates the layout and size of the widgets progress tree.
*/
import io.calamares.ui 1.0
import io.calamares.core 1.0

import QtQuick 2.3
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.7 as Kirigami

Rectangle {
    id: sideBar;
    color: Branding.styleString( Branding.SidebarBackground )

    ColumnLayout {
        anchors.fill: parent;
        spacing: 1;

        Image {
            Layout.topMargin: 12;
            Layout.bottomMargin: 12;
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            id: logo;
            width: 80;
            height: width;  // square
            source: "file:/" + Branding.imagePath(Branding.ProductLogo);
            sourceSize.width: width;
            sourceSize.height: height;
        }

        Repeater {
            id: viewProgressRepeater
            model: ViewManager

            Rectangle {
                Layout.fillWidth: true;
                Layout.fillHeight: true;
                color: index == ViewManager.currentStepIndex ? Branding.styleString(Branding.SidebarBackgroundSelected) : "#ff212121"

                Text {
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.horizontalCenter: parent.horizontalCenter;

                    color: Branding.styleString( index == ViewManager.currentStepIndex ? Branding.SidebarTextSelected : Branding.SidebarText );
                    text: display;
                }
            }
        }

        Item {
            Layout.fillHeight: true;
        }

        Rectangle {
            Layout.fillWidth: true;
            height: 35
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
            color: Branding.styleString( mouseArea.containsMouse ? Branding.SidebarTextHighlight : Branding.SidebarBackground);
            visible: debug.enabled

            MouseArea {
                id: mouseArea
                anchors.fill: parent;
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                Text {
                    anchors.verticalCenter: parent.verticalCenter;
                    x: parent.x + 4;
                    text: qsTr("Show debug information")
                    color: Branding.styleString( mouseArea.containsMouse ? Branding.SidebarTextSelect : Branding.SidebarBackground );
                    font.pointSize : 9
                }

                onClicked: debug.toggle()
            }
        }
    }
}
