/* === This file is part of Calamares - <https://calamares.io> ===
 *
 *   SPDX-FileCopyrightText: 2020-2021 Anke Boersma <demm@kaosx.us>
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
import QtQuick.Window 2.14
import QtQuick.Layouts 1.3

import org.kde.kirigami 2.7 as Kirigami

Item {
    id: control
    property string currentRegion
    property string currentZone
    property color accentColor: Branding.styleString(Branding.SidebarTextHighlight)
    property alias stackIndex: stack.currentIndex

    onActiveFocusChanged: {
        if(activeFocus) {
            if(stackIndex == 0){
                listOneButton.forceActiveFocus()
            }
            if(stackIndex == 1){
                listTwoButton.forceActiveFocus()
            }
        }
    }

    Rectangle {
        id: controlBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: Kirigami.Units.gridUnit * 3
        color: "#ff212121"

        RowLayout {
            id: controlBarLayout
            anchors.fill: parent
            
            Rectangle {
                color: listOneButton.activeFocus ? control.accentColor : "#ff212121"
                Layout.fillWidth: true
                Layout.preferredHeight: Kirigami.Units.gridUnit * 3
                radius: 3
                border.color: Branding.styleString(Branding.SidebarText)
                border.width: stack.currentIndex == 0 ? 1 : 0

                Button {
                    id: listOneButton
                    objectName: "listOneButton"
                    text: "Region Selection"
                    anchors.fill: parent                        
                    anchors.margins: 3
                    highlighted: listOneButton.activeFocus ? 1 : 0
                    flat: stack.currentIndex == 0

                    Kirigami.Theme.backgroundColor: Qt.rgba(Kirigami.Theme.backgroundColor.r, Kirigami.Theme.backgroundColor.g, Kirigami.Theme.backgroundColor.b, 0.4)
                    Kirigami.Theme.textColor: Kirigami.Theme.textColor

                    KeyNavigation.right: listTwoButton
                    KeyNavigation.down: list

                    onActiveFocusChanged: {
                        if(activeFocus) {
                            navigationHelper.activeFocusedElement = objectName
                        }
                    }

                    Keys.onBackPressed: {
                        localStackContainer.forceActiveFocus()
                    }

                    onClicked: {
                        stack.currentIndex = 0
                    }
                }
            }

            Rectangle {
                color: listTwoButton.activeFocus ? control.accentColor : "#ff212121"
                Layout.fillWidth: true
                Layout.preferredHeight: Kirigami.Units.gridUnit * 3
                radius: 3
                border.color: Branding.styleString(Branding.SidebarText)
                border.width: stack.currentIndex == 1 ? 1 : 0

                Button {
                    id: listTwoButton
                    objectName: "listTwoButton"
                    text: "Zone Selection"
                    anchors.fill: parent                        
                    anchors.margins: 3
                    highlighted: listTwoButton.activeFocus ? 1 : 0
                    flat: stack.currentIndex == 1

                    Kirigami.Theme.backgroundColor: Qt.rgba(Kirigami.Theme.backgroundColor.r, Kirigami.Theme.backgroundColor.g, Kirigami.Theme.backgroundColor.b, 0.4)
                    Kirigami.Theme.textColor: Kirigami.Theme.textColor


                    KeyNavigation.left: listOneButton
                    KeyNavigation.down: list2

                    onActiveFocusChanged: {
                        if(activeFocus) {
                            navigationHelper.activeFocusedElement = objectName
                        }
                    }

                    Keys.onBackPressed: {
                        localStackContainer.forceActiveFocus()
                    }

                    onClicked: {
                        stack.currentIndex = 1
                    }
                }
            }
        }
    }
    
    StackLayout {
        id: stack
        anchors.top: controlBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        clip: true
        currentIndex: 0

        ColumnLayout {
            implicitWidth: parent.width
            implicitHeight: parent.height

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: Kirigami.Units.gridUnit * 2
                color: "#ff212121"

                Label {
                    id: region
                    anchors.fill: parent
                    anchors.margins: Kirigami.Units.largeSpacing
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignCenter
                    color: Branding.styleString(Branding.SidebarText)
                    font.pixelSize: parent.height * 0.45
                    text: qsTr("Select your preferred Region, or use the default settings.")
                    maximumLineCount: 1
                    elide: Text.ElideRight
                }
            }

            Kirigami.CardsListView {
                id: list
                objectName: "list"
                Layout.fillWidth: true                
                Layout.fillHeight: true                
                boundsBehavior: Flickable.StopAtBounds
                spacing: 4
                model: config.regionModel
                currentIndex: -1
                clip: true
                highlight: Rectangle {
                    color: control.accentColor
                    radius: 4
                }
                ScrollBar.vertical: ScrollBar {
                    active: true
                }
                
                KeyNavigation.up: listOneButton
                KeyNavigation.down: adjustSettingsButton

                onActiveFocusChanged: {
                    if(activeFocus) {
                        navigationHelper.activeFocusedElement = objectName
                    }
                }

                Keys.onRightPressed: {
                    localStackContainer.forceActiveFocus()
                }

                Keys.onLeftPressed: {
                    localStackContainer.forceActiveFocus()
                }

                Keys.onBackPressed: {
                    localStackContainer.forceActiveFocus()
                }
                
                delegate: Kirigami.BasicListItem {
                    width: parent.width
                    height: 40
                    label: model.name

                    onClicked: {
                        list.currentIndex = index
                        control.currentRegion = model.name
                        config.regionalZonesModel.region = control.currentRegion
                        tztext.text = qsTr("Timezone: %1").arg(config.currentTimezoneName)
                        stack.currentIndex = 1
                        list2.forceActiveFocus()
                    }
                }
            }
        }

        ColumnLayout {
            id: zoneView
            implicitWidth: parent.width
            implicitHeight: parent.height

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: Kirigami.Units.gridUnit * 2
                color: "#ff212121"

                Label {
                    id: zone
                    anchors.fill: parent
                    anchors.margins: Kirigami.Units.largeSpacing
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignCenter
                    color: Branding.styleString(Branding.SidebarText)
                    font.pixelSize: parent.height * 0.45
                    text: qsTr("Select your preferred Zone within your Region.")
                    maximumLineCount: 1
                    elide: Text.ElideRight
                }
            }

            Kirigami.CardsListView {
                id: list2
                objectName: "list2"
                Layout.fillWidth: true                
                Layout.fillHeight: true                
                boundsBehavior: Flickable.StopAtBounds
                spacing: 4
                model: config.regionalZonesModel
                currentIndex: -1
                clip: true
                highlight: Rectangle {
                    color: control.accentColor
                    radius: 4
                }
                ScrollBar.vertical: ScrollBar {
                    active: true
                }

                KeyNavigation.up: listOneButton
                KeyNavigation.down: adjustSettingsButton

                onActiveFocusChanged: {
                    if(activeFocus) {
                        navigationHelper.activeFocusedElement = objectName
                    }
                }

                Keys.onRightPressed: {
                    localStackContainer.forceActiveFocus()
                }

                Keys.onLeftPressed: {
                    localStackContainer.forceActiveFocus()
                }

                Keys.onBackPressed: {
                    localStackContainer.forceActiveFocus()
                }

                delegate: Kirigami.BasicListItem {
                    width: parent.width
                    height: 40
                    label: model.name

                    onClicked: {
                        list2.currentIndex = index
                        list2.positionViewAtIndex(index, ListView.Center)
                        control.currentZone = model.name
                        config.setCurrentLocation(control.currentRegion, control.currentZone)
                        tztext.text = qsTr("Timezone: %1").arg(config.currentTimezoneName)
                        adjustSettingsButton.forceActiveFocus()
                    }
                }
            }
        }
    }
}