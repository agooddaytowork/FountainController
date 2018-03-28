import QtQuick 2.9
import QtQuick.Controls 2.3

ApplicationWindow {
    id: window
    visible: true
    width: 1200
    height: 600
    title: qsTr("FountainController")

    minimumWidth: 1200
    minimumHeight: 600

    header: ToolBar {
               contentHeight: toolButton.implicitHeight

               Row{
                   anchors.fill: parent
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
                               text: "Setup Mode"
                               font.pixelSize: 16
                               onTriggered: {
                                   stackView.push(Qt.resolvedUrl("SetupModePage.qml"), {"fountainProgramModel": testModel})
                                   console.log("Setup Mode page")
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
                           MenuItem {
                               text: "Manual Mode"
                               font.pixelSize: 16
                               onTriggered: {

                                   stackView.push(Qt.resolvedUrl("ManualModePage.qml"))
                                   console.log("Manual Mode page")
                               }

                           }
                       }
                   }

                   ToolButton
                   {
                       text: "Thêm chương trình"
                       id: addNewProgramButton
                       implicitHeight: 60
                       font.pixelSize: Qt.application.font.pixelSize * 1.6


                   }

               }


        Label
        {
            id: clockLabel
            text: new Date().toDateString() +" - " + new Date().toLocaleTimeString("H:mm")
            anchors.centerIn: parent
            font.pixelSize: 20
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

    Timer
    {
        id: clockTimer
        interval: 15000
        repeat: true
        running: true
        triggeredOnStart:  true
        onTriggered:
        {
            clockLabel.text = new Date().toDateString() +" - " + new Date().toLocaleTimeString("H:mm")
        }
    }

    ListModel {
        id: testModel
            ListElement{
                programName: "chương trình 1"
                groups:[
                    ListElement
                    {
                        groupName: "tủ điện 1"
                        fountainGroupEnable: false
                        fountains:[
                            ListElement
                            {
                                fountainName: 1
                                fountainProgram: 5
                                fountainEnable: true
                            },
                            ListElement
                            {
                                fountainName: 2
                                fountainProgram: 5
                                fountainEnable: false
                            },
                            ListElement
                            {
                                fountainName: 3
                                fountainProgram: 5
                                fountainEnable: true
                            },
                            ListElement
                            {
                                fountainName: 4
                                fountainProgram: 5
                                fountainEnable: false
                            },
                            ListElement
                            {
                                fountainName: 5
                                fountainProgram: 5
                                fountainEnable: true
                            },
                            ListElement
                            {
                                fountainName: 6
                                fountainProgram: 5
                                fountainEnable: false
                            }
                            ,
                            ListElement
                            {
                                fountainName: 7
                                fountainProgram: 5
                                fountainEnable: true
                            },
                            ListElement
                            {
                                fountainName: 8
                                fountainProgram: 5
                                fountainEnable: false
                            },
                            ListElement
                            {
                                fountainName: 9
                                fountainProgram: 5
                                fountainEnable: false
                            }
                        ]
                    },
                    ListElement
                    {
                        groupName: "tủ điện 2"
                        fountainGroupEnable: true
                        fountains:[
                            ListElement
                            {
                                fountainName: 1
                                fountainProgram: 5
                                fountainEnable: true
                            },
                            ListElement
                            {
                                fountainName: 2
                                fountainProgram: 2
                                fountainEnable: false
                            },
                            ListElement
                            {
                                fountainName: 3
                                fountainProgram: 4
                                fountainEnable: true
                            },
                            ListElement
                            {
                                fountainName: 4
                                fountainProgram: 5
                                fountainEnable: false
                            },
                            ListElement
                            {
                                fountainName: 5
                                fountainProgram: 5
                                fountainEnable: true
                            },
                            ListElement
                            {
                                fountainName: 6
                                fountainProgram: 5
                                fountainEnable: false
                            }
                            ,
                            ListElement
                            {
                                fountainName: 7
                                fountainProgram: 5
                                fountainEnable: true
                            },
                            ListElement
                            {
                                fountainName: 8
                                fountainProgram: 5
                                fountainEnable: false
                            },
                            ListElement
                            {
                                fountainName: 9
                                fountainProgram: 5
                                fountainEnable: false
                            }
                        ]
                    }]

            }
            ListElement{
                programName: "chương trình 2"
                groups:[
                    ListElement
                    {
                        groupName: "tủ điện 3"
                        fountainGroupEnable: true
                    },
                    ListElement
                    {
                        groupName: "tủ điện 4"
                        fountainGroupEnable: false
                    }]

            }
        }
}
