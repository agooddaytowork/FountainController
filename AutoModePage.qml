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


    function serializeListModel(theList)
    {
        var dataModel=[]

        for(var i = 0; i < theList.count; i++)
        {


            dataModel.push(theList.get(i))
        }

        return JSON.stringify(dataModel)
    }

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
                                         "FromHourdayNightPeriod": "AM",
                                         "fromMinute" : 5,
                                         "toHour": 9,
                                         "toMinute": 20,
                                         "ToHourdayNightPeriod": "AM",
                                         "timeSlotEnable": false,
                                         "repeat": 0,
                                         "program": 1,
                                         "description": "default program"
                                     })

        currentUnsortedIndex = (timeSLotModelUnsorted.count - 1)

    }


    function sortTimeSlotModel()
    {

        if(timeSLotModelUnsorted.count === 1 ) return

        var sorted = false

        while(!sorted)
        {
            var count = 0
            for (var i =0; i < timeSLotModelUnsorted.count -1; i++)
            {
                if(timeSLotModelUnsorted.get(i).fromHour > timeSLotModelUnsorted.get(i+1).fromHour)
                {
                    timeSLotModelUnsorted.move(i,i + 1, 1)
                    count ++;
                }
            }

            if(count == 0)
            {
                sorted = true
            }
            else
            {
                count = 0
            }
        }

    }


    Component.onCompleted:
    {

        console.log("LOADDDDD")
        if(appIoManager.getNameListCount() === 0)
        {
            generateDefaultTimeSLot()
            appIoManager.write("appData",root.serializeListModel(timeSLotModelUnsorted))
                 sortTimeSlotModel()

        }
        else
        {
            timeSLotModelUnsorted.clear()

            timeSLotModelUnsorted.append(JSON.parse(appIoManager.read("appData")))
        }
    }

    GridView{
        id: autoModeGridView
        anchors.fill: parent
        cellHeight: parent.height/2
        cellWidth: parent.width/4

        model: timeSLotModelUnsorted

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
                    text: fromHour+"."+fromMinute+" "+FromHourdayNightPeriod+"-"+(toHour+1)+"."+toMinute+ " "+ ToHourdayNightPeriod
                    font.pixelSize: 30
                }

                Label
                {
                    id: timeSlotDescLabel
                    text: description
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
                    text: "Chương trình: " + program
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
                checked: timeSlotEnable

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
        closePolicy: Popup.NoAutoClose || Popup.CloseOnEscape
        modal: true


        onAboutToShow:
        {
            toOrFromSelector.fromIsSelected = true
            hoursTumbler.currentIndex = timeSLotModelUnsorted.get(currentUnsortedIndex).fromHour -1
            minutesTumbler.currentIndex = timeSLotModelUnsorted.get(currentUnsortedIndex).fromMinute
            if(timeSLotModelUnsorted.get(currentUnsortedIndex).FromHourdayNightPeriod === "AM")
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
                spacing: 10
                anchors.topMargin: 10

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

                                        hoursTumbler.currentIndex = timeSLotModelUnsorted.get(currentUnsortedIndex).fromHour -1
                                        minutesTumbler.currentIndex = timeSLotModelUnsorted.get(currentUnsortedIndex).fromMinute
                                        if(timeSLotModelUnsorted.get(currentUnsortedIndex).FromHourdayNightPeriod === "AM")
                                        {
                                            amPmTumbler.currentIndex = 0
                                        }
                                        else
                                        {
                                            amPmTumbler.currentIndex = 1
                                        }
                                    }
                                    else
                                    {
                                        toOrFromSelector.fromIsSelected = false

                                        hoursTumbler.currentIndex = timeSLotModelUnsorted.get(currentUnsortedIndex).toHour -1
                                        minutesTumbler.currentIndex = timeSLotModelUnsorted.get(currentUnsortedIndex).toMinute
                                        if(timeSLotModelUnsorted.get(currentUnsortedIndex).ToHourdayNightPeriod === "AM")
                                        {
                                            amPmTumbler.currentIndex = 0
                                        }
                                        else
                                        {
                                            amPmTumbler.currentIndex = 1
                                        }
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

                        onCurrentIndexChanged: {
                            if(toOrFromSelector.fromIsSelected)
                            {
                                timeSLotModelUnsorted.setProperty(currentUnsortedIndex,"fromHour", currentIndex +1)
                            }
                            else
                            {
 timeSLotModelUnsorted.setProperty(currentUnsortedIndex,"toHour", currentIndex +1)
                            }


                        }
                    }

                    Tumbler {
                        id: minutesTumbler
                        model: 60
                        delegate: delegateComponent
                        onCurrentIndexChanged: {
                            if(toOrFromSelector.fromIsSelected)
                            {
                                timeSLotModelUnsorted.setProperty(currentUnsortedIndex,"fromMinute", currentIndex)
                            }
                            else
                            {
 timeSLotModelUnsorted.setProperty(currentUnsortedIndex,"toMinute", currentIndex)
                            }
                        }
                    }

                    Tumbler {
                        id: amPmTumbler
                        model: ["AM", "PM"]
                        delegate: delegateComponent
                        onCurrentIndexChanged: {
                            if(toOrFromSelector.fromIsSelected)
                            {
                                timeSLotModelUnsorted.setProperty(currentUnsortedIndex,"FromHourdayNightPeriod", currentIndex == 0? "AM":"PM")
                            }
                            else
                            {
 timeSLotModelUnsorted.setProperty(currentUnsortedIndex,"ToHourdayNightPeriod", currentIndex)
                            }
                        }
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

                Row
                {

                    spacing: 100
                    anchors.horizontalCenter: parent.horizontalCenter
                    Button
                    {
                        text: "Cancel"


                    }

                    Button
                    {
                        text: "Add new"


                        onClicked: {
                            timeSlotDialog.close()
                            root.sortTimeSlotModel()
                        }
                    }
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
