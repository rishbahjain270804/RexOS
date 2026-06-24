// RexOS — SDDM login theme. A centered card over the RexOS wallpaper.
import QtQuick 2.15
import QtQuick.Controls 2.15
import SddmComponents 2.0

Rectangle {
    id: root
    width: 1920; height: 1080
    color: "#14182c"

    // wallpaper
    Image {
        anchors.fill: parent
        source: "rexos-wall.png"
        fillMode: Image.PreserveAspectCrop
    }

    // login card
    Rectangle {
        anchors.centerIn: parent
        width: 420; height: 360
        radius: 18
        color: "#161a26"
        opacity: 0.96
        border.color: "#14b8c4"
        border.width: 1

        Column {
            anchors.centerIn: parent
            spacing: 18
            width: parent.width - 80

            // wordmark
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "RexOS"
                color: "#14b8c4"
                font.pixelSize: 34
                font.bold: true
                font.letterSpacing: 4
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "the from-scratch operating system"
                color: "#6b7280"
                font.pixelSize: 12
            }

            Rectangle { width: parent.width; height: 1; color: "#2a3148" }

            // username
            TextField {
                id: userField
                width: parent.width
                placeholderText: "username"
                text: userModel.lastUser
                color: "#e8eaf0"
                background: Rectangle { radius: 10; color: "#1e2436" }
                padding: 12
            }

            // password
            TextField {
                id: passField
                width: parent.width
                placeholderText: "password"
                echoMode: TextInput.Password
                color: "#e8eaf0"
                background: Rectangle { radius: 10; color: "#1e2436" }
                padding: 12
                onAccepted: sddm.login(userField.text, passField.text, sessionModel.lastIndex)
            }

            // login button
            Button {
                width: parent.width
                text: "Sign in"
                onClicked: sddm.login(userField.text, passField.text, sessionModel.lastIndex)
                background: Rectangle {
                    radius: 10
                    color: parent.hovered ? "#3ad4de" : "#14b8c4"
                }
                contentItem: Text {
                    text: parent.text
                    color: "#0f1117"
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
    }

    // clock bottom-right
    Text {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 28
        color: "#b8bdcc"
        font.pixelSize: 16
        Timer { interval: 1000; running: true; repeat: true; onTriggered: parent.text = Qt.formatDateTime(new Date(), "ddd dd MMM  hh:mm") }
        text: Qt.formatDateTime(new Date(), "ddd dd MMM  hh:mm")
    }

    Connections {
        target: sddm
        function onLoginFailed() { passField.text = ""; passField.placeholderText = "wrong password" }
    }
}
