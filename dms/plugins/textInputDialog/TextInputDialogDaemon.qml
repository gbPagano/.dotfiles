import QtQuick
import Quickshell
import Quickshell.Io
import qs.Common
import qs.Widgets

Item {
    id: root

    property var pluginService: null
    property string pluginId: ""

    property string dialogTitle: "Input"
    property string headerText: ""
    property string placeholderText: "Enter text..."
    property string actionButtonText: "OK"
    property string cancelButtonText: "Cancel"
    property string submitCommand: ""
    property bool copyToClipboard: true
    property string lastResult: ""
    property string resultState: "idle"
    property bool isPassword: false

    Component.onCompleted: {
        loadSettings();
    }

    onPluginServiceChanged: loadSettings()
    onPluginIdChanged: loadSettings()

    function loadSettings() {
        if (!pluginService || !pluginId) return;
        dialogTitle = pluginService.loadPluginData(pluginId, "dialogTitle", "Input") || "Input";
        headerText = pluginService.loadPluginData(pluginId, "headerText", "") || "";
        placeholderText = pluginService.loadPluginData(pluginId, "placeholderText", "Enter text...") || "Enter text...";
        actionButtonText = pluginService.loadPluginData(pluginId, "actionButtonText", "OK") || "OK";
        cancelButtonText = pluginService.loadPluginData(pluginId, "cancelButtonText", "Cancel") || "Cancel";
        submitCommand = pluginService.loadPluginData(pluginId, "submitCommand", "") || "";
        copyToClipboard = pluginService.loadPluginData(pluginId, "copyToClipboard", true);
    }

    Connections {
        target: pluginService
        enabled: pluginService !== null
        function onPluginDataChanged(changedPluginId) {
            if (changedPluginId === pluginId) {
                loadSettings();
            }
        }
    }

    function applyArgs(title, header, placeholder, mode) {
        if (title !== undefined && title !== "") dialogTitle = title;
        if (header !== undefined) headerText = header;
        if (placeholder !== undefined && placeholder !== "") placeholderText = placeholder;
        isPassword = (mode === "password");
        resultState = "pending";
        inputWindow.show("");
    }

    FloatingWindow {
        id: inputWindow

        property bool disablePopupTransparency: true
        readonly property int inputFieldHeight: Theme.fontSizeMedium + Theme.spacingL * 2

        objectName: "textInputDialog"
        title: dialogTitle
        minimumSize: Qt.size(400, 160)
        maximumSize: Qt.size(400, 160)
        color: Theme.surfaceContainer
        visible: false

        function show(defaultValue) {
            inputField.text = defaultValue || "";
            visible = true;
            Qt.callLater(() => inputField.forceActiveFocus());
        }

        function hide() {
            visible = false;
        }

        onVisibleChanged: {
            if (visible) {
                Qt.callLater(() => inputField.forceActiveFocus());
                return;
            }
            inputField.text = "";
            loadSettings();
        }

        FocusScope {
            id: contentFocusScope

            anchors.fill: parent
            focus: true

            Keys.onEscapePressed: event => {
                lastResult = "";
                resultState = "cancelled";
                inputWindow.hide();
                event.accepted = true;
            }

            Column {
                id: contentCol
                anchors.centerIn: parent
                width: parent.width - Theme.spacingL * 2
                spacing: Theme.spacingM

                Item {
                    width: contentCol.width
                    height: Math.max(headerLabel.height, buttonRow.height)

                    MouseArea {
                        anchors.left: parent.left
                        anchors.right: buttonRow.left
                        anchors.rightMargin: Theme.spacingM
                        height: parent.height
                        onPressed: windowControls.tryStartMove()
                        onDoubleClicked: windowControls.tryToggleMaximize()
                    }

                    StyledText {
                        id: headerLabel
                        text: root.headerText || dialogTitle
                        font.pixelSize: Theme.fontSizeMedium
                        color: Theme.surfaceTextMedium
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width - buttonRow.width - Theme.spacingM
                        elide: Text.ElideRight
                    }

                    Row {
                        id: buttonRow
                        anchors.right: parent.right
                        spacing: Theme.spacingXS

                        DankActionButton {
                            visible: windowControls.supported && windowControls.canMaximize
                            iconName: inputWindow.maximized ? "fullscreen_exit" : "fullscreen"
                            iconSize: Theme.iconSize - 4
                            iconColor: Theme.surfaceText
                            onClicked: windowControls.tryToggleMaximize()
                        }

                        DankActionButton {
                            iconName: "close"
                            iconSize: Theme.iconSize - 4
                            iconColor: Theme.surfaceText
                            onClicked: {
                                lastResult = "";
                                resultState = "cancelled";
                                inputWindow.hide();
                            }
                        }
                    }
                }

                Rectangle {
                    width: parent.width
                    height: inputWindow.inputFieldHeight
                    radius: Theme.cornerRadius
                    color: Theme.surfaceHover
                    border.color: inputField.activeFocus ? Theme.primary : Theme.outlineStrong
                    border.width: inputField.activeFocus ? 2 : 1

                    MouseArea {
                        anchors.fill: parent
                        onClicked: inputField.forceActiveFocus()
                    }

                    DankTextField {
                        id: inputField

                        anchors.fill: parent
                        font.pixelSize: Theme.fontSizeMedium
                        textColor: Theme.surfaceText
                        placeholderText: root.placeholderText
                        backgroundColor: "transparent"
                        echoMode: root.isPassword ? TextInput.Password : TextInput.Normal
                        enabled: inputWindow.visible
                        onAccepted: root.submitInput()
                    }
                }

                Item {
                    width: parent.width
                    height: 40

                    Row {
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: Theme.spacingM

                        Rectangle {
                            width: Math.max(70, cancelLabel.contentWidth + Theme.spacingM * 2)
                            height: 36
                            radius: Theme.cornerRadius
                            color: cancelArea.containsMouse ? Theme.surfaceTextHover : "transparent"
                            border.color: Theme.surfaceVariantAlpha
                            border.width: 1

                            StyledText {
                                id: cancelLabel
                                anchors.centerIn: parent
                                text: cancelButtonText
                                font.pixelSize: Theme.fontSizeMedium
                                color: Theme.surfaceText
                                font.weight: Font.Medium
                            }

                            MouseArea {
                                id: cancelArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    lastResult = "";
                                    resultState = "cancelled";
                                    inputWindow.hide();
                                }
                            }
                        }

                        Rectangle {
                            width: Math.max(80, okLabel.contentWidth + Theme.spacingM * 2)
                            height: 36
                            radius: Theme.cornerRadius
                            color: okArea.containsMouse ? Qt.darker(Theme.primary, 1.1) : Theme.primary

                            StyledText {
                                id: okLabel
                                anchors.centerIn: parent
                                text: actionButtonText
                                font.pixelSize: Theme.fontSizeMedium
                                color: Theme.background
                                font.weight: Font.Medium
                            }

                            MouseArea {
                                id: okArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.submitInput()
                            }

                            Behavior on color {
                                ColorAnimation {
                                    duration: Theme.shortDuration
                                    easing.type: Theme.standardEasing
                                }
                            }
                        }
                    }
                }
            }
        }

        FloatingWindowControls {
            id: windowControls
            targetWindow: inputWindow
        }
    }

    function submitInput() {
        var text = inputField.text;
        lastResult = text;
        resultState = "submitted";

        if (!isPassword && copyToClipboard && text.length > 0) {
            Quickshell.execDetached(["dms", "cl", "copy", text]);
        }
        if (!isPassword && submitCommand && text.length > 0) {
            var cmd = submitCommand.replace(/%s/g, text);
            Quickshell.execDetached(["sh", "-c", cmd]);
        }

        inputWindow.hide();
    }

    IpcHandler {
        target: "text-input"

        function open(title: string, header: string, placeholder: string): string {
            root.applyArgs(title, header, placeholder, "text");
            return "TEXT_INPUT_OPENED";
        }

        function openPassword(title: string, header: string, placeholder: string): string {
            root.applyArgs(title, header, placeholder, "password");
            return "TEXT_INPUT_OPENED";
        }

        function result(): string {
            const r = JSON.stringify({state: resultState, value: lastResult});
            lastResult = "";
            resultState = "idle";
            return r;
        }

        function close(): string {
            lastResult = "";
            resultState = "cancelled";
            inputWindow.hide();
            return "TEXT_INPUT_CLOSED";
        }

        function toggle(title: string, header: string, placeholder: string): string {
            if (inputWindow.visible) {
                lastResult = "";
                inputWindow.hide();
                return "TEXT_INPUT_CLOSED";
            }
            root.applyArgs(title, header, placeholder, "text");
            return "TEXT_INPUT_OPENED";
        }

        function togglePassword(title: string, header: string, placeholder: string): string {
            if (inputWindow.visible) {
                lastResult = "";
                inputWindow.hide();
                return "TEXT_INPUT_CLOSED";
            }
            root.applyArgs(title, header, placeholder, "password");
            return "TEXT_INPUT_OPENED";
        }
    }
}
