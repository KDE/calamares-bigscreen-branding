/* === This file is part of Calamares - <https://calamares.io> ===
 *
 *   SPDX-FileCopyrightText: 2022 Aditya Mehra <aix.m@outlook.com>
 *   SPDX-License-Identifier: GPL-3.0-or-later
 *
 *   Calamares is Free Software: see the License-Identifier above.
 *
 */

import io.calamares.core 1.0
import io.calamares.ui 1.0

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.14
import QtQuick.Layouts 1.3

import org.kde.kirigami 2.7 as Kirigami

Item {
    anchors.fill: parent
    property var activeFocusedElement
    property var activePage

    function switchTextByFocus(){

        if(activePage == "welcomePage") {
            switch(activeFocusedElement) {
            case "searchFieldFocusBox":
                return [qsTr('Remote: Press the "Select|OK" button to search a language'), qsTr('Keyboard: Press the "Enter" button to search a language')]
            case "tzContainer":
                return [qsTr('Remote: Press the "Select|OK" button to start selecting a language from the list'), qsTr('Keyboard: Press the "Enter" button to start selecting a language from the list')]
            case "timezoneNextBtn":
                return [qsTr('Remote: Press the "Select|OK" button to continue'), qsTr('Keyboard: Press the "Enter" button to continue')]
            case "tzListView":
                return [qsTr('Remote: Use "Up|Down" buttons to navigate, "Select|OK" button to select highlighted language'), qsTr('Keyboard: Use "Up|Down" buttons to navigate, "Enter" button to select highlighted language')]
            case "timezoneSkipButton":
                return [qsTr('Remote: Press the "Select|OK" button to skip language setup and continue'), qsTr('Keyboard: Press the "Enter" button to skip language setup and continue')]
            }
        }

        if(activePage == "localPage") {
            switch(activeFocusedElement) {
            case "localStackContainer":
                return [qsTr('Remote: Press the "Select|OK" button to start selecting a region and zone from the list'), qsTr('Keyboard: Press the "Enter" button to start selecting a region and zone from the list')]
            case "listOneButton":
            case "listTwoButton":
                return [qsTr('Remote: Press the "Select|OK" button to select tab'), qsTr('Keyboard: Press the "Enter" button to select tab')]
            case "list":
            case "list2":
                return [qsTr('Remote: Use "Up|Down" buttons to navigate, "Select|OK" button to select highlighted entry'), qsTr('Keyboard: Use "Up|Down" buttons to navigate, "Enter" button to select highlighted entry')]
            case "nextButtonNavBar":
                return [qsTr('Remote: Press the "Select|OK" button to continue'), qsTr('Keyboard: Press the "Enter" button to continue')]
            case "quitButtonNavBar":
                return [qsTr('Remote: Press the "Select|OK" button to quit setup'), qsTr('Keyboard: Press the "Enter" button to quit setup')]
            case "backButtonNavBar":
                return [qsTr('Remote: Press the "Select|OK" button to return to previous step'), qsTr('Keyboard: Press the "Enter" button to return to previous step')]
            }
        }

        if(activePage == "keyboardPage") {
            switch(activeFocusedElement) {
            case "keyboardModelChooseComboBox":
                return [qsTr('Remote: Press the "Select|OK" button to start selecting a keyboard model from the list'), qsTr('Keyboard: Press the "Enter" button to start selecting a keyboard model from the list')]
            case "localStackContainer":
                return [qsTr('Remote: Press the "Select|OK" button to start selecting a keyboard layout and variant from the list'), qsTr('Keyboard: Press the "Enter" button to start selecting a keyboard layout and variant from the list')]
            case "listOneButton":
            case "listTwoButton":
                return [qsTr('Remote: Press the "Select|OK" button to select tab'), qsTr('Keyboard: Press the "Enter" button to select tab')]
            case "list":
            case "list2":
                return [qsTr('Remote: Use "Up|Down" buttons to navigate, "Select|OK" button to select highlighted entry'), qsTr('Keyboard: Use "Up|Down" buttons to navigate, "Enter" button to select highlighted entry')]
            case "nextButtonNavBar":
                return [qsTr('Remote: Press the "Select|OK" button to continue'), qsTr('Keyboard: Press the "Enter" button to continue')]
            case "quitButtonNavBar":
                return [qsTr('Remote: Press the "Select|OK" button to quit setup'), qsTr('Keyboard: Press the "Enter" button to quit setup')]
            case "backButtonNavBar":
                return [qsTr('Remote: Press the "Select|OK" button to return to previous step'), qsTr('Keyboard: Press the "Enter" button to return to previous step')]
            case "textInputArea":
                return [qsTr('Remote: Press the "Select|OK" button to test keyboard input'), qsTr('Keyboard: Press the "Enter" button to test keyboard input')]
            }
        }
    }

    Item {
        width: parent.width
        height: parent.height * 0.80
        anchors.verticalCenter: parent.verticalCenter

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Kirigami.Units.largeSpacing
            spacing: Kirigami.Units.largeSpacing

            Rectangle {
                color: "#ff212121"
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 4

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Kirigami.Units.smallSpacing

                    Label {
                        id: labelButtonInfo
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.weight: Font.Light
                        minimumPixelSize: 2
                        font.pixelSize: 25
                        maximumLineCount: 5
                        fontSizeMode: Text.Fit
                        wrapMode: Text.WordWrap
                        text: switchTextByFocus()[0]
                        color: Kirigami.Theme.textColor
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Kirigami.Units.gridUnit * 3
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignHTop
                        color: Kirigami.Theme.backgroundColor

                        Kirigami.Icon {
                            anchors.fill: parent
                            anchors.margins: Kirigami.Units.smallSpacing
                            source: Qt.resolvedUrl("assets/remote-ok.svg")
                        }
                    }
                }
            }

            Rectangle {
                color: "#ff212121"
                Layout.fillWidth: true
                Layout.preferredHeight: Kirigami.Units.gridUnit * 2
                radius: 4

                Label {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.weight: Font.Light
                    minimumPixelSize: 2
                    font.pixelSize: 25
                    maximumLineCount: 5
                    fontSizeMode: Text.Fit
                    wrapMode: Text.WordWrap
                    text: "Navigation Helper"
                    color: accentColor
                }
            }

            Rectangle {
                color: "#ff212121"
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 4

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Kirigami.Units.smallSpacing

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Kirigami.Units.gridUnit * 3
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignHTop
                        color: Kirigami.Theme.backgroundColor

                        Kirigami.Icon {
                            anchors.fill: parent
                            anchors.margins: Kirigami.Units.smallSpacing
                            source: Qt.resolvedUrl("assets/keyboard-ok.svg")
                        }
                    }

                    Label {
                        id: labelButtonInfo2
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.weight: Font.Light
                        minimumPixelSize: 2
                        font.pixelSize: 25
                        maximumLineCount: 5
                        fontSizeMode: Text.Fit
                        wrapMode: Text.WordWrap
                        text: switchTextByFocus()[1]
                        color: Kirigami.Theme.textColor
                    }
                }
            }
        }
    }
}
