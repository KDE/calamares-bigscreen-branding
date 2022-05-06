/* === This file is part of Calamares - <https://calamares.io> ===
 *
 *   SPDX-FileCopyrightText: 2022 Aditya Mehra <aix.m@outlook.com>
 *   SPDX-FileCopyrightText: 2020 - 2022 Anke Boersma <demm@kaosx.us>
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
import "keyboarddata"

import Libfakeqevents 1.0 as LQ

Page {
    id: keyboardPage
    readonly property color backgroundColor: Branding.styleString(Branding.SidebarBackground)
    readonly property color listBackgroundColor: Branding.styleString(Branding.SidebarBackground)
    readonly property color textFieldColor: Branding.styleString(Branding.SidebarText)
    readonly property color textFieldBackgroundColor: Branding.styleString(Branding.SidebarBackground)
    readonly property color textColor: Branding.styleString(Branding.SidebarText)
    readonly property color highlightedTextColor: Branding.styleString(Branding.SidebarText)
    readonly property color highlightColor: Kirigami.Theme.highlightColor
    readonly property color accentColor: Branding.styleString(Branding.SidebarTextHighlight)

    function onActivate(){
        navigationHelper.activePage = "keyboardPage"
        fakeCursor.moveMouseEvent(mainContentArea.x + 10, 400)
        delay(1000, function() {
            console.log("KeyboardQ: I'm printed after 1 second!")
            fakeCursor.mouseClickEvent()
        })
    }

    // Cannot Depend onActivate as it never works for some modules

    Connections {
        target: LQ.FakeEvent
        onCallerReceived: {
            if(sender == "Keyboard"){
                keyboardPage.onActivate()
            }
        }
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

    // Main Contents

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
            console.log("KeyboardQ mainContentArea has been clicked")
            keyboardModelChooseComboBox.forceActiveFocus()
        }

        ColumnLayout {
            id: mainContentColumnLayout
            width: parent.width
            anchors.top: parent.top
            anchors.bottom: keyboard.top

            Rectangle {
                id: controlBarTopLabel
                Layout.fillWidth: true
                Layout.preferredHeight: Kirigami.Units.gridUnit * 3
                Layout.alignment: Qt.AlignTop
                color: "#ff212121"

                Label {
                    id: header
                    anchors.fill: parent
                    anchors.margins: Kirigami.Units.largeSpacing
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: qsTr("To activate keyboard preview, select a layout.")
                    color: textColor
                    font.bold: true
                }
            }

            Rectangle {
                id: controlBarComboArea
                Layout.fillWidth: true
                Layout.preferredHeight: Kirigami.Units.gridUnit * 3
                Layout.alignment: Qt.AlignTop
                color: "#ff212121"
                border.width: keyboardModelChooseComboBox.focus ? 2 : 0
                border.color: keyboardModelChooseComboBox.focus ? accentColor : "transparent"

                RowLayout {
                    id: models
                    anchors.fill: parent
                    anchors.margins: Kirigami.Units.largeSpacing
                    spacing: 10

                    Label {
                        Layout.alignment: Qt.AlignCenter
                        text: qsTr("Keyboard Model:")
                        color: textColor
                        font.bold: true
                    }

                    ComboBox {
                        id: keyboardModelChooseComboBox
                        objectName: "keyboardModelChooseComboBox"

                        Keys.onUpPressed: {
                            customNavBar.forceActiveFocus()
                        }

                        Keys.onDownPressed: {
                            localStackContainer.forceActiveFocus()
                        }

                        Keys.onReturnPressed: {
                            keyboardModelChooseComboBox.popup.open()
                            keyboardModelChooseComboBox.popup.forceActiveFocus()
                        }

                        delegate: ItemDelegate {
                            background: Rectangle {
                                anchors.fill: parent
                                color: "transparent"
                            }

                            contentItem: Kirigami.Heading{
                                level: 2
                                text: model.label
                            }
                        }

                        background: Rectangle {
                            anchors.fill: parent
                            color: keyboardModelChooseComboBox.focus ? accentColor : "transparent"
                        }

                        contentItem: Kirigami.Heading {
                            level: 2
                            text: keyboardModelChooseComboBox.displayText
                        }

                        popup: Popup {
                            y: keyboardModelChooseComboBox.height - 1
                            width: keyboardModelChooseComboBox.width
                            implicitHeight: contentItem.implicitHeight
                            padding: 1

                            onVisibleChanged: {
                                if(visible){
                                    pCView.forceActiveFocus()
                                }
                            }

                            contentItem: ListView {
                                id: pCView
                                clip: true
                                implicitHeight: contentHeight
                                model: keyboardModelChooseComboBox.popup.visible ? keyboardModelChooseComboBox.delegateModel : null
                                currentIndex: keyboardModelChooseComboBox.highlightedIndex
                                keyNavigationEnabled: true
                                highlight: Rectangle {
                                    color: accentColor
                                    radius: 4
                                }
                                highlightFollowsCurrentItem: true
                                snapMode: ListView.SnapToItem

                                Keys.onReturnPressed: {
                                    console.log(currentIndex)
                                    keyboardModelChooseComboBox.currentIndex = pCView.currentIndex
                                    keyboardModelChooseComboBox.popup.close()
                                    keyboardModelChooseComboBox.forceActiveFocus()
                                }
                            }

                            background: Rectangle {
                                anchors {
                                    fill: parent
                                    margins: -1
                                }
                                color: Kirigami.Theme.backgroundColor
                                border.color: Kirigami.Theme.backgroundColor
                                radius: 2
                            }
                        }

                        onFocusChanged: {
                            if(focus) {
                                navigationHelper.activeFocusedElement = keyboardModelChooseComboBox.objectName
                            }
                        }

                        Layout.fillWidth: true
                        textRole: "label"
                        model: config.keyboardModelsModel
                        currentIndex: model.currentIndex
                        onCurrentIndexChanged: config.keyboardModels = currentIndex
                    }
                }
            }

            Rectangle {
                id: localStackContainer
                objectName: "localStackContainer"
                Layout.fillWidth: true
                Layout.fillHeight: true

                radius: 4
                border.width: localStackContainer.activeFocus ? 3 : 1
                border.color: localStackContainer.activeFocus ? accentColor : Qt.lighter(Kirigami.Theme.backgroundColor, 1.5)
                color: Kirigami.Theme.backgroundColor

                KeyNavigation.up: keyboardModelChooseComboBox

                Keys.onReturnPressed: {
                    if(stack.currentIndex == 0){
                        listOneButton.forceActiveFocus()
                    }
                    if(stack.currentIndex == 1){
                        listTwoButton.forceActiveFocus()
                    }
                }

                Keys.onDownPressed: {
                    textInputArea.forceActiveFocus()
                }

                onActiveFocusChanged: {
                    if(activeFocus) {
                        navigationHelper.activeFocusedElement = objectName
                    }
                }

                Rectangle {
                    id: controlBar
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: Kirigami.Units.smallSpacing
                    height: Kirigami.Units.gridUnit * 3
                    color: "#ff212121"

                    RowLayout {
                        id: controlBarLayout
                        anchors.fill: parent

                        Rectangle {
                            color: listOneButton.activeFocus ? keyboardPage.accentColor : "#ff212121"
                            Layout.fillWidth: true
                            Layout.preferredHeight: Kirigami.Units.gridUnit * 3
                            radius: 3
                            border.color: Branding.styleString(Branding.SidebarText)
                            border.width: stack.currentIndex == 0 ? 1 : 0

                            Button {
                                id: listOneButton
                                objectName: "listOneButton"
                                text: "Layout Selection"
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
                            color: listTwoButton.activeFocus ? keyboardPage.accentColor : "#ff212121"
                            Layout.fillWidth: true
                            Layout.preferredHeight: Kirigami.Units.gridUnit * 3
                            radius: 3
                            border.color: Branding.styleString(Branding.SidebarText)
                            border.width: stack.currentIndex == 1 ? 1 : 0

                            Button {
                                id: listTwoButton
                                objectName: "listTwoButton"
                                text: "Variant Selection"
                                anchors.fill: parent
                                anchors.margins: 3
                                highlighted: listTwoButton.activeFocus ? 1 : 0
                                flat: stack.currentIndex == 1

                                Kirigami.Theme.backgroundColor: Qt.rgba(Kirigami.Theme.backgroundColor.r, Kirigami.Theme.backgroundColor.g, Kirigami.Theme.backgroundColor.b, 0.4)
                                Kirigami.Theme.textColor: Kirigami.Theme.textColor


                                KeyNavigation.left: listOneButton
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
                    anchors.margins: Kirigami.Units.smallSpacing
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
                                id: keyboardViewOne
                                anchors.fill: parent
                                anchors.margins: Kirigami.Units.largeSpacing
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignCenter
                                color: Branding.styleString(Branding.SidebarText)
                                font.pixelSize: parent.height * 0.45
                                text: qsTr("Select your preferred keyboard layout.")
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
                            model: config.keyboardLayoutsModel
                            currentIndex: model.currentIndex
                            clip: true
                            highlight: Rectangle {
                                color: accentColor
                                radius: 4
                            }
                            ScrollBar.vertical: ScrollBar {
                                id: listScrollBar
                                active: true
                            }

                            KeyNavigation.up: listOneButton
                            KeyNavigation.down: adjustSettingsButton

                            Keys.onBackPressed: {
                                localStackContainer.forceActiveFocus()
                            }

                            Keys.onRightPressed: {
                                localStackContainer.forceActiveFocus()
                            }

                            Keys.onLeftPressed: {
                                localStackContainer.forceActiveFocus()
                            }

                            onActiveFocusChanged: {
                                if(activeFocus) {
                                    navigationHelper.activeFocusedElement = objectName
                                }
                            }

                            Component.onCompleted: positionViewAtIndex(model.currentIndex, ListView.Contain)

                            delegate: Kirigami.BasicListItem {
                                width: parent.width
                                height: 40
                                label: model.label

                                Keys.onReturnPressed: {
                                    clicked()
                                }

                                onClicked: {
                                    list.currentIndex = index
                                    list.model.currentIndex = index
                                    keyIndex = label1.text.substring(0,6)
                                    stack.currentIndex = 1
                                    list2.forceActiveFocus()
                                }
                            }
                        }
                    }

                    ColumnLayout {
                        id: variantView
                        implicitWidth: parent.width
                        implicitHeight: parent.height

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: Kirigami.Units.gridUnit * 2
                            color: "#ff212121"

                            Label {
                                id: variant
                                anchors.fill: parent
                                anchors.margins: Kirigami.Units.largeSpacing
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignCenter
                                color: Branding.styleString(Branding.SidebarText)
                                font.pixelSize: parent.height * 0.45
                                text: qsTr("Select your preferred keyboard layout variant.")
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
                            model: config.keyboardVariantsModel
                            currentIndex: model.currentIndex
                            clip: true
                            highlight: Rectangle {
                                color: accentColor
                                radius: 4
                            }
                            ScrollBar.vertical: ScrollBar {
                                id: list2ScrollBar
                                active: true
                            }

                            KeyNavigation.up: listOneButton
                            KeyNavigation.down: adjustSettingsButton

                            Keys.onBackPressed: {
                                localStackContainer.forceActiveFocus()
                            }

                            Keys.onRightPressed: {
                                localStackContainer.forceActiveFocus()
                            }

                            Keys.onLeftPressed: {
                                localStackContainer.forceActiveFocus()
                            }

                            onActiveFocusChanged: {
                                if(activeFocus) {
                                    navigationHelper.activeFocusedElement = objectName
                                }
                            }

                            Component.onCompleted: positionViewAtIndex(model.currentIndex, ListView.Center)

                            delegate: Kirigami.BasicListItem {
                                width: parent.width
                                height: 40
                                label: model.label

                                Keys.onReturnPressed: {
                                    clicked()
                                }

                                onClicked: {
                                    list2.currentIndex = index
                                    list2.model.currentIndex = index
                                    list2.positionViewAtIndex(index, ListView.Contain)
                                    //adjustSettingsButton.forceActiveFocus()
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                id: textInputArea
                Layout.fillWidth: true
                Layout.preferredHeight: Kirigami.Units.gridUnit * 3
                color: textInputArea.focus ? accentColor : "#ff212121"
                objectName: "textInputArea"

                Keys.onUpPressed: {
                    localStackContainer.forceActiveFocus()
                }

                Keys.onDownPressed: {
                    customNavBar.forceActiveFocus()
                }

                Keys.onReturnPressed: {
                    textInput.forceActiveFocus()
                }

                onActiveFocusChanged: {
                    if(activeFocus) {
                        navigationHelper.activeFocusedElement = objectName
                    }
                }

                TextField {
                    id: textInput
                    placeholderText: qsTr("Type here to test your keyboard")
                    horizontalAlignment: TextInput.AlignHCenter
                    anchors.fill: parent
                    anchors.margins: 3

                    onAccepted: {
                        textInputArea.forceActiveFocus()
                    }

                    Keys.onUpPressed: {
                        textInputArea.forceActiveFocus()
                    }

                    Keys.onDownPressed: {
                        customNavBar.forceActiveFocus()
                    }
                }
            }
        }

        Keyboard {
            id: keyboard
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: parent.height * 0.25
            source: langXml.includes(keyIndex) ? (keyIndex + ".xml") :
                    afganiXml.includes(keyIndex) ? "afgani.xml" :
                    scanXml.includes(keyIndex) ? "scan.xml" :
                    genericXml.includes(keyIndex) ? "generic.xml" :
                    genericQzXml.includes(keyIndex) ? "generic_qz.xml" :
                    arXml.includes(keyIndex) ? "ar.xml" :
                    deXml.includes(keyIndex) ? "de.xml" :
                    enXml.includes(keyIndex) ? "en.xml" :
                    esXml.includes(keyIndex) ? "es.xml" :
                    frXml.includes(keyIndex) ? "fr.xml" :
                    ptXml.includes(keyIndex) ? "pt.xml" :
                    ruXml.includes(keyIndex) ? "ru.xml" :"empty.xml"
            rows: 4
            columns: 10
            keyColor: "transparent"
            keyPressedColorOpacity: 0.2
            keyImageLeft: "button_bkg_left.png"
            keyImageRight: "button_bkg_right.png"
            keyImageCenter: "button_bkg_center.png"
            target: textInput
            onEnterClicked: console.log("Enter!")
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
            navigationReturnComponent: textInputArea
            navHelper: navigationHelper
        }
    }
}
