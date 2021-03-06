import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import Qt.labs.settings 1.0

Item {
    id: root
    objectName: "SetupModePage"
    property int programIndex: 0
    property int fountaingroupIndex: 0
    property int fountainIndex: 0

    property ListModel fountainProgramModel: ListModel {}

    property int listCellHeigh: 45
    property int listCacheBuffer: 0

    function setManualMode(data)
    {
        setupModeSetting.manualMode = data
    }

    Settings
    {
        id: setupModeSetting
        property bool manualMode: false


    }

    function testProgram()
    {
        var serialData = fountainProgramSerializer.serializedProgram(fountainProgramModel.get(programIndex).programName)
        console.log(serialData)

        if(theTcpClient.isSVOnline)
        {
            theTcpClient.sendProgram(fountainProgramModel.get(programIndex).programName,serialData)
        }
    }

    function updateProgramToTextFile()
    {
        dataIoManager.write("Data", root.serializeListModelForSetupPage(fountainProgramModel))
    }

    function serializeListModelForSetupPage(theList)
    {

        var Data = []
        for(var i = 0; i < theList.count; i++)
        {
            var dataModel = {}
            dataModel["programName"]  = theList.get(i).programName
            var groupModel = [];
            for (var ii =0; ii < theList.get(i).groups.count; ii++)
            {

                var fountainModel = []
                var groupObject ={}


                for(var iii =0; iii < theList.get(i).groups.get(ii).fountains.count; iii++)
                {
                    fountainModel.push(theList.get(i).groups.get(ii).fountains.get(iii))
                }
                groupObject["groupName"] = theList.get(i).groups.get(ii).groupName
                groupObject["fountains"] = fountainModel
                groupObject["fountainGroupEnable"] = theList.get(i).groups.get(ii).fountainGroupEnable
                fountainModel=[]
                groupModel.push(groupObject)

            }

            groupObject = {}
            dataModel["groups"] = groupModel
            Data.push(dataModel)
        }

        return JSON.stringify(Data)

    }



    Component.onCompleted: {

        if(dataIoManager.getNameListCount() == 0)
        {
            generateDefaultProgram("Default Program")

            // dataIoManager.write("Data", root.serializeListModelForSetupPage(fountainProgramModel))

        }
        else
        {
            fountainProgramModel.clear()


            fountainProgramModel.append(JSON.parse(dataIoManager.read("Data")))

        }

        programList.currentIndex = 0
        fountainGroupList.currentIndex = 0
        fountainList.currentIndex = 0
    }

    function generateDefaultProgram(programName)
    {

        fountainProgramModel.append({
                                        "programName" : programName,
                                        "groups":[

                                            {"groupName": "FO1",
                                                "fountainGroupEnable": false,
                                                "fountains": [
                                                    {"fountainName": 1,
                                                        "fountainProgram":1,
                                                        "fountainEnable": false},
                                                    {"fountainName": 2,
                                                        "fountainProgram":1,
                                                        "fountainEnable": false},

                                                    {"fountainName": 3,
                                                        "fountainProgram":1,
                                                        "fountainEnable": false},
                                                    {"fountainName": 4,
                                                        "fountainProgram":1,
                                                        "fountainEnable": false},
                                                    {"fountainName": 5,
                                                        "fountainProgram":1,
                                                        "fountainEnable": false},
                                                    {"fountainName": 6,
                                                        "fountainProgram":1,
                                                        "fountainEnable": false}

                                                ]
                                            },
                                            {"groupName": "FO2",
                                                "fountainGroupEnable": false,
                                                "fountains": [
                                                    {"fountainName": 1,
                                                        "fountainProgram":1,
                                                        "fountainEnable": false},
                                                    {"fountainName": 2,
                                                        "fountainProgram":1,
                                                        "fountainEnable": false},

                                                    {"fountainName": 3,
                                                        "fountainProgram":1,
                                                        "fountainEnable": false},
                                                    {"fountainName": 4,
                                                        "fountainProgram":1,
                                                        "fountainEnable": false},
                                                    {"fountainName": 5,
                                                        "fountainProgram":1,
                                                        "fountainEnable": false}

                                                ]
                                            },
                                            {"groupName": "FO3",
                                                "fountainGroupEnable": false,
                                                "fountains": [
                                                    {"fountainName": 1,
                                                        "fountainProgram":1,
                                                        "fountainEnable": false},
                                                    {"fountainName": 2,
                                                        "fountainProgram":1,
                                                        "fountainEnable": false},

                                                    {"fountainName": 3,
                                                        "fountainProgram":1,
                                                        "fountainEnable": false},
                                                    {"fountainName": 4,
                                                        "fountainProgram":1,
                                                        "fountainEnable": false},
                                                    {"fountainName": 5,
                                                        "fountainProgram":1,
                                                        "fountainEnable": false},
                                                    {"fountainName": 6,
                                                        "fountainProgram":1,
                                                        "fountainEnable": false},
                                                    {"fountainName": 7,
                                                        "fountainProgram":1,
                                                        "fountainEnable": false},
                                                    {"fountainName": 8,
                                                        "fountainProgram":1,
                                                        "fountainEnable": false},
                                                    {"fountainName": 9,
                                                        "fountainProgram":1,
                                                        "fountainEnable": false}


                                                ]
                                            },
                                            {"groupName": "FO4",
                                                "fountainGroupEnable": false,
                                                "fountains": [
                                                    {"fountainName": 1,
                                                        "fountainProgram":1,
                                                        "fountainEnable": false},
                                                    {"fountainName": 2,
                                                        "fountainProgram":1,
                                                        "fountainEnable": false}

                                                ]
                                            },
                                            {"groupName": "FO5",
                                                "fountainGroupEnable": false,
                                                "fountains": [
                                                    {"fountainName": 1,
                                                        "fountainProgram":1,
                                                        "fountainEnable": false},
                                                    {"fountainName": 2,
                                                        "fountainProgram":1,
                                                        "fountainEnable": false},

                                                    {"fountainName": 3,
                                                        "fountainProgram":1,
                                                        "fountainEnable": false},
                                                    {"fountainName": 4,
                                                        "fountainProgram":1,
                                                        "fountainEnable": false},
                                                    {"fountainName": 5,
                                                        "fountainProgram":1,
                                                        "fountainEnable": false},
                                                    {"fountainName": 6,
                                                        "fountainProgram":1,
                                                        "fountainEnable": false},


                                                ]
                                            },
                                            {"groupName": "FO6",
                                                "fountainGroupEnable": false,
                                                "fountains": [
                                                    {"fountainName": 1,
                                                        "fountainProgram":1,
                                                        "fountainEnable": false},
                                                    {"fountainName": 2,
                                                        "fountainProgram":1,
                                                        "fountainEnable": false},

                                                    {"fountainName": 3,
                                                        "fountainProgram":1,
                                                        "fountainEnable": false},
                                                    {"fountainName": 4,
                                                        "fountainProgram":1,
                                                        "fountainEnable": false},
                                                    {"fountainName": 5,
                                                        "fountainProgram":1,
                                                        "fountainEnable": false},
                                                    {"fountainName": 6,
                                                        "fountainProgram":1,
                                                        "fountainEnable": false},
                                                    {"fountainName": 7,
                                                        "fountainProgram":1,
                                                        "fountainEnable": false},
                                                    {"fountainName": 8,
                                                        "fountainProgram":1,
                                                        "fountainEnable": false}


                                                ]
                                            },
                                            {"groupName": "FO7",
                                                "fountainGroupEnable": false,
                                                "fountains": [
                                                    {"fountainName": 1,
                                                        "fountainProgram":1,
                                                        "fountainEnable": false},
                                                    {"fountainName": 2,
                                                        "fountainProgram":1,
                                                        "fountainEnable": false},

                                                    {"fountainName": 3,
                                                        "fountainProgram":1,
                                                        "fountainEnable": false},
                                                    {"fountainName": 4,
                                                        "fountainProgram":1,
                                                        "fountainEnable": false}

                                                ]
                                            },
                                            {"groupName": "Sân khô",
                                                "fountainGroupEnable": false,
                                                "fountains": [
                                                    {"fountainName": 1,
                                                        "fountainProgram":1,
                                                        "fountainEnable": false}

                                                ]
                                            }

                                        ]
                                    })

        updateProgramToTextFile()


    }

    Grid
    {
        id: setupModePageGridView

//        columnSpacing: 5
        rowSpacing: 5
        rows: {
            if(parent.width >= 1200)
            {
                1
            }
            else
            {
                3
            }

        }

        columns:{
            if(parent.width >= 1200)
            {
                3
            }
            else
            {
                1
            }
        }

        anchors.fill: parent

        Rectangle
        {
            id: programListRec
            width: {if(parent.width >= 1200)
                {
                   parent.width/3
                }
                else
                {
                    parent.width
                }
            }
            height: {if(parent.width >= 1200)
                {
                   parent.height
                }
                else
                {
                    parent.height/5
                }
            }
            border.width: 2
            border.color: "black"
            color: "#484848"


            ListView{
                id: programList
                model: fountainProgramModel
                anchors.fill: parent
                clip: true
                cacheBuffer: listCacheBuffer

                delegate: SwipeDelegate{

                    id: programListSwipeDelegate
                    property int programListSwipeDelegateIndex: index

                    width: parent.width
                    height: listCellHeigh
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
                                "#212121"
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


                        MouseArea
                        {
                            id: deleteMouseArea
                            anchors.fill: parent

                            onPressed:
                            {
                                fountainProgramModel.remove(index)
                                updateProgramToTextFile()
                            }
                        }

                        background: Rectangle {
                            color: deleteMouseArea.pressed ? Qt.darker("tomato", 1.1) : "tomato"
                        }

                    }

                    onClicked: {

                        console.log("current index: " + programListSwipeDelegateIndex)
                        fountainGroupList.model = 0
                        fountainGroupList.model = fountainProgramModel.get(programListSwipeDelegateIndex).groups
                        root.programIndex = programListSwipeDelegateIndex

                        fountainGroupList.currentIndex =0
                        fountainList.currentIndex = 0
                        fountaingroupIndex = 0
                        fountainIndex = 0
                        fountainList.model = fountainProgramModel.get(root.programIndex).groups.get(fountaingroupIndex).fountains

                        if(setupModeSetting.manualMode)
                        {
                            testProgram()
                        }
                    }
                }
            }

        }
        Rectangle    {
            id: fountainGroupListRec
            width: {if(parent.width >= 1200)
                {
                   parent.width/3
                }
                else
                {
                    parent.width
                }
            }
            height: {if(parent.width >= 1200)
                {
                   parent.height
                }
                else
                {
                    parent.height/5 *2
                }
            }

            border.width: 2
            border.color: "black"
            color: "#484848"

            ListView{
                id: fountainGroupList
                model: fountainProgramModel.get(0).groups
                cacheBuffer: listCacheBuffer
                anchors.fill: parent
                clip: true

                delegate: SwipeDelegate{

                    id: fountainGroupListSwipeDelegate
                    property int fountainGroupListSwipeDelegateIndex: index
                    width: parent.width
                    height: listCellHeigh
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
                                "#212121"
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

                            updateProgramToTextFile()
                            if(setupModeSetting.manualMode)
                            {
                                testProgram()
                            }
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
            width: {if(parent.width >= 1200)
                {
                   parent.width/3
                }
                else
                {
                    parent.width
                }
            }
            height: {if(parent.width >= 1200)
                {
                   parent.height
                }
                else
                {
                    parent.height/5 *2
                }
            }
            border.width: 2
            border.color: "black"
            color: "#484848"


            ListView{
                id: fountainList
                model: fountainProgramModel.get(0).groups.get(0).fountains
                anchors.fill: parent
                clip: true
                cacheBuffer: listCacheBuffer

                delegate: SwipeDelegate{

                    id: fountainSwipeDelegate
                    property int fountainSwipeDelegateIndex: index
                    width: parent.width

                    height: listCellHeigh
                    font.pixelSize: 16
                    text: "đài " + fountainName
                    background: Rectangle{
                        color:
                            fountainSwipeDelegate.pressed ? Qt.darker("tomato", 1.1) : "#212121"
                        border.color: "black"
                        border.width: 1
                    }

                    Switch
                    {
                        id: fountainEnableSwitch
                        text: "Enable"
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        checked: fountainEnable

                        onClicked:
                        {
                            fountainProgramModel.get(programIndex).groups.get(fountaingroupIndex).fountains.setProperty(fountainSwipeDelegateIndex,"fountainEnable", checked)
                            updateProgramToTextFile()

                            if(setupModeSetting.manualMode)
                            {
                                testProgram()
                            }
                        }
                    }

                    ComboBox
                    {
                        id: fountainComboBox
                        width: 150
                        model: 32
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.rightMargin: fountainEnableSwitch.width + 20
                        currentIndex: fountainProgram
                        font.pixelSize: 16
                        onActivated: {


                            fountainProgramModel.get(programIndex).groups.get(fountaingroupIndex).fountains.setProperty(fountainSwipeDelegateIndex,"fountainProgram", currentIndex)

                            updateProgramToTextFile()

                            if(setupModeSetting.manualMode)
                            {
                                testProgram()
                            }
                        }

                    }

                }

            }
        }

    }


}
