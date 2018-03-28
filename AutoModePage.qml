import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls 2.2


Item {
    id: root
    objectName: "AutoModePage"

    property bool openTimeSlotDialog: false


    onOpenTimeSlotDialogChanged: {
        if(openTimeSlotDialog)
        {
            timeSlotDialog.open()
        }
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



                Switch
                {
                    id: fromToSwitch
                    anchors.horizontalCenter: parent.horizontalCenter

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
