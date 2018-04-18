import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import QtQuick.Controls.Material 2.2

ApplicationWindow {
    id: window
    visible: true
    width: 1200
    height: 600
    title: qsTr("FountainController")

    property bool aboutToclose: false


    onClosing:
    {
        if(theTcpClient.isSVOnline)
        {
            window.aboutToclose = true
            close.accepted = false
            theTcpClient.sendDiconnectNotification()
            askForQuitApplicationDialog.open()

        }



    }

    Connections
    {
        target: theTcpClient
        onNeedToReQuestPermission:
        {
            if(!getPermissionDialog.opened)
            {
               if(!window.aboutToclose)
               {
                   getPermissionDialog.open()
               }


            }


        }

        onCurrentControllingIDDisconnecting:
        {
            if(appSetting.mainController)
            {
                getPermissionDialog.close()
                theTcpClient.requestPermission()
            }
        }
        onSentDisconnectingNotification:
        {

        }
    }

    header: ToolBar {
        contentHeight: toolButton.implicitHeight

        Row{
            //            anchors.fill: parent
            //            anchors.top: parent.top
            //            anchors.left: parent.left
            //            width: 500
            anchors.fill: parent
            //            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10
            ToolButton {
                id: toolButton
                implicitHeight: 60
                text:   ">"
                font.pixelSize: Qt.application.font.pixelSize * 1.6

                onClicked: optionsMenu.open()

                Menu {
                    id: optionsMenu
                    x: parent.width - width
                    transformOrigin: Menu.TopRight

                    MenuItem {
                        text: "Setup/Manual Mode"
                        font.pixelSize: 16
                        onTriggered: {
                            stackView.push(Qt.resolvedUrl("SetupModePage.qml")/*, {"fountainProgramModel": testModel}*/)

                        }

                    }
                    MenuItem {
                        text: "Auto Mode"
                        font.pixelSize: 16
                        onTriggered:{

                            stackView.push(Qt.resolvedUrl("AutoModePage.qml"))
                            console.log("Auto mode page")
                        }

                    }
                }
            }

            Rectangle
            {
                width: 50
                height: toolButton.implicitHeight
                //  anchors.right: parent.right
                //  anchors.rightMargin: 20
                color: addNewMouseArea.pressed? "tomato" : "transparent"

                id: addNewButton
                Image
                {
                    id: addNewIcon
                    anchors.verticalCenter: parent.verticalCenter
                    source: "images/addNew.png"
                    scale: 0.8

                }

                MouseArea
                {
                    id: addNewMouseArea
                    anchors.fill: parent

                    onClicked:
                    {
                        if(stackView.currentItem.objectName == "SetupModePage")
                        {
                            inputDialog.open()

                        }
                        else if(stackView.currentItem.objectName == "AutoModePage")
                        {

                            stackView.currentItem.openTimeSlotDialog = true

                        }
                    }


                }

            }

            Rectangle
            {
                width: 50
                height: toolButton.implicitHeight
                //                anchors.left: parent.left
                //                anchors.leftMargin: 225
                color: playButtonMouseArea.pressed? "tomato" : "transparent"

                id: playButton

                visible:
                {
                    if(stackView.currentItem.objectName == "AutoModePage") true
                    else false
                }

                Image
                {
                    id: playButtonImage
                    anchors.verticalCenter: parent.verticalCenter
                    source: "images/play.png"
                    scale: 0.85
                }

                MouseArea
                {
                    id: playButtonMouseArea
                    anchors.fill: parent

                    onClicked:
                    {
                        if(stackView.currentItem.autoPlayFountain == false)
                        {
                            playButtonImage.source = "images/stop.png"
                            stackView.currentItem.autoPlayFountain = true

                        }
                        else
                        {

                            playButtonImage.source = "images/play.png"
                            stackView.currentItem.autoPlayFountain = false
                        }


                        stackView.currentItem.generateAutoPlayTimerInterval()
                    }

                }

            }

            Rectangle
            {
                width: 50
                height: toolButton.implicitHeight
                //                anchors.left: parent.left
                //                anchors.leftMargin: 225
                color: playProgramButtonMouseArea.pressed? "tomato" : "transparent"

                id: playProgramButton

                visible:
                {
                    if(stackView.currentItem.objectName == "SetupModePage") true
                    else false
                }

                Image
                {
                    id: playProgramButtonImage
                    anchors.verticalCenter: parent.verticalCenter
                    source: "images/play.png"
                    scale: 0.85
                }

                MouseArea
                {
                    id: playProgramButtonMouseArea
                    anchors.fill: parent

                    onClicked:
                    {
                        stackView.currentItem.testProgram()
                    }

                }

            }

            Rectangle
            {
                width: 50
                height: toolButton.implicitHeight
                //  anchors.right: parent.right
                //  anchors.rightMargin: 20
                color: serverStatusMouseArea.pressed? "tomato" : "transparent"

                id: serverStatusIcon
                Image
                {
                    id: svStatusImage
                    anchors.verticalCenter: parent.verticalCenter
                    source: theTcpClient.isSVOnline ? "images/serverOnline.png" : "images/serverOffline.png"

                }

                MouseArea
                {
                    id: serverStatusMouseArea
                    anchors.fill: parent

                    onClicked:
                    {
                        svAddresDialog.open()
                    }

                    pressAndHoldInterval: 3000
                    onPressAndHold:
                    {
                        setMainControllerDialog.open()
                    }
                }

            }

            Rectangle
            {
                width: 50
                height: toolButton.implicitHeight
                //                anchors.right: parent.right
                //                anchors.rightMargin: 40 + toolButton.implicitWidth
                color: "transparent"

                id: fountainStatusIcon
                Image
                {
                    anchors.verticalCenter: parent.verticalCenter
                    source: theTcpClient.isFountainOnline? "images/fountainOnline.png" : "images/fountainOffline.png"
                    scale: 0.8
                }

                MouseArea
                {
                    id: fountainStatusIconMouseArea
                    anchors.fill: parent
                    pressAndHoldInterval: 3000
                    onPressAndHold: {
                        stackView.push(Qt.resolvedUrl("SettinSpeed.qml"))
                    }
                }

            }

            CheckBox
            {
                id: manualCheckbox
                width: 50
                height: toolButton.implicitWidth
                //                anchors.right: parent.right
                //                z:3
                //                anchors.rightMargin: 200 + toolButton.implicitWidth
                anchors.verticalCenter: parent.verticalCenter
                text: "Manual Checkbox"
                visible: {
                    if(stackView.currentItem.objectName == "SetupModePage" ) true
                    else false
                }

                onCheckedChanged: {
                    stackView.currentItem.setManualMode(manualCheckbox.checked)
//                    stackView.currentItem.setupModeSetting.manualMode = manualCheckbox.checked
                }

            }


        }

    }


    StackView {
        id: stackView

        initialItem: AutoModePage
        {
            id: autoModeMainPage
        }

        anchors.fill: parent
    }



    Dialog {
        id: inputDialog

        x: (parent.width - width) / 2
        y: (parent.height - height) / 4
        parent: Overlay.overlay

        focus: true
        modal: true
        title: "Input"
        standardButtons: Dialog.Ok | Dialog.Cancel

        ColumnLayout {
            spacing: 20
            anchors.fill: parent
            Label {


                elide: Label.ElideRight
                text: "Please enter Program name:"
                Layout.fillWidth: true
            }
            TextField {
                id: inputDialogTextField
                focus: true
                placeholderText: "Program name"
                Layout.fillWidth: true
            }

        }

        onAccepted:
        {
            stackView.currentItem.generateDefaultProgram(inputDialogTextField.text)
        }
        onDiscarded:
        {
            inputDialogTextField.text = ""
            inputDialog.close()
        }
    }

    Dialog {
        id: svAddresDialog

        x: (parent.width - width) / 2
        y: (parent.height - height) / 4
        parent: Overlay.overlay

        focus: true
        modal: true
        title: "Server"
        standardButtons:

        {
            if(!theTcpClient.isSVOnline)
            {
                Dialog.Ok | Dialog.Cancel
            }

            else
            {
                Dialog.Cancel
            }
        }


        ColumnLayout {
            spacing: 20
            anchors.fill: parent


            Button{
                id: disconnectToServerButton
                text: "Disconnect to server"

                visible: theTcpClient.isSVOnline
                onClicked: {
                    theTcpClient.sendDiconnectNotification()
                    theTcpClient.disconnect()

                }

            }
            Label {


                elide: Label.ElideRight
                visible: !theTcpClient.isSVOnline
                text: "Please enter Server address:"
                Layout.fillWidth: true
            }
            TextField {
                id: svAddressDialogTextField
                visible: !theTcpClient.isSVOnline
                focus: true
                placeholderText:"Address..."
                Layout.fillWidth: true
                text: appSetting.hostAddress
            }

        }

        onAccepted:
        {
            if(!theTcpClient.isSVOnline)
            {
                appSetting.hostAddress = svAddressDialogTextField.text
                theTcpClient.connect(svAddressDialogTextField.text, 8080)
            }

        }
        onDiscarded:
        {
            svAddresDialog.text = ""
            svAddresDialog.close()
        }
    }

    Dialog
    {
        id: getPermissionDialog
        x: (parent.width - width) / 2
        y: (parent.height - height) / 4
        parent: Overlay.overlay

        focus: true
        modal: true
        title: "Fountain Control Permission"
        closePolicy: Popup.NoAutoClose
        standardButtons:Dialog.Yes | Dialog.No

        ColumnLayout
        {
            spacing: 20
            anchors.fill:  parent

            Label
            {
                text: "Take control ?"
            }


        }

        onAccepted:
        {
            theTcpClient.requestPermission()
        }
        onRejected:
        {

            theTcpClient.sendDiconnectNotification()
            theTcpClient.disconnect()
        }

    }

    Dialog
    {
        id: setMainControllerDialog
        x: (parent.width - width) / 2
        y: (parent.height - height) / 4
        parent: Overlay.overlay

        focus: true
        modal: true
        title: "Main Controller"
        closePolicy: Popup.NoAutoClose
        standardButtons:Dialog.Yes | Dialog.No

        ColumnLayout
        {
            spacing: 20
            anchors.fill:  parent

            Label
            {
                text:
                {
                    if(appSetting.mainController)
                    {
                        "Unset this app as the main controller ?"
                    }
                    else
                    {
                        "Set this app as the main controller ?"
                    }
                }
            }
        }

        onAccepted:
        {
            if(appSetting.mainController)
            {
                appSetting.mainController = false
            }
            else
            {
                appSetting.mainController = true
            }
        }
        onRejected:
        {
            setMainControllerDialog.close()
        }
    }

    Dialog
    {
        id: askForQuitApplicationDialog
        x: (parent.width - width) / 2
        y: (parent.height - height) / 4
        parent: Overlay.overlay

        focus: true
        modal: true
        title: "Exit"
        closePolicy: Popup.NoAutoClose
        standardButtons:Dialog.Yes | Dialog.No

        ColumnLayout
        {
            spacing: 20
            anchors.fill:  parent

            Label
            {
                text: "Do you want to close the program?"
            }

        }

        onAccepted:
        {

            theTcpClient.disconnect()
            Qt.quit()
        }
        onRejected:
        {
            theTcpClient.connect(appSetting.hostAddress,8080)
            askForQuitApplicationDialog.close()
        }

    }

    Settings
    {
        id: appSetting
        property string hostAddress: ""
        property bool mainController: false

    }

}
