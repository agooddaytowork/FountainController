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
                text: stackView.depth > 1 ? "\u25C0" : "\u2630"
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


//            ToolButton
//            {
//                text: "Play program"

//                id: testProgramButton
//                implicitHeight: 60
//                font.pixelSize: Qt.application.font.pixelSize * 1.6
//                visible: {
//                    if(stackView.currentItem.objectName == "SetupModePage") true
//                    else false
//                }

//                //                       visible: true

//                background: Rectangle
//                {

//                    height: toolButton.implicitHeight * 0.7
//                    radius: 5
//                    color: testProgramButton.pressed ? "tomato" : "white"
//                    anchors.verticalCenter: parent.verticalCenter
//                }

//                onClicked:
//                {
//                    stackView.currentItem.testProgram()
//                }
//            }


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
                    stackView.currentItem.manualMode = manualCheckbox.checked
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
        y: (parent.height - height) / 2
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
        y: (parent.height - height) / 2
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

    Settings
    {
        id: appSetting
        property string hostAddress: ""

    }

}
