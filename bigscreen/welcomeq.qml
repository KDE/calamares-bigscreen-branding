/* === This file is part of Calamares - <https://calamares.io> ===
 *
 *   SPDX-FileCopyrightText: 2020 Adriaan de Groot <groot@kde.org>
 *   SPDX-FileCopyrightText: 2020 Anke Boersma <demm@kaosx.us>
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
import org.kde.kitemmodels 1.0 as KItemModels
import QtQml.Models 2.10
import QtGraphicalEffects 1.0
import QtQuick.Window 2.3

import Libfakeqevents 1.0 as LQ

Page {
    id: welcomePage
    readonly property color backgroundColor: Branding.styleString(Branding.SidebarBackground)
    readonly property color listBackgroundColor: Branding.styleString(Branding.SidebarBackground)
    readonly property color textFieldColor: Branding.styleString(Branding.SidebarText)
    readonly property color textFieldBackgroundColor: Branding.styleString(Branding.SidebarBackground)
    readonly property color textColor: Branding.styleString(Branding.SidebarText)
    readonly property color highlightedTextColor: Branding.styleString(Branding.SidebarText)
    readonly property color highlightColor: Kirigami.Theme.highlightColor
    readonly property color accentColor: Branding.styleString(Branding.SidebarTextHighlight)

    function onActivate(){
        navigationHelper.activePage = "welcomePage"
        if (!requirementsPopup.satisfiedRequirements) {
            requirementsPopup.open()
        } else {
            requirementsPopup.close()
        }
        fakeCursor.moveMouseEvent(mainContentArea.x + 10, 400)
        delay(1000, function() {
            console.log("WelcomeQ: I'm printed after 1 second!")
            fakeCursor.mouseClickEvent()
        })
    }

    LQ.EmulatedMouse {
        id: fakeCursor
    }

    Timer {
        id: timer
    }

    KItemModels.KSortFilterProxyModel {
        id: languageProxyModel
        sourceModel: config.languagesModel
        filterString: searchText.text.trim().toLowerCase()
        filterRowCallback: (source_row, source_parent) => {
                               if (filterString.length > 0) {
                                   var index = sourceModel.index(source_row, 0, source_parent);
                                   return sourceModel.data(index, Qt.UserRole + 1).toLowerCase().includes(filterString)
                               }
                               return true;
                           }
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
            tzContainer.forceActiveFocus()
        }

        ColumnLayout {
            id: mainContentColumnLayout
            width: parent.width
            height: parent.height

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: Kirigami.Units.gridUnit * 3
                
                color: "#ff212121"
                radius: 4
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Kirigami.Units.largeSpacing

                    Text {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        id: welcomeTopText
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        // In QML, QString::arg() only takes one argument
                        color: Branding.styleString(Branding.SidebarText)
                        font.pixelSize: 75
                        fontSizeMode: Text.Fit
                        minimumPixelSize: 10
                        font.bold: true
                        text: qsTr("Welcome to the %1 %2 installer").arg(Branding.string(Branding.ProductName)).arg(Branding.string(Branding.Version))
                    }
                    
                    Text {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        id: welcomeTopTextTwo
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        // In QML, QString::arg() only takes one argument
                        color: Branding.styleString(Branding.SidebarText)
                        font.pixelSize: 45
                        fontSizeMode: Text.Fit
                        minimumPixelSize: 10
                        text: qsTr("This program will ask you some questions and set up %1 on your computer.").arg(Branding.string(Branding.ProductName)).arg(Branding.string(Branding.Version))
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: Kirigami.Units.gridUnit * 3
                
                color: "#ff212121"
                radius: 4

                Label {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    minimumPixelSize: 10
                    font.pixelSize: parent.height * 0.40
                    maximumLineCount: 3
                    fontSizeMode: Text.Fit
                    wrapMode: Text.WordWrap
                    text: qsTr("Setting Up Your Language")
                    color: Branding.styleString(Branding.SidebarText)
                }
            }

            Rectangle {
                id: tzContainer
                objectName: "tzContainer"
                Layout.fillWidth: true
                Layout.fillHeight: true

                radius: 4
                border.width: tzContainer.activeFocus ? 3 : 1
                border.color: tzContainer.activeFocus ? accentColor : Qt.lighter(Kirigami.Theme.backgroundColor, 1.5)
                color: Kirigami.Theme.backgroundColor

                KeyNavigation.down: searchFieldFocusBox
                Keys.onReturnPressed: {
                    tzListView.forceActiveFocus()
                }

                onActiveFocusChanged: {
                    if(activeFocus) {
                        navigationHelper.activeFocusedElement = objectName
                    }
                }

                Kirigami.CardsListView {
                    id: tzListView
                    objectName: "tzListView"
                    anchors.fill: parent
                    anchors.margins: 8

                    spacing: 4
                    currentIndex: config.localeIndex
                    model: languageProxyModel
                    clip: true
                    highlight: Rectangle {
                        color: accentColor
                        radius: 4
                    }

                    ScrollBar.vertical: ScrollBar {
                        active: true
                    }

                    delegate: Kirigami.BasicListItem {
                        width: parent.width
                        height: 40
                        label: model.label
                        
                        Keys.onReturnPressed: {
                            clicked()
                        }

                        Keys.onBackPressed: {
                            clicked()
                            tzContainer.forceActiveFocus()
                        }

                        Keys.onEscapePressed: {
                            clicked()
                            tzContainer.forceActiveFocus()
                        }

                        Keys.onSelectPressed: {
                            clicked()
                        }

                        onClicked: {
                            tzListView.currentIndex = index
                            nextButton.forceActiveFocus()
                        }
                    }

                    onActiveFocusChanged: {
                        if(activeFocus) {
                            navigationHelper.activeFocusedElement = objectName
                        }
                    }

                    onCurrentIndexChanged: {
                        config.localeIndex = tzListView.currentIndex
                        selectedZoneDisplayLabel.text = "Selected Language: " + tzListView.itemAtIndex(tzListView.currentIndex).text
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: Kirigami.Units.gridUnit * 3

                Rectangle {
                    id: searchFieldFocusBox
                    objectName: "searchFieldFocusBox"
                    Layout.fillWidth: true
                    Layout.preferredHeight: Kirigami.Units.gridUnit * 3

                    color: "transparent"
                    border.color: searchFieldFocusBox.activeFocus ? accentColor : "transparent"
                    border.width: searchFieldFocusBox.activeFocus ? 3 : 0

                    KeyNavigation.down: aboutButtonWelcomeQ

                    Keys.onReturnPressed: {
                        searchText.forceActiveFocus()
                    }

                    onActiveFocusChanged: {
                        if(activeFocus) {
                            navigationHelper.activeFocusedElement = objectName
                        }
                    }

                    TextField {
                        id: searchText
                        anchors.fill: parent
                        anchors.margins: 5
                        topPadding: 16
                        bottomPadding: 16
                        placeholderText: qsTr("Search & Filter Language From List")

                        onTextChanged: {
                            console.log(languageProxyModel.count)
                            //selectedZoneDisplayLabel.text = "Selected Language: " + tzListView.itemAtIndex(tzListView.currentIndex).text
                        }
                    }
                }

                Rectangle {
                    color: "#ff212121"
                    Layout.fillWidth: true
                    Layout.preferredHeight: Kirigami.Units.gridUnit * 3


                    Label {
                        id: selectedZoneDisplayLabel
                        anchors.fill: parent
                        anchors.margins: Kirigami.Units.largeSpacing
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.WordWrap
                        text: "Selected Language: " + tzListView.currentItem.label //"Africa/Abidjan"
                        color: Kirigami.Theme.textColor
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: Kirigami.Units.gridUnit * 3

                Rectangle {
                    color: aboutButtonWelcomeQ.activeFocus ? accentColor : "#ff212121"
                    Layout.fillWidth: true
                    Layout.preferredHeight: Kirigami.Units.gridUnit * 3

                    Button {
                        id: aboutButtonWelcomeQ
                        anchors.fill: parent
                        anchors.margins: 3
                        text: qsTr("About")
                        icon.name: "dialog-information"
                        highlighted: aboutButtonWelcomeQ.activeFocus ? 1 : 0

                        KeyNavigation.up: searchFieldFocusBox
                        KeyNavigation.right: bugsButtonWelcomeQ.enabled ? bugsButtonWelcomeQ : (releaseNotesButtonWelcomeQ.enabled ? releaseNotesButtonWelcomeQ : (donateButtonWelcomeQ.enabled ? donateButtonWelcomeQ : aboutButtonWelcomeQ))

                        Keys.onDownPressed: {
                            customNavBar.forceActiveFocus()
                        }

                        Kirigami.Theme.backgroundColor: Qt.rgba(Kirigami.Theme.backgroundColor.r, Kirigami.Theme.backgroundColor.g, Kirigami.Theme.backgroundColor.b, 0.4)
                        Kirigami.Theme.textColor: Kirigami.Theme.textColor

                        visible: true

                        Keys.onReturnPressed: {
                            clicked()
                        }

                        onClicked: {
                            load.source = "about.qml"
                            load.open()
                        }
                    }
                }

                Rectangle {
                    color: bugsButtonWelcomeQ.activeFocus ? accentColor : "#ff212121"
                    Layout.fillWidth: true
                    Layout.preferredHeight: Kirigami.Units.gridUnit * 3
                    visible: bugsButtonWelcomeQ.visible
                    enabled: bugsButtonWelcomeQ.visible

                    Button {
                        id: bugsButtonWelcomeQ
                        anchors.fill: parent
                        anchors.margins: 3
                        text: qsTr("Known issues")
                        icon.name: "tools-report-bug"
                        highlighted: bugsButtonWelcomeQ.activeFocus ? 1 : 0

                        KeyNavigation.up: searchFieldFocusBox
                        KeyNavigation.down: nextButtonNavBar
                        KeyNavigation.left: aboutButtonWelcomeQ
                        KeyNavigation.right: releaseNotesButtonWelcomeQ.enabled ? releaseNotesButtonWelcomeQ : (donateButtonWelcomeQ.enabled ? donateButtonWelcomeQ : bugsButtonWelcomeQ)

                        Kirigami.Theme.backgroundColor: Qt.rgba(Kirigami.Theme.backgroundColor.r, Kirigami.Theme.backgroundColor.g, Kirigami.Theme.backgroundColor.b, 0.4)
                        Kirigami.Theme.textColor: Kirigami.Theme.textColor

                        visible: config.knownIssuesUrl !== ""

                        Keys.onReturnPressed: {
                            clicked()
                        }

                        onClicked: Qt.openUrlExternally(config.knownIssuesUrl)
                    }
                }

                Rectangle {
                    color: releaseNotesButtonWelcomeQ.activeFocus ? accentColor : "#ff212121"
                    Layout.fillWidth: true
                    Layout.preferredHeight: Kirigami.Units.gridUnit * 3
                    visible: releaseNotesButtonWelcomeQ.visible
                    enabled: releaseNotesButtonWelcomeQ.visible

                    Button {
                        id: releaseNotesButtonWelcomeQ
                        anchors.fill: parent
                        anchors.margins: 3
                        text: qsTr("Release notes")
                        icon.name: "folder-text"
                        highlighted: releaseNotesButtonWelcomeQ.activeFocus ? 1 : 0

                        KeyNavigation.up: searchFieldFocusBox
                        KeyNavigation.down: nextButtonNavBar
                        KeyNavigation.left: aboutButtonWelcomeQ
                        KeyNavigation.right: releaseNotesButtonWelcomeQ.enabled ? releaseNotesButtonWelcomeQ : (donateButtonWelcomeQ.enabled ? donateButtonWelcomeQ : releaseNotesButtonWelcomeQ)

                        Kirigami.Theme.backgroundColor: Qt.rgba(Kirigami.Theme.backgroundColor.r, Kirigami.Theme.backgroundColor.g, Kirigami.Theme.backgroundColor.b, 0.4)
                        Kirigami.Theme.textColor: Kirigami.Theme.textColor

                        visible: config.releaseNotesUrl !== ""

                        Keys.onReturnPressed: {
                            clicked()
                        }

                        onClicked: {
                            load.source = "release_notes.qml"
                            load.open()
                        }
                    }
                }

                Rectangle {
                    color: donateButtonWelcomeQ.activeFocus ? accentColor : "#ff212121"
                    Layout.fillWidth: true
                    Layout.preferredHeight: Kirigami.Units.gridUnit * 3
                    visible: donateButtonWelcomeQ.visible
                    enabled: donateButtonWelcomeQ.visible
                    radius: 3

                    Button {
                        id: donateButtonWelcomeQ
                        anchors.fill: parent
                        anchors.margins: 3
                        text: qsTr("Donate")
                        icon.name: "taxes-finances"
                        highlighted: donateButtonWelcomeQ.activeFocus ? 1 : 0

                        KeyNavigation.up: searchFieldFocusBox
                        KeyNavigation.down: nextButtonNavBar
                        KeyNavigation.left: releaseNotesButtonWelcomeQ.enabled ? releaseNotesButtonWelcomeQ : (bugsButtonWelcomeQ.enabled ? bugsButtonWelcomeQ : aboutButtonWelcomeQ)

                        Kirigami.Theme.backgroundColor: Qt.rgba(Kirigami.Theme.backgroundColor.r, Kirigami.Theme.backgroundColor.g, Kirigami.Theme.backgroundColor.b, 0.4)
                        Kirigami.Theme.textColor: Kirigami.Theme.textColor

                        visible: config.donateUrl !== ""

                        Keys.onReturnPressed: {
                            clicked()
                        }
                        
                        onClicked: Qt.openUrlExternally(config.donateUrl)
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
            navigationReturnComponent: aboutButtonWelcomeQ
            navHelper: navigationHelper
        }
    }

    Popup {
        id: requirementsPopup
        width: parent.width / 2
        height: parent.height / 2
        x: parent.width / 2 - width / 2
        y: parent.height / 2 - height / 2
        property bool satisfiedRequirements: config.requirementsModel.satisfiedRequirements

        onClosed: {
            tzContainer.forceActiveFocus()
        }

        background: Rectangle {
            color: "#212121"
        }

        contentItem: Item {
            Requirements {
                visible: !config.requirementsModel.satisfiedRequirements
            }
        }
    }

    Popup {
        id: load
        width: parent.width / 2
        height: parent.height / 2
        x: parent.width / 2 - width / 2
        y: parent.height / 2 - height / 2
        property alias source: messageLoader.source

        background: Rectangle {
            color: "#ff212121"
        }

        contentItem: Item {
            Loader {
                id: messageLoader
                anchors.fill: parent
            }
        }
    }
}
