import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls 2.2

Item {
    id: root
    property int programIndex: 0
    property int fountaingroupIndex: 0
    property int fountainIndex: 0

    property ListModel fountainProgramModel : ListModel {
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
                            founTainEnable: true
                        },
                        ListElement
                        {
                            fountainName: 2
                            fountainProgram: 5
                            founTainEnable: false
                        },
                        ListElement
                        {
                            fountainName: 3
                            fountainProgram: 5
                            founTainEnable: true
                        },
                        ListElement
                        {
                            fountainName: 4
                            fountainProgram: 5
                            founTainEnable: false
                        },
                        ListElement
                        {
                            fountainName: 5
                            fountainProgram: 5
                            founTainEnable: true
                        },
                        ListElement
                        {
                            fountainName: 6
                            fountainProgram: 5
                            founTainEnable: false
                        }
                        ,
                        ListElement
                        {
                            fountainName: 7
                            fountainProgram: 5
                            founTainEnable: true
                        },
                        ListElement
                        {
                            fountainName: 8
                            fountainProgram: 5
                            founTainEnable: false
                        },
                        ListElement
                        {
                            fountainName: 9
                            fountainProgram: 5
                            founTainEnable: false
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
                            founTainEnable: true
                        },
                        ListElement
                        {
                            fountainName: 2
                            fountainProgram: 2
                            founTainEnable: false
                        },
                        ListElement
                        {
                            fountainName: 3
                            fountainProgram: 4
                            founTainEnable: true
                        },
                        ListElement
                        {
                            fountainName: 4
                            fountainProgram: 5
                            founTainEnable: false
                        },
                        ListElement
                        {
                            fountainName: 5
                            fountainProgram: 5
                            founTainEnable: true
                        },
                        ListElement
                        {
                            fountainName: 6
                            fountainProgram: 5
                            founTainEnable: false
                        }
                        ,
                        ListElement
                        {
                            fountainName: 7
                            fountainProgram: 5
                            founTainEnable: true
                        },
                        ListElement
                        {
                            fountainName: 8
                            fountainProgram: 5
                            founTainEnable: false
                        },
                        ListElement
                        {
                            fountainName: 9
                            fountainProgram: 5
                            founTainEnable: false
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


    Grid
    {
        id: setupModePageGridView

        rows: 1
        columns: 3
        anchors.fill: parent

        Rectangle
        {
            id: programListRec
            width: parent.width/3
            height: parent.height
            border.width: 2
            border.color: "black"


            ListView{
                id: programList
                model: fountainProgramModel
                anchors.fill: parent
                clip: true

                delegate: SwipeDelegate{

                    id: programListSwipeDelegate
                    property int programListSwipeDelegateIndex: index

                    width: parent.width
                    height: 60
                    text: programName
                    font.pixelSize: 16
                    background: Rectangle {
                        color: {

                            if(programIndex == programListSwipeDelegateIndex)
                            {
                                "tomato"
                            }
                            else
                            {
                                "white"
                            }
                        }

                        border.color: "black"
                        border.width: 1
                    }



                    swipe.right: Label {
                        id: deleteLabel
                        text: qsTr("Delete")
                        color: "white"
                        verticalAlignment: Label.AlignVCenter
                        padding: 12
                        height: parent.height
                        anchors.right: parent.right

                        //                        SwipeDelegate.onClicked: stationList.model.remove(index)

                        background: Rectangle {
                            color: deleteLabel.SwipeDelegate.pressed ? Qt.darker("tomato", 1.1) : "tomato"
                        }
                    }


                    onClicked: {

                        console.log("current index: " + programListSwipeDelegateIndex)
                        fountainGroupList.model = 0
                        fountainGroupList.model = fountainProgramModel.get(programListSwipeDelegateIndex).groups
                        root.programIndex = programListSwipeDelegateIndex

                    }
                }

            }

        }
        Rectangle    {
            id: fountainGroupListRec
            width: parent.width/3
            height: parent.height
            border.width: 1
            border.color: "black"

            ListView{
                id: fountainGroupList
                model: fountainProgramModel.get(0).groups

                anchors.fill: parent
                clip: true

                delegate: SwipeDelegate{

                    id: fountainGroupListSwipeDelegate
                    property int fountainGroupListSwipeDelegateIndex: index
                    width: parent.width
                    height: 60
                    text: groupName
                    font.pixelSize: 16
                    background: Rectangle{
                        color:
                        {
                            if(fountaingroupIndex == fountainGroupListSwipeDelegateIndex)
                            {
                                "tomato"
                            }
                            else
                            {
                                "white"
                            }
                        }

                        border.color: "black"
                        border.width: 1
                    }

                    Switch
                    {
                        id: fountainGroupEnableGroup
                        text: "Enable"
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        checked: fountainGroupEnable




                        onClicked: {
                            console.log("clicked")
                            fountainProgramModel.get(programIndex).groups.setProperty(fountainGroupListSwipeDelegateIndex,"fountainGroupEnable", checked)
                        }



                    }

                    onClicked:
                    {
                        fountainList.model = 0
                        fountainList.model = fountainProgramModel.get(root.programIndex).groups.get(fountainGroupListSwipeDelegateIndex).fountains
                        fountaingroupIndex = fountainGroupListSwipeDelegateIndex

                    }
                }

            }


        }
        Rectangle    {
            id: fountainListRec
            width: parent.width/3
            height: parent.height
            border.width: 1
            border.color: "black"


            ListView{
                id: fountainList
                model: fountainProgramModel.get(0).groups.get(0).fountains
                anchors.fill: parent
                clip: true


                delegate: SwipeDelegate{

                    id: fountainSwipeDelegate
                    property int fountainSwipeDelegateIndex: index
                    width: parent.width

                    height: 60
                    font.pixelSize: 16
                    text: "đài " + fountainName
                    background: Rectangle{
                        color:
                            fountainSwipeDelegate.pressed ? Qt.darker("tomato", 1.1) : "white"
                        border.color: "black"
                        border.width: 1
                    }

                    Switch
                    {
                        id: fountainEnableSwitch
                        text: "Enable"
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        checked: founTainEnable

                        onClicked:
                        {
                            fountainProgramModel.get(programIndex).groups.get(fountaingroupIndex).fountains.setProperty(fountainSwipeDelegateIndex,"founTainEnable", checked)
                        }
                    }

                    ComboBox
                    {
                        id: fountainComboBox
                        width: 150
                        model: 20
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.rightMargin: fountainEnableSwitch.width + 20
                        currentIndex: fountainProgram
                        font.pixelSize: 16
                        onActivated: {

                            console.log("askdjaslkjd")
                            fountainProgramModel.get(programIndex).groups.get(fountaingroupIndex).fountains.setProperty(fountainSwipeDelegateIndex,"fountainProgram", currentIndex)
                        }

                    }

                }

            }
        }

    }


}
