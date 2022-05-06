/* === This file is part of Calamares - <https://calamares.io> ===
 *
 *   SPDX-FileCopyrightText: 2020 Adriaan de Groot <groot@kde.org>
 *   SPDX-FileCopyrightText: 2020 Anke Boersma <demm@kaosx.us>
 *   SPDX-FileCopyrightText: 2022 Aditya Mehra <aix.m@outlook.com>
 *   SPDX-License-Identifier: GPL-3.0-or-later
 *
 *   Calamares is Free Software: see the License-Identifier above.
 *
 */

import io.calamares.core 1.0
import io.calamares.ui 1.0

import QtQuick 2.10
import QtQuick.Controls 2.10
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.7 as Kirigami
import QtQuick.Window 2.3

import Libfakeqevents 1.0

import Libfakeqevents 1.0 as LQ

Page {
    id: localPage
    readonly property color backgroundColor: Branding.styleString(Branding.SidebarBackground)
    readonly property color listBackgroundColor: Branding.styleString(Branding.SidebarBackground)
    readonly property color textFieldColor: Branding.styleString(Branding.SidebarText)
    readonly property color textFieldBackgroundColor: Branding.styleString(Branding.SidebarBackground)
    readonly property color textColor: Branding.styleString(Branding.SidebarText)
    readonly property color highlightedTextColor: Branding.styleString(Branding.SidebarText)
    readonly property color highlightColor: Kirigami.Theme.highlightColor
    readonly property color accentColor: Branding.styleString(Branding.SidebarTextHighlight)

    function onActivate(){
        navigationHelper.activePage = "localPage"
        fakeCursor.moveMouseEvent(mainContentArea.x + 10, 400)
        delay(1000, function() {
            console.log("LocaleQ: I'm printed after 1 second!")
            fakeCursor.mouseClickEvent()
        })
    }

    // Helper Items For Fake Focus Event
    LQ.EmulatedMouse {
        id: fakeCursor
    }

    Timer {
        id: timer
    }

    function delay(delayTime, cb) {
        timer.interval = delayTime;
        timer.repeat = false;
        timer.triggered.connect(cb);
        timer.start();
    }


    Item {
        id: leftSideBar
        width: parent.width * 0.15
        anchors.top: parent.top
        anchors.bottom: navigationBarArea.top

        Kirigami.Separator {
            id: leftSideBarLine
            anchors.right: parent.right
            height: parent.height
            width: 1
        }

        ProgressionBarVertical {
            id: installProgressBar
            anchors.left: parent.left
            anchors.right: leftSideBarLine.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
        }
    }

    MouseArea {
        id: mainContentArea
        anchors.left: leftSideBar.right
        anchors.right: rightSideBar.left
        anchors.leftMargin: Kirigami.Units.smallSpacing
        anchors.rightMargin: Kirigami.Units.smallSpacing

        anchors.top: parent.top
        anchors.bottom: navigationBarArea.top

        onClicked: {
            localStackContainer.forceActiveFocus()
        }

        ColumnLayout {
            id: mainContentColumnLayout
            width: parent.width
            height: parent.height

            Rectangle {
                id: localStackContainer
                objectName: "localStackContainer"
                Layout.fillWidth: true
                Layout.fillHeight: true
                focus: true

                radius: 4
                border.width: localStackContainer.activeFocus ? 3 : 1
                border.color: localStackContainer.activeFocus ? accentColor : Qt.lighter(Kirigami.Theme.backgroundColor, 1.5)
                color: Kirigami.Theme.backgroundColor

                Keys.onReturnPressed: {
                    offlineView.forceActiveFocus()
                }

                Keys.onDownPressed: {
                    console.log("down pressed")
                    adjustSettingsButton.forceActiveFocus()
                }

                onActiveFocusChanged: {
                    if(activeFocus) {
                        navigationHelper.activeFocusedElement = objectName
                    }
                }

                Offline {
                    id: offlineView
                    anchors.fill: parent
                    anchors.margins: 8
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: Kirigami.Units.gridUnit * 3
                color: "#ff212121"
                radius: 4

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: Kirigami.Units.largeSpacing
                    spacing: Kirigami.Units.largeSpacing

                    Rectangle {
                        Layout.preferredWidth: Kirigami.Units.gridUnit * 12
                        Layout.fillHeight: true
                        radius: 6
                        color: accentColor

                        Text {
                            id: tztext
                            font.pixelSize: parent.height * 0.35
                            width: parent.width
                            height: parent.height
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            text: qsTr("Timezone: %1").arg(config.currentTimezoneName)
                            color: Branding.styleString(Branding.SidebarText)
                        }
                    }

                    Text {
                        font.pixelSize: parent.height * 0.40
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        color: Branding.styleString(Branding.SidebarText)
                        text: qsTr("Fine-Tune Language and Locale Settings")
                    }
                }
            }

            Rectangle {
                id: manualLocalControlArea
                Layout.fillWidth: true
                Layout.preferredHeight: Kirigami.Units.gridUnit * 6
                color: "#ff212121"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Kirigami.Units.largeSpacing
                    
                    Label {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        wrapMode: Text.WordWrap
                        text: config.currentLanguageStatus
                        font.pixelSize: 45
                        fontSizeMode: Text.Fit
                        minimumPixelSize: 10
                        color: Branding.styleString(Branding.SidebarText)
                    }
                    Kirigami.Separator {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 1
                    }
                    Label {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        wrapMode: Text.WordWrap
                        text: config.currentLCStatus
                        font.pixelSize: 45
                        fontSizeMode: Text.Fit
                        minimumPixelSize: 10
                        color: Branding.styleString(Branding.SidebarText)
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Kirigami.Units.gridUnit * 2
                        color: adjustSettingsButton.activeFocus ? accentColor : "#ff212121"
                        radius: 3

                        Button {
                            id: adjustSettingsButton
                            anchors.fill: parent
                            anchors.margins: 3
                            objectName: "adjustSettingsButton"

                            KeyNavigation.up: localStackContainer
                            Keys.onDownPressed: {
                                customNavBar.forceActiveFocus()
                            }

                            onActiveFocusChanged: {
                                if(activeFocus) {
                                    navigationHelper.activeFocusedElement = objectName
                                }
                            }

                            text: qsTr("Adjust Settings")
                            onClicked: {
                                onClicked: load.source = "i18n.qml"
                            }
                        }
                    }
                }
            }
        }
    }

    Item {
        id: rightSideBar
        width: parent.width * 0.15
        anchors.top: parent.top
        anchors.bottom: navigationBarArea.top
        anchors.right: parent.right

        Kirigami.Separator {
            id: rightSideBarLine
            anchors.left: parent.left
            height: parent.height
            width: 1
        }

        NavigationHelper {
            id: navigationHelper
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: rightSideBarLine.right
            anchors.leftMargin: 1
            anchors.right: parent.right
        }
    }

    Item {
        id: navigationBarArea
        width: parent.width
        height: Kirigami.Units.gridUnit * 3
        anchors.bottom: parent.bottom
        
        Kirigami.Separator {
            id: navigationBarAreaLine
            anchors.top: parent.top
            width: parent.width
            height: 1
        }

        CustomNavigationBar {
            id: customNavBar
            width: parent.width
            anchors.top: navigationBarAreaLine.bottom
            anchors.bottom: parent.bottom
            navigationReturnComponent: adjustSettingsButton
            navHelper: navigationHelper
        }
    }
}
