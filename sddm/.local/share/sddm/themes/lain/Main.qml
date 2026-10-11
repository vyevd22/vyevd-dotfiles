import QtQuick 2.15
import QtQuick.Controls 2.15

Pane {
    id: root
    width: Screen.width
    height: Screen.height
    padding: 0

    // primaryScreen is set by SDDM per-view — true only on the primary monitor
    readonly property bool isLoginScreen: primaryScreen

    background: Rectangle { color: "#000000" }

    // Wallpaper — only on login screen
    Image {
        source: "background.jpeg"
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        opacity: isLoginScreen ? 0.6 : 0
        visible: isLoginScreen
    }

    // Dim overlay — only on login screen
    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: isLoginScreen ? 0.35 : 0
        visible: isLoginScreen
    }

    // ─────────────────────────────────────────────
    // LEFT SCREEN — LOGIN TERMINAL
    // ─────────────────────────────────────────────
    Item {
        visible: isLoginScreen
        anchors.fill: parent

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

                    // login: vyevd
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

                    // Terminal bottom line
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
    }

    // ─────────────────────────────────────────────
    // RIGHT SCREEN — BOOTLOG TERMINAL
    // ─────────────────────────────────────────────
    Item {
        visible: !isLoginScreen
        anchors.fill: parent

        // Terminal window filling most of the screen
        Rectangle {
            anchors.fill: parent
            anchors.margins: 30
            color: "#000000"
            border.color: Qt.rgba(106/255, 122/255, 138/255, 0.2)
            border.width: 1
            radius: 4

            // Title bar
            Rectangle {
                id: bootTitle
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 28
                color: Qt.rgba(8/255, 6/255, 12/255, 1)
                radius: 4

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
                    text: "vyevd@arch — dmesg"
                }
            }

            // Scrollable log output
            ListView {
                id: logView
                anchors.top: bootTitle.bottom
                anchors.topMargin: 6
                anchors.left: parent.left
                anchors.leftMargin: 12
                anchors.right: parent.right
                anchors.rightMargin: 12
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 12

                model: logModel
                spacing: 1

                delegate: Text {
                    font.family: "Mx437 IBM VGA 8x16"
                    font.pixelSize: 11
                    color: {
                        switch (model.type) {
                            case "ok":     return Qt.rgba(106/255, 122/255, 138/255, 0.85)
                            case "info":   return Qt.rgba(205/255, 211/255, 224/255, 0.6)
                            case "pink":   return "#D27389"
                            case "dim":    return Qt.rgba(106/255, 122/255, 138/255, 0.5)
                            case "warn":   return "#BB607B"
                            default:       return Qt.rgba(106/255, 122/255, 138/255, 0.7)
                        }
                    }
                    text: model.text
                    lineHeight: 1.15
                    width: parent.width
                    wrapMode: Text.NoWrap
                    clip: true
                }

                // Auto-scroll to latest line
                onCountChanged: {
                    positionViewAtEnd()
                }
            }
        }
    }

    // ─────────────────────────────────────────────
    // CRT SCANLINES — OVER EVERYTHING
    // ─────────────────────────────────────────────
    Image {
        source: "scanline.png"
        anchors.fill: parent
        fillMode: Image.Stretch
        opacity: 1.0
    }

    // ─────────────────────────────────────────────
    // BOOTLOG MESSENGER
    // ─────────────────────────────────────────────
    ListModel {
        id: logModel

        Component.onCompleted: {
            // Seed initial lines
            var seed = [
                { type: "dim",  text: "[    0.000000] Linux version 6.12.0-arch1-1 (linux@archlinux)" },
                { type: "dim",  text: "[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-linux-zen root=UUID=..." },
                { type: "dim",  text: "[    0.003847] CPU: Intel i5-13600K (6 P-cores/8 E-cores, 20 threads)" },
                { type: "dim",  text: "[    0.005211] CPU: Detected Intel CPU: family 0x6, model 0xb7" },
                { type: "dim",  text: "[    0.007214] GPU: AMD Radeon RX 7600 (navi33, LLVM 18.1.8)" },
                { type: "dim",  text: "[    0.008903] MEM: 31887MB available (8192MB swap)" },
                { type: "dim",  text: "[    0.012547] cryptd: Using crypto API (x86_64)" },
                { type: "info", text: "[    0.234109] systemd[1]: Starting Journal Service..." },
                { type: "ok",   text: "[  OK  ] Started Journal Service." },
                { type: "info", text: "[    0.354782] systemd[1]: Starting Load Kernel Modules..." },
                { type: "ok",   text: "[  OK  ] Started Load Kernel Modules." },
                { type: "info", text: "[    0.412098] systemd[1]: Starting Remount Root and Kernel..." },
                { type: "ok",   text: "[  OK  ] Started Remount Root and Kernel File System." },
                { type: "info", text: "[    0.547102] systemd[1]: Starting udev Coldplug all Devices..." },
                { type: "ok",   text: "[  OK  ] Started udev Coldplug all Devices." },
                { type: "info", text: "[    0.612344] systemd[1]: Starting Network Name Resolution..." },
                { type: "ok",   text: "[  OK  ] Started Network Name Resolution." },
                { type: "info", text: "[    0.689013] systemd[1]: Reached target Local File Systems." },
                { type: "ok",   text: "[  OK  ] Reached target Local File Systems." },
                { type: "info", text: "[    0.734521] systemd[1]: Starting Network Manager..." },
                { type: "ok",   text: "[  OK  ] Started Network Manager." },
                { type: "pink", text: "[  OK  ] Reached target Network." },
                { type: "info", text: "[    0.812987] systemd[1]: Starting Bluetooth Service..." },
                { type: "ok",   text: "[  OK  ] Started Bluetooth Service." },
                { type: "info", text: "[    0.874301] systemd[1]: Starting Audio Service..." },
                { type: "ok",   text: "[  OK  ] Started Audio Service." },
                { type: "ok",   text: "[  OK  ] Reached target Sound Card." },
                { type: "info", text: "[    0.941203] systemd[1]: Starting User Login Management..." },
                { type: "ok",   text: "[  OK  ] Started User Login Management." },
                { type: "pink", text: "[  OK  ] Reached target Multi-User System." }
            ]
            for (var i = 0; i < seed.length; i++) {
                logModel.append(seed[i])
            }
        }
    }

    // More bootlog lines for continuous streaming
    property var bootlogLines: [
        { type: "info", text: "         Starting Network Manager Script Dispatcher..." },
        { type: "ok",   text: "[  OK  ] Started Network Manager Script Dispatcher." },
        { type: "info", text: "         Starting D-Bus System Message Bus..." },
        { type: "ok",   text: "[  OK  ] Started D-Bus System Message Bus." },
        { type: "info", text: "         Starting Authorization Manager..." },
        { type: "ok",   text: "[  OK  ] Started Authorization Manager." },
        { type: "info", text: "[    1.203847] sddm[1]: Starting Display Manager..." },
        { type: "ok",   text: "[  OK  ] Started Display Manager." },
        { type: "pink", text: "[  OK  ] Reached target Graphical Interface." },
        { type: "dim",  text: "[    1.302198] amdgpu: PSP firmware loading..." },
        { type: "dim",  text: "[    1.308912] amdgpu: PSP runtime database initialized" },
        { type: "dim",  text: "[    1.401287] amdgpu: SMU firmware loading..." },
        { type: "dim",  text: "[    1.412877] amdgpu: SMU: I'm not who you think I am" },
        { type: "info", text: "[    1.502341] systemd[1]: Starting Power Management..." },
        { type: "ok",   text: "[  OK  ] Started Power Management." },
        { type: "info", text: "         Starting Thumbnailer Service..." },
        { type: "ok",   text: "[  OK  ] Started Thumbnailer Service." },
        { type: "info", text: "[    1.612809] systemd[1]: Starting Printer Service..." },
        { type: "ok",   text: "[  OK  ] Started Printer Service." },
        { type: "info", text: "[    1.701234] systemd[1]: Starting Disk Manager..." },
        { type: "ok",   text: "[  OK  ] Started Disk Manager." },
        { type: "info", text: "[    1.782090] systemd[1]: Starting Time & Date Service..." },
        { type: "ok",   text: "[  OK  ] Started Time & Date Service." },
        { type: "info", text: "         Starting Firewall Service..." },
        { type: "ok",   text: "[  OK  ] Started Firewall Service." },
        { type: "info", text: "[    1.871234] systemd[1]: Starting Login Service..." },
        { type: "ok",   text: "[  OK  ] Started Login Service." },
        { type: "info", text: "         Starting Kernel Module Management..." },
        { type: "ok",   text: "[  OK  ] Started Kernel Module Management." },
        { type: "dim",  text: "[    1.940122] sddm-greeter[1023]: Loading theme: lain" },
        { type: "dim",  text: "[    1.947802] sddm-greeter[1023]: Theme loaded (QML runtime: 0.47s)" },
        { type: "info", text: "[    1.991023] systemd[1]: Starting User Manager for UID 1000..." },
        { type: "ok",   text: "[  OK  ] Started User Manager for UID 1000." },
        { type: "info", text: "[    2.034218] systemd[1]: Starting GNOME Display Manager..." },
        { type: "warn", text: "[  !!  ] Failed to start GNOME Display Manager (not found)." },
        { type: "info", text: "         Starting Desktop Manager (Hyprland)..." },
        { type: "ok",   text: "[  OK  ] Started Desktop Manager (Hyprland)." },
        { type: "pink", text: "[  OK  ] Reached target Desktop Session." },
        { type: "dim",  text: "[    2.198043] sddm[1]: Authenticating user: vyevd" },
        { type: "dim",  text: "[    2.201237] sddm[1]: Session opened for user vyevd" },
        { type: "info", text: "[    2.247892] systemd[1]: Starting User Applications..." },
        { type: "ok",   text: "[  OK  ] Started User Applications." },
        { type: "info", text: "[    2.312908] systemd[1]: Starting PipeWire..." },
        { type: "ok",   text: "[  OK  ] Started PipeWire." },
        { type: "info", text: "[    2.371002] systemd[1]: Starting WirePlumber..." },
        { type: "ok",   text: "[  OK  ] Started WirePlumber." },
        { type: "info", text: "[    2.423891] systemd[1]: Starting portal service..." },
        { type: "ok",   text: "[  OK  ] Started portal service." },
        { type: "info", text: "[    2.472301] systemd[1]: Starting Status Bar..." },
        { type: "ok",   text: "[  OK  ] Started Status Bar (waybar)." },
        { type: "info", text: "[    2.518209] systemd[1]: Starting Notification Daemon..." },
        { type: "ok",   text: "[  OK  ] Started Notification Daemon (swaync)." },
        { type: "info", text: "[    2.568137] systemd[1]: Starting Clipboard Manager..." },
        { type: "ok",   text: "[  OK  ] Started Clipboard Manager (wl-clipboard)." },
        { type: "info", text: "[    2.618902] systemd[1]: Starting Audio Visualizer..." },
        { type: "ok",   text: "[  OK  ] Started Audio Visualizer (cava)." },
        { type: "info", text: "[    2.671003] systemd[1]: Starting Screen Recorder..." },
        { type: "ok",   text: "[  OK  ] Started Screen Recorder (gpu-screen-recorder)." },
        { type: "info", text: "[    2.732144] systemd[1]: Starting Encrypted Container..." },
        { type: "ok",   text: "[  OK  ] Started Encrypted Container (gocryptfs)." },
        { type: "pink", text: "[  OK  ] Reached target Graphical Session." },
        { type: "dim",  text: "[    2.812098] sddm[1]: Display server initialized" },
        { type: "dim",  text: "[    2.821003] sddm[1]: GDK: backend: wayland" },
        { type: "dim",  text: "[    2.834112] sddm[1]: Greeter: screen 0 connected (DP-3)" },
        { type: "dim",  text: "[    2.838907] sddm[1]: Greeter: screen 1 connected (HDMI-A-1)" },
        { type: "dim",  text: "[    2.847021] sddm[1]: Greeter: multi-monitor mode active" },
        { type: "info", text: "         Starting Periodic System Tasks..." },
        { type: "ok",   text: "[  OK  ] Started Periodic System Tasks." },
        { type: "info", text: "         Starting Temporary File Cleanup..." },
        { type: "ok",   text: "[  OK  ] Started Temporary File Cleanup." },
        { type: "info", text: "         Starting Package Cache Cleanup..." },
        { type: "ok",   text: "[  OK  ] Started Package Cache Cleanup." },
        { type: "info", text: "[    2.912134] systemd[1]: Reached target System Initialization." },
        { type: "ok",   text: "[  OK  ] Reached target System Initialization." },
        { type: "warn", text: "[  !!  ] Failed to start CUPS (printer not found)." },
        { type: "info", text: "[    2.967201] systemd[1]: Starting Network Time Sync..." },
        { type: "ok",   text: "[  OK  ] Started Network Time Sync." },
        { type: "info", text: "[    3.001238] systemd[1]: Starting Disk Encryption Check..." },
        { type: "ok",   text: "[  OK  ] Started Disk Encryption Check." },
        { type: "info", text: "[    3.042189] systemd[1]: Starting User Session..." },
        { type: "ok",   text: "[  OK  ] Started User Session." },
        { type: "info", text: "[    3.081023] systemd[1]: Starting System Resource Monitoring..." },
        { type: "ok",   text: "[  OK  ] Started System Resource Monitoring." },
        { type: "info", text: "[    3.118902] systemd[1]: Starting Browser Integration..." },
        { type: "ok",   text: "[  OK  ] Started Browser Integration." },
        { type: "info", text: "[    3.152209] systemd[1]: Starting Clipboard Persistence..." },
        { type: "ok",   text: "[  OK  ] Started Clipboard Persistence." },
        { type: "info", text: "[    3.189104] systemd[1]: Starting GPU Monitor..." },
        { type: "ok",   text: "[  OK  ] Started GPU Monitor." },
        { type: "info", text: "[    3.221893] systemd[1]: Starting Audio Routing..." },
        { type: "ok",   text: "[  OK  ] Started Audio Routing (WirePlumber)." },
        { type: "info", text: "[    3.258012] systemd[1]: Starting Session Management..." },
        { type: "ok",   text: "[  OK  ] Started Session Management." },
        { type: "pink", text: "[    3.291223] systemd[1]: Startup finished in 3.291s." },
        { type: "dim",  text: "[    3.302198] Linux arch 6.12.0-arch1-1 #1 SMP PREEMPT_DYNAMIC x86_64" },
        { type: "dim",  text: "[    3.309012] Uptime: 0 min | Load: 0.42 0.31 0.18" },
        { type: "dim",  text: "[    3.318774] Temperature: 42.0C (cpu) | 38.0C (gpu)" }
    ]

    property int logIndex: 0

    Timer {
        interval: 1800
        repeat: true
        running: !isLoginScreen
        onTriggered: {
            var line = bootlogLines[logIndex % bootlogLines.length]
            logModel.append(line)
            logIndex++
        }
    }

    // ─────────────────────────────────────────────
    // LOGIN LOGIC
    // ─────────────────────────────────────────────
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
    Component.onCompleted: { if (isLoginScreen) pw.forceActiveFocus() }
}
