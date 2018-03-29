import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls 2.2


Item {
    id: root
    objectName: "AutoModePage"

    property bool openTimeSlotDialog: false
    property ListModel timeSLotModelUnsorted: ListModel {}
    property ListModel timeSlotModelSorted : ListModel {}
    property int currentUnsortedIndex: 0

    onOpenTimeSlotDialogChanged: {
        if(openTimeSlotDialog)
        {
            generateDefaultTimeSLot()
            timeSlotDialog.open()
        }
    }

    function generateDefaultTimeSLot()
    {

        timeSLotModelUnsorted.append({
                                         "fromHour" : 8,
                                         "dayNightPeriod": "AM",
                                         "fromMinute" : 5,
                                         "toHour": 9,
                                         "toMinute": 20,
                                         "timeSlotEnable": false,
                                         "repeat": 0,
                                         "program": 1,
                                         "description": "default program"
                                     })

        currentUnsortedIndex = (timeSLotModelUnsorted.count - 1)

    }



    GridView{
        id: autoModeGridView
        anchors.fill: parent
        cellHeight: parent.height/2
        cellWidth: parent.width/4

        model: 5


        delegate: SwipeDelegate{
            id: timeSlotRec
            width: autoModeGridView.cellWidth
            height: autoModeGridView.cellHeight
            //            border.width: 1
            //            border.color: "black"


            Column{
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 10
                spacing: 10
                Label
                {
                    id: fromHourLabel
                    text: "5.30 AM - 6.30 AM"
                    font.pixelSize: 30
                }

                Label
                {
                    id: timeSlotDescLabel
                    text: "Chơi buổi sáng"
                    font.pixelSize: 20

                }


                Label
                {
                    id: repeateLabel
                    text: "Lặp lại: thứ Hai"
                    font.pixelSize: 20
                }
                Label
                {
                    id: programLabel
                    text: "Chương trình: 3"
                    font.pixelSize: 20
                }
            }

            Switch
            {
                id: enableSchedulerSwitch

                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 20
                anchors.rightMargin: 20
                text: "test"
                z:2

            }
            background: Rectangle
            {
                color:
                {
                    "white"
                }

                border.color: "black"
                border.width: 1
            }

        }
    }

    Dialog
    {
        id: timeSlotDialog
        x: (parent.width- timeSlotDialogRec.width)/2
        y: (parent.height - timeSlotDialogRec.height)/2
        parent: ApplicationWindow.overlay
        modal: true


        onAboutToShow:
        {
            toOrFromSelector.fromIsSelected = true
           hoursTumbler.currentIndex = timeSLotModelUnsorted.get(currentUnsortedIndex).fromHour -1
            minutesTumbler.currentIndex = timeSLotModelUnsorted.get(currentUnsortedIndex).fromMinute
            if(timeSLotModelUnsorted.get(currentUnsortedIndex).dayNightPeriod === "AM")
            {
                amPmTumbler.currentIndex = 0
            }
            else
            {
                amPmTumbler.currentIndex = 1
            }

        }

        onAboutToHide: openTimeSlotDialog = false
        function formatText(count, modelData) {
            var data = count === 12 ? modelData + 1 : modelData;
            return data.toString().length < 2 ? "0" + data : data;
        }
        Rectangle
        {
            id: timeSlotDialogRec
            width: 400
            height: 500
            color: "white"
            radius: 5

            Column
            {
                anchors.fill: parent
                spacing: 5

                Row
                {
                    Button
                    {
                        text: "Close"
                    }

                    Button
                    {
                        text: "Add new"
                    }
                }

                Row
                {

                    anchors.horizontalCenter: parent.horizontalCenter


                    Repeater
                    {
                        id: toOrFromSelector
                        model: toOrFromModel
                        property bool fromIsSelected: false

                        delegate: Rectangle
                        {
                            width: 50
                            height: 50

                            Label
                            {
                                text: modelName
                                anchors.centerIn: parent
                            }

                            border.width: 2
                            color: {

                                if(modelName == "From" && toOrFromSelector.fromIsSelected )
                                {
                                    "tomato"
                                }
                                else if(modelName == "To" && !toOrFromSelector.fromIsSelected)
                                {
                                    "tomato"
                                }
                                else
                                {
                                    "white"
                                }

                            }

                            MouseArea
                            {
                                anchors.fill: parent
                                onClicked:
                                {
                                    if(modelName == "From")
                                    {
                                        toOrFromSelector.fromIsSelected = true
                                    }
                                    else
                                    {
                                        toOrFromSelector.fromIsSelected = false
                                    }
                                }
                            }

                        }
                    }

                    ListModel
                    {
                        id: toOrFromModel
                        ListElement
                        {
                            modelName: "From"

                        }
                        ListElement
                        {
                            modelName: "To"

                        }
                    }
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    id: row

                    Tumbler {
                        id: hoursTumbler
                        model: 12
                        delegate: delegateComponent
                    }

                    Tumbler {
                        id: minutesTumbler
                        model: 60
                        delegate: delegateComponent
                    }

                    Tumbler {
                        id: amPmTumbler
                        model: ["AM", "PM"]
                        delegate: delegateComponent
                    }
                }

                Row
                {
                    anchors.horizontalCenter: parent.horizontalCenter
                    Repeater
                    {
                        id: weekdays
                        model: weekdaysModel
                        //                        model: 7

                        delegate: Rectangle
                        {
                            width: 50
                            height: 50

                            Label
                            {
                                text: day
                                anchors.centerIn: parent
                            }

                            border.width: 2
                            color: selected ? "tomato" : "white"

                            MouseArea
                            {
                                anchors.fill: parent
                                onClicked:
                                {
                                    if(selected)
                                    {
                                        selected = false
                                    }
                                    else
                                    {
                                        selected = true
                                    }
                                }
                            }


                        }

                    }

                    ListModel{
                        id: weekdaysModel
                        ListElement{

                            day: "Mon"
                            selected: false
                        }
                        ListElement{

                            day: "Tue"
                            selected: false
                        }
                        ListElement{

                            day: "Wed"
                            selected: false
                        }
                        ListElement{

                            day: "Thu"
                            selected: false
                        }
                        ListElement{

                            day: "Fri"
                            selected: false
                        }
                        ListElement{

                            day: "Sat"
                            selected: false
                        }
                        ListElement{

                            day: "Sun"
                            selected: false
                        }

                    }


                }


                Row
                {
                     anchors.horizontalCenter: parent.horizontalCenter
                    Label{
                        text: "Chuong trinh: "
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    ComboBox
                    {

                        model: 20


                    }
                }

                TextField
                {
                    id: descriptionTextField
                    placeholderText: "Ghi chu"
                    width: parent.width * 0.8
                    anchors.horizontalCenter: parent.horizontalCenter
                }


            }

            Component {
                id: delegateComponent

                Label {
                    text: timeSlotDialog.formatText(Tumbler.tumbler.count, modelData)
                    opacity: 1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: fontMetrics.font.pixelSize * 1.25
                }
            }
            FontMetrics {
                id: fontMetrics
            }
        }
    }

}
