import QtQuick
import qs.Common
import qs.Widgets
import qs.Modules.Plugins

PluginSettings {
    pluginId: "textInputDialog"

    StyledText {
        width: parent.width
        text: I18n.tr("Text Input Dialog")
        font.pixelSize: Theme.fontSizeLarge
        font.weight: Font.Bold
        color: Theme.surfaceText
    }

    StringSetting {
        settingKey: "dialogTitle"
        label: I18n.tr("Dialog Title")
        description: I18n.tr("Title displayed in the popup window")
        placeholder: "Input"
        defaultValue: "Input"
    }

    StringSetting {
        settingKey: "headerText"
        label: I18n.tr("Header Text")
        description: I18n.tr("Header text displayed in the popup. Leave empty to use the dialog title")
        placeholder: ""
        defaultValue: ""
    }

    StringSetting {
        settingKey: "placeholderText"
        label: I18n.tr("Placeholder Text")
        description: I18n.tr("Placeholder text shown in the input field")
        placeholder: "Enter text..."
        defaultValue: "Enter text..."
    }

    StringSetting {
        settingKey: "actionButtonText"
        label: I18n.tr("Action Button Text")
        description: I18n.tr("Text for the submit/action button")
        placeholder: "OK"
        defaultValue: "OK"
    }

    StringSetting {
        settingKey: "cancelButtonText"
        label: I18n.tr("Cancel Button Text")
        description: I18n.tr("Text for the cancel button")
        placeholder: "Cancel"
        defaultValue: "Cancel"
    }

    StringSetting {
        settingKey: "submitCommand"
        label: I18n.tr("Submit Command")
        description: I18n.tr("Command to run when text is submitted. Use %s as placeholder for the input text. Leave empty to only copy to clipboard.")
        placeholder: "echo %s"
        defaultValue: ""
    }

    ToggleSetting {
        settingKey: "copyToClipboard"
        label: I18n.tr("Copy to Clipboard")
        description: I18n.tr("Copy submitted text to clipboard automatically")
        defaultValue: true
    }
}