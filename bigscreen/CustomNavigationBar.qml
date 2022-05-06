/* === This file is part of Calamares - <https://calamares.io> ===
 *
 *   SPDX-FileCopyrightText: 2022 Aditya Mehra <aix.m@outlook.com>
 *   SPDX-License-Identifier: GPL-3.0-or-later
 *
 *   Calamares is Free Software: see the License-Identifier above.
 *
 */

import io.calamares.ui 1.0
import io.calamares.core 1.0

import QtQuick 2.10
import QtQuick.Controls 2.10
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.7 as Kirigami

RowLayout {
    id: buttonBar
    property color accentColor: Branding.styleString(Branding.SidebarTextHighlight)
    property var navigationReturnComponent
    property var navHelper

    onFocusChanged: {
        if(focus){
            if(nextButtonNavBar.enabled) {
                nextButtonNavBar.forceActiveFocus()
            } else if(backButtonNavBar.enabled) {
                backButtonNavBar.forceActiveFocus()
            } else if(quitButtonNavBar.enabled) {
                quitButtonNavBar.forceActiveFocus()
            }
        }
    }

    Rectangle {
        color: backButtonNavBar.activeFocus ? buttonBar.accentColor : "#ff212121"
        Layout.fillWidth: true
        Layout.preferredHeight: Kirigami.Units.gridUnit * 3
        radius: 3

        Button {
            id: backButtonNavBar
            objectName: "backButtonNavBar"
            anchors.fill: parent                        
            anchors.margins: 3                                                
            text: ViewManager.backLabel;
            icon.name: ViewManager.backIcon;
            highlighted: backButtonNavBar.activeFocus ? 1 : 0

            KeyNavigation.right: nextButtonNavBar.enabled ? nextButtonNavBar : (quitButtonNavBar.enabled ? quitButtonNavBar : null)
            Keys.onUpPressed: { navigationReturnComponent.forceActiveFocus() }
            Keys.onReturnPressed: { ViewManager.back() }

            Kirigami.Theme.backgroundColor: Qt.rgba(Kirigami.Theme.backgroundColor.r, Kirigami.Theme.backgroundColor.g, Kirigami.Theme.backgroundColor.b, 0.4)
            Kirigami.Theme.textColor: Kirigami.Theme.textColor

            enabled: ViewManager.backEnabled;
            visible: ViewManager.backAndNextVisible;
            onClicked: { ViewManager.back() }

            onActiveFocusChanged: {
                if(activeFocus) {
                    buttonBar.parent.parent.navHelper.activeFocusedElement = objectName
                }
            }
        }
    }
    
    Rectangle {
        color: nextButtonNavBar.activeFocus ? buttonBar.accentColor : "#ff212121"
        Layout.fillWidth: true
        Layout.preferredHeight: Kirigami.Units.gridUnit * 3
        radius: 3

        Button {
            id: nextButtonNavBar
            objectName: "nextButtonNavBar"
            anchors.fill: parent                        
            anchors.margins: 3      
            text: ViewManager.nextLabel;
            icon.name: ViewManager.nextIcon;
            highlighted: nextButtonNavBar.activeFocus ? 1 : 0

            Kirigami.Theme.backgroundColor: Qt.rgba(Kirigami.Theme.backgroundColor.r, Kirigami.Theme.backgroundColor.g, Kirigami.Theme.backgroundColor.b, 0.4)
            Kirigami.Theme.textColor: Kirigami.Theme.textColor

            enabled: ViewManager.nextEnabled;
            visible: ViewManager.backAndNextVisible;

            KeyNavigation.right: quitButtonNavBar.enabled ? quitButtonNavBar : null
            KeyNavigation.left: backButtonNavBar.enabled ? backButtonNavBar : null
            Keys.onUpPressed: { navigationReturnComponent.forceActiveFocus() }
            Keys.onReturnPressed: { ViewManager.next() }
            onClicked: { ViewManager.next() }

            onActiveFocusChanged: {
                if(activeFocus) {
                    buttonBar.parent.parent.navHelper.activeFocusedElement = objectName
                }
            }
        }
    }

    Rectangle {
        color: quitButtonNavBar.activeFocus ? buttonBar.accentColor : "#ff212121"
        Layout.fillWidth: true
        Layout.preferredHeight: Kirigami.Units.gridUnit * 3
        radius: 3

        Button {
            id: quitButtonNavBar
            objectName: "quitButtonNavBar"
            anchors.fill: parent                        
            anchors.margins: 3 
            text: ViewManager.quitLabel;
            icon.name: ViewManager.quitIcon;
            highlighted: quitButtonNavBar.activeFocus ? 1 :0

            Kirigami.Theme.backgroundColor: Qt.rgba(Kirigami.Theme.backgroundColor.r, Kirigami.Theme.backgroundColor.g, Kirigami.Theme.backgroundColor.b, 0.4)
            Kirigami.Theme.textColor: Kirigami.Theme.textColor

            KeyNavigation.left: nextButtonNavBar.enabled ? nextButtonNavBar : (backButtonNavBar.enabled ? backButtonNavBar : null)
            Keys.onUpPressed: { navigationReturnComponent.forceActiveFocus() }
            Keys.onReturnPressed: { ViewManager.quit() }

            enabled: ViewManager.quitEnabled;
            visible: ViewManager.quitVisible;
            onClicked: { ViewManager.quit() }

            onActiveFocusChanged: {
                if(activeFocus) {
                    buttonBar.parent.parent.navHelper.activeFocusedElement = objectName
                }
            }
        }
    }
}
