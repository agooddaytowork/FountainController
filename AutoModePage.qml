import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls 2.2
import QtQml 2.2


Item {
    id: root
    objectName: "AutoModePage"

    property bool openTimeSlotDialog: false
    property ListModel timeSLotModelUnsorted: ListModel {}
    property ListModel fountainProgramModel : ListModel {}
    property int currentUnsortedIndex: 0
    property bool autoPlayFountain: false



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
                                         "program": "default",
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

    function updateAppDataToFile()
    {
        appIoManager.write("appData",root.serializeListModel(timeSLotModelUnsorted))
    }


    Component.onCompleted:
    {

        console.log("LOADDDDD")
        if(appIoManager.getNameListCount() === 0)
        {
            generateDefaultTimeSLot()
            sortTimeSlotModel()
            updateAppDataToFile()

        }
        else
        {
            timeSLotModelUnsorted.clear()
            timeSLotModelUnsorted.append(JSON.parse(appIoManager.read("appData")))
        }

        fountainProgramModel.clear()
        fountainProgramModel.append(JSON.parse(dataIoManager.read("Data")))
    }

    GridView{
        id: autoModeGridView
        anchors.fill: parent
        cellHeight: 300
        cellWidth: parent.width/2

        model: timeSLotModelUnsorted

        delegate: SwipeDelegate{
            id: timeSlotRec
            width: autoModeGridView.cellWidth
            height: autoModeGridView.cellHeight
            //            border.width: 1
            //            border.color: "black"



            swipe.right:Rectangle{

                height: parent.height * 0.5
                anchors.right: parent.right
                color: "black"
                width: parent.width *0.4
                anchors.bottom: parent.bottom

                Column{

                    anchors.fill: parent
                    Label {
                        id: deleteLabel
                        text: qsTr("Delete")
                        color: "white"
                        verticalAlignment: Label.AlignVCenter
                        padding: 12
                        width: parent.width
                        height: parent.height/2



                        background: Rectangle {
                            color: deleteLabelMouseArea.pressed ? Qt.darker("tomato", 1.1) : "tomato"
                        }

                        MouseArea
                        {
                            id: deleteLabelMouseArea
                            anchors.fill: parent
                            onPressed:
                            {
                                timeSLotModelUnsorted.remove(index)
                                root.sortTimeSlotModel()
                                root.updateAppDataToFile()
                            }
                        }

                    }

                    Label {
                        id: editLabel
                        text: qsTr("Edit")
                        color: "white"
                        verticalAlignment: Label.AlignVCenter
                        padding: 12
                        width: parent.width
                        height: parent.height/2


                        background: Rectangle {
                            color: editLabelMouseArea.pressed ? Qt.darker("tomato", 1.1) : "tomato"
                        }

                        MouseArea
                        {
                            id: editLabelMouseArea
                            anchors.fill: parent
                            onPressed:
                            {
                                currentUnsortedIndex = index
                                autoModeGridView.currentIndex = currentUnsortedIndex
                                timeSlotDialog.repeatsIndex = timeSLotModelUnsorted.get(currentUnsortedIndex).repeat
                                timeSlotDialog.isEditMode = true
                                timeSlotDialog.open()
                            }
                        }

                    }
                }

            }


            Column{
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 10
                spacing: 10
                Label
                {
                    id: fromHourLabel
                    text: fromHour+"."+fromMinute+" "+FromHourdayNightPeriod+"-"+(toHour)+"."+toMinute+ " "+ ToHourdayNightPeriod
                    font.pixelSize: 30
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
                            width: 35
                            height: 35

                            Label
                            {
                                text: day
                                anchors.centerIn: parent
                            }

                            border.width: 2
                            color:{

                                if(repeat & theBit)

                                {
                                    "tomato"

                                }
                                else
                                {
                                    "white"

                                }

                            }


                        }

                    }




                }


                Label
                {
                    id: timeSlotDescLabel
                    text: description
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

                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 20
                anchors.leftMargin: 20

                z:2
                checked: timeSlotEnable

                onCheckedChanged: {
                    timeSLotModelUnsorted.setProperty(index,"timeSlotEnable", checked)
                    updateAppDataToFile()
                }

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

        property int repeatsIndex: 0
        property bool isEditMode: false




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

            console.log("edit mode: " + isEditMode)
            if (!isEditMode) repeatsIndex = 0
            console.log("should LOAD FREEARSAD")

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
                                timeSLotModelUnsorted.setProperty(currentUnsortedIndex,"ToHourdayNightPeriod", currentIndex == 0? "AM":"PM")
                            }
                        }
                    }
                }

                Row
                {
                    anchors.horizontalCenter: parent.horizontalCenter
                    Repeater
                    {
                        id: weekdays1
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
                            color:{

                                if(timeSlotDialog.repeatsIndex & theBit)

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

                                    if(timeSlotDialog.repeatsIndex & theBit)

                                    {
                                        selected = true

                                    }
                                    else
                                    {
                                        selected = false

                                    }


                                    if(selected)
                                    {
                                        selected = false
                                        timeSlotDialog.repeatsIndex = timeSlotDialog.repeatsIndex & ~(theBit)
                                        console.log(timeSlotDialog.repeatsIndex)
                                    }
                                    else
                                    {
                                        selected = true
                                        timeSlotDialog.repeatsIndex = timeSlotDialog.repeatsIndex | theBit

                                        console.log(timeSlotDialog.repeatsIndex)
                                    }
                                }
                            }


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

                        id: programCombobox
                        model: fountainProgramModel
                        textRole: "programName"
                        currentIndex: {

                            for (var i = 0; i < fountainProgramModel.count; i++)
                            {
                                if(timeSLotModelUnsorted.get(currentUnsortedIndex).program === fountainProgramModel.get(i).programName)
                                {
                                    i
                                    return
                                }

                            }

                            0
                        }
                    }
                }

                TextField
                {
                    id: descriptionTextField
                    placeholderText: "Ghi chu"
                    width: parent.width * 0.8
                    anchors.horizontalCenter: parent.horizontalCenter

                    onTextChanged:
                    {
                        timeSLotModelUnsorted.setProperty(currentUnsortedIndex,"description", descriptionTextField.text)
                    }
                }

                Row
                {

                    spacing: 100
                    anchors.horizontalCenter: parent.horizontalCenter
                    Button
                    {
                        text: "Cancel"
                        onClicked:
                        {
                            if(timeSlotDialog.isEditMode)
                            {

                                timeSlotDialog.isEditMode = false

                            }
                            else
                            {

                                timeSLotModelUnsorted.remove(currentUnsortedIndex)
                                currentUnsortedIndex = currentUnsortedIndex -1
                                root.sortTimeSlotModel()
                                root.updateAppDataToFile()
                            }

                            timeSlotDialog.close()

                            autoModeGridView.currentItem.swipe.close()

                        }


                    }

                    Button
                    {
                        text: {

                            if(timeSlotDialog.isEditMode)
                            {
                                "Edit"
                            }
                            else
                            {
                                "Add new"
                            }
                        }

                        onClicked: {

                            if(timeSlotDialog.isEditMode)
                            {

                                timeSlotDialog.isEditMode = false

                            }
                            else

                            {

                                root.sortTimeSlotModel()

                            }
                            timeSLotModelUnsorted.setProperty(currentUnsortedIndex,"repeat", timeSlotDialog.repeatsIndex)
                            timeSLotModelUnsorted.setProperty(currentUnsortedIndex,"program", programCombobox.currentText)
                            timeSlotDialog.close()
                            root.updateAppDataToFile()


                            autoModeGridView.currentItem.swipe.close()

                            autoPlayTimer.toHour = false
                            generateAutoPlayTimerInterval()
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

    ListModel{
        id: weekdaysModel
        ListElement{

            day: "Mon"
            theBit: 1
            theIndex: 1
            selected: false
        }
        ListElement{

            day: "Tue"
            theBit: 2
            theIndex: 2
            selected: false
        }
        ListElement{

            day: "Wed"
            theBit: 4
            theIndex: 3
            selected: false
        }
        ListElement{

            day: "Thu"
            theBit: 8
            theIndex: 4
            selected: false
        }
        ListElement{

            day: "Fri"
            theBit: 16
            theIndex: 5
            selected: false
        }
        ListElement{

            day: "Sat"
            theBit: 32
            theIndex: 6
            selected: false
        }
        ListElement{

            day: "Sun"
            theBit: 64
            theIndex: 0
            selected: false
        }

    }

    Timer
    {
        id: autoPlayTimer
        interval: 5000
        repeat: false
        running: false
        property bool toHour: false
        property int currentIndexofPlayingTimeSlot: 0
        onTriggered:
        {
           // VERY IMPORTANT SLOTTTTT

            if(timeSLotModelUnsorted.get(autoPlayTimer.currentIndexofPlayingTimeSlot).timeSlotEnable)
            {
                console.log("PROGRAM TO BE PLAYED: " + timeSLotModelUnsorted.get(autoPlayTimer.currentIndexofPlayingTimeSlot).program)

                var serialData = fountainProgramSerializer.serializedProgram(timeSLotModelUnsorted.get(autoPlayTimer.currentIndexofPlayingTimeSlot).program)

                console.log(serialData)

                if(theTcpClient.isSVOnline)
                {
                    theTcpClient.sendProgram(timeSLotModelUnsorted.get(autoPlayTimer.currentIndexofPlayingTimeSlot).program,serialData)
                }
            }

            generateAutoPlayTimerInterval()
        }
    }

    function toMsecsSinceEpoch(date) {
        var msecs = date.getTime();
        return msecs;
    }

    function nextDayWithHour(weekday, hour, minute)
    {
        var now = new Date();
        now.setDate(now.getDate() + (weekday+(7-now.getDay())) % 7)
        now.setHours(hour,minute,0,0)
        console.log(now)
        return toMsecsSinceEpoch(now);
    }

    function getTheBitFromTodayIndex(index)
    {
        var theBit;
        switch(index)
        {
        case 0:
            theBit = 64
            break;
        case 1:
            theBit = 1
            break;
        case 2:
            theBit = 2
            break;
        case 3:
            theBit = 4
            break;
        case 4:
            theBit = 8
            break;
        case 5:
            theBit = 16
            break;
        case 6:
            theBit = 32
            break;

        }

        return theBit
    }

    function convertAMPMHourTo24HourFormat(hour, dayPeriod)
    {
        if(dayPeriod === "AM")
        {
            return hour
        }
        else
        {
            return hour + 12
        }
    }

    function generateAutoPlayTimerInterval()
    {
        // stop the timer

        autoPlayTimer.stop()
        if(autoPlayFountain)
        {
            if(!autoPlayTimer.toHour)
            {
                //get today day of the weekdays
                var theDay =  new Date().getDay()

                console.log("the Day: " + theDay)

                // get the Index of items in the TimeUnsorted model that has the timeslot to be played today

                var theIndexArray = []
                for(var i = 0 ; i < timeSLotModelUnsorted.count; i ++)
                {
                    if (timeSLotModelUnsorted.get(i).repeat & getTheBitFromTodayIndex(theDay))
                    {
                        console.log("DZOO")
                        theIndexArray.push(i)
                    }
                }
                    var nothingTobePlayedToday = 1
                if(theIndexArray.length != 0)
                {
                    // compare the fromHour of all the items in theIndexArray, get the closet fromHour to the current time

                    var theTimeTobePlayed = 0;

                    console.log("the Index Array lenght: "+ theIndexArray.length)
                    for (i = 0; i < theIndexArray.length; i++)
                    {

                        var timeTobeCompared = nextDayWithHour(theDay, convertAMPMHourTo24HourFormat(timeSLotModelUnsorted.get(theIndexArray[i]).fromHour, timeSLotModelUnsorted.get(theIndexArray[i]).FromHourdayNightPeriod),timeSLotModelUnsorted.get(theIndexArray[i]).fromMinute)

                        console.log("the Time To Be compared: " + timeTobeCompared)


                        if(timeTobeCompared > toMsecsSinceEpoch(new Date()))
                        {
                            if(theTimeTobePlayed === 0 )
                            {
                                theTimeTobePlayed = timeTobeCompared
                                autoPlayTimer.currentIndexofPlayingTimeSlot = theIndexArray[i]
                            }
                            else
                            {
                                if( timeTobeCompared < theTimeTobePlayed)
                                {
                                    theTimeTobePlayed = timeTobeCompared
                                    autoPlayTimer.currentIndexofPlayingTimeSlot = theIndexArray[i]
                                }
                            }

                            nothingTobePlayedToday = 0

                            autoPlayTimer.toHour = true

                            console.log("Current INdex: " + autoPlayTimer.currentIndexofPlayingTimeSlot)
                        }

                    }

                }

                if(nothingTobePlayedToday === 1)
                {
                    var intervalToNextDay = nextDayWithHour(theDay+1, 0,1) - toMsecsSinceEpoch(new Date())

                    console.log("interValToNext Day: " + intervalToNextDay)
                    autoPlayTimer.interval = intervalToNextDay
                    autoPlayTimer.start()
//                    autoPlayTimer.start()
                    return
                }
                var theInterVal = (theTimeTobePlayed - toMsecsSinceEpoch(new Date()))

                console.log("the Interval: " + theInterVal)
                autoPlayTimer.interval = theInterVal
                autoPlayTimer.start()
                //        return theInterVal
            }
            else
            {
                autoPlayTimer.toHour = false
                autoPlayTimer.interval = nextDayWithHour(new Date().getDay(),convertAMPMHourTo24HourFormat(timeSLotModelUnsorted.get(autoPlayTimer.currentIndexofPlayingTimeSlot).toHour),timeSLotModelUnsorted.get(autoPlayTimer.currentIndexofPlayingTimeSlot).toMinute) - toMsecsSinceEpoch(new Date())
                console.log("toInterval : " + autoPlayTimer.interval)

                autoPlayTimer.start()
            }
        }

    }

    onAutoPlayFountainChanged:
    {
        autoPlayTimer.toHour = false

    }


}
