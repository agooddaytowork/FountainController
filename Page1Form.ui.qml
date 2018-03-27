import QtQuick 2.9
import QtQuick.Controls 2.2

Page {
    id: page
    width: 1250
    height: 700
    property alias programListRecWidth: programListRec.width
    property alias fountainGroupRec1Width: fountainGroupRec1.width

    title: qsTr("Page 1")

    Rectangle {
        id: programListRec
        width: 419
        color: "#bdc5cb"
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
    }

    Rectangle {
        id: fountainGroupRec
        width: parent.width / 3
        color: "#9eadb8"
        anchors.left: programListRec.right
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
    }

    Rectangle {
        id: fountainGroupRec1
        width: parent.width / 3
        color: "#769ebc"
        anchors.left: fountainGroupRec.right
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
    }
}
