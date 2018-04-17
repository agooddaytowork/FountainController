import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2

Item {

    id: root
    objectName: "ManualModePage"

    Frame {
        anchors.top: parent.top
        anchors.topMargin: 15
        anchors.bottomMargin: 15
        anchors.horizontalCenter: parent.horizontalCenter
        Column
        {
            anchors.fill: parent

            spacing: 15

            anchors.topMargin: 20
            anchors.bottomMargin: 20

            Row
            {
                anchors.horizontalCenter: parent.horizontalCenter
                Label
                {

                    text: "Program: "

                }
                Label
                {
                    id: currentProgramLabel
                    text: "0"

                }

            }

            Slider {
                id: slider
                value: 0
                from: 0
                to: 31
                stepSize: 1.0
                anchors.horizontalCenter: parent.horizontalCenter
                onValueChanged:
                {
                    currentProgramLabel.text = slider.value
                }
            }

            Row
            {
                anchors.horizontalCenter: parent.horizontalCenter
                Label
                {

                    text: "Speed: "

                }
                Label
                {
                    id: currentSpeedLabel
                    text: "0"

                }

            }

            Dial
            {
                id: dial
                value: 0
                from: 0
                to: 255
                stepSize: 1.0
                anchors.horizontalCenter: parent.horizontalCenter

                onValueChanged:
                {
                    currentSpeedLabel.text = Math.round(dial.value)
                }

            }
            Button
            {
                id: updateButton
                anchors.horizontalCenter: parent.horizontalCenter
                text: "UPDATE"
                anchors.bottomMargin: 15

                onPressed: {

                    theTcpClient.sendSpeed(fountainProgramSerializer.serializeSpeed(slider.value,Math.round(dial.value)))
                    slider.value = 0
                    dial.value = 0

                }
            }

        }
    }

}
