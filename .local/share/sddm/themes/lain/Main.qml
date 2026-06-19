import QtQuick 2.15
import QtQuick.Controls 2.15

Pane {
    id: root
    width: 1920
    height: 1080
    padding: 0

    background: Rectangle { color: "#000000" }

    // Wallpaper
    Image {
        source: "background.jpeg"
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        opacity: 0.5
    }

    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: 0.5
    }

    // Terminal window
    Rectangle {
        id: term
        width: 520
        height: 340
        anchors.centerIn: parent
        color: "#000000"
        border.color: Qt.rgba(106/255, 122/255, 138/255, 0.3)
        border.width: 1
        radius: 6
        opacity: 0.65

        // Title bar
        Rectangle {
            width: parent.width
            height: 26
            color: Qt.rgba(8/255, 6/255, 12/255, 1)
            radius: 6

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.topMargin: 6
                height: 20
                color: Qt.rgba(8/255, 6/255, 12/255, 1)
            }

            // Window dots
            Row {
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                spacing: 5
                Rectangle { width: 7; height: 7; radius: 4; color: "#6a7a8a"; opacity: 0.3 }
                Rectangle { width: 7; height: 7; radius: 4; color: "#6a7a8a"; opacity: 0.3 }
                Rectangle { width: 7; height: 7; radius: 4; color: "#D27389"; opacity: 0.5 }
            }

            Text {
                anchors.centerIn: parent
                font.family: "Mx437 IBM VGA 8x16"
                font.pixelSize: 11
                color: Qt.rgba(106/255, 122/255, 138/255, 0.4)
                text: "vyevd@arch — kitty"
            }
        }

        // Terminal content
        Item {
            anchors.top: parent.top
            anchors.topMargin: 38
            anchors.left: parent.left
            anchors.leftMargin: 24
            anchors.right: parent.right
            anchors.rightMargin: 24
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 18

            Column {
                anchors.fill: parent
                spacing: 2

                // Boot messages
                Text { font.family: "Mx437 IBM VGA 8x16"; font.pixelSize: 11; color: Qt.rgba(106/255, 122/255, 138/255, 0.35); text: "[    0.000000] Linux version 6.x.x-zen" }
                Text { font.family: "Mx437 IBM VGA 8x16"; font.pixelSize: 11; color: Qt.rgba(106/255, 122/255, 138/255, 0.35); text: "[    0.547192] sddm[1]: Login service initialized" }
                Text { font.family: "Mx437 IBM VGA 8x16"; font.pixelSize: 11; color: Qt.rgba(106/255, 122/255, 138/255, 0.35); text: "[    1.203847] sddm[1]: Reached target Login" }

                // Spacer
                Item { height: 10; width: 1 }

                // Clock
                Text {
                    id: clock
                    font.family: "Mx437 IBM VGA 8x16"
                    font.pixelSize: 36
                    color: "#D27389"
                    text: new Date().toLocaleTimeString("en_US", "HH:mm")
                    Timer {
                        interval: 1000; repeat: true; running: true
                        onTriggered: clock.text = new Date().toLocaleTimeString("en_US", "HH:mm")
                    }
                }

                // Date
                Text {
                    font.family: "Mx437 IBM VGA 8x16"
                    font.pixelSize: 11
                    color: Qt.rgba(106/255, 122/255, 138/255, 0.4)
                    text: new Date().toLocaleDateString("en_US", "dddd, MMMM d yyyy")
                }

                // Spacer
                Item { height: 14; width: 1 }

                // login: vyevd (same line!)
                Row {
                    spacing: 0
                    Text {
                        font.family: "Mx437 IBM VGA 8x16"
                        font.pixelSize: 15
                        color: Qt.rgba(106/255, 122/255, 138/255, 0.7)
                        text: "arch login: "
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Text {
                        font.family: "Mx437 IBM VGA 8x16"
                        font.pixelSize: 15
                        color: "#cdd3e0"
                        text: sddm.lastUser || "vyevd"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                // Password: line
                Row {
                    spacing: 0
                    Text {
                        font.family: "Mx437 IBM VGA 8x16"
                        font.pixelSize: 15
                        color: Qt.rgba(106/255, 122/255, 138/255, 0.7)
                        text: "Password: "
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    TextField {
                        id: pw
                        font.family: "Mx437 IBM VGA 8x16"
                        font.pixelSize: 15
                        color: "#cdd3e0"
                        echoMode: show.checked ? TextInput.Normal : TextInput.Password
                        passwordCharacter: "*"
                        passwordMaskDelay: undefined
                        selectByMouse: true
                        focus: true

                        background: Rectangle {
                            color: "transparent"
                            border.color: "transparent"
                            implicitWidth: 220
                            implicitHeight: pw.font.pixelSize * 1.6
                        }

                        cursorDelegate: Rectangle {
                            width: 8
                            color: "#D27389"
                            opacity: 0.8
                            Timer {
                                interval: 600
                                repeat: true
                                running: pw.activeFocus
                                onTriggered: parent.visible = !parent.visible
                            }
                        }

                        onAccepted: doLogin()
                    }
                }

                // Spacer
                Item { height: 4; width: 1 }

                // [login]
                Row {
                    spacing: 12
                    Button {
                        font.family: "Mx437 IBM VGA 8x16"
                        font.pixelSize: 12
                        text: "[login]"
                        flat: true
                        background: Rectangle { color: "transparent" }
                        contentItem: Text { text: parent.text; font.family: parent.font.family; font.pixelSize: parent.font.pixelSize; color: "#D27389" }
                        onClicked: doLogin()
                        Keys.onReturnPressed: doLogin()
                        Keys.onEnterPressed: doLogin()
                    }

                    // Show/hide password
                    Button {
                        id: show
                        checkable: true
                        font.family: "Mx437 IBM VGA 8x16"
                        font.pixelSize: 11
                        text: show.checked ? "[hide]" : "[show]"
                        flat: true
                        background: Rectangle { color: "transparent" }
                        contentItem: Text { text: parent.text; font.family: parent.font.family; font.pixelSize: parent.font.pixelSize; color: "#6a7a8a" }
                    }
                }

                // Spacer
                Item { height: 6; width: 1 }

                // Error
                Text {
                    id: err
                    font.family: "Mx437 IBM VGA 8x16"
                    font.pixelSize: 11
                    color: "#BB607B"
                    text: "Login failed"
                    visible: false
                }

                // Terminal bottom line (fills space + adds atmosphere)
                Item { height: 6; width: 1 }
                Text {
                    font.family: "Mx437 IBM VGA 8x16"
                    font.pixelSize: 10
                    color: Qt.rgba(106/255, 122/255, 138/255, 0.25)
                    text: "Linux " + sddm.hostName + " | " + Qt.platform.os + " | uptime: " + new Date().toLocaleTimeString("en_US", "HH:mm")
                    visible: false
                }
            }
        }
    }

    // Full-screen CRT scanlines (over everything)
    Image {
        source: "scanline.png"
        anchors.fill: parent
        fillMode: Image.Stretch
        opacity: 1.0
    }

    function doLogin() {
        sddm.login(sddm.lastUser || "vyevd", pw.text, 0)
    }

    Connections {
        target: sddm
        function onLoginSucceeded() { err.visible = false }
        function onLoginFailed() {
            err.visible = true
            pw.text = ""
            pw.focus = true
            fail.running = true
        }
    }

    Timer { id: fail; interval: 3000; onTriggered: err.visible = false }
    Component.onCompleted: { pw.forceActiveFocus() }
}
