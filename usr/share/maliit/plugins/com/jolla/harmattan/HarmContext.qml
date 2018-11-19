import QtQuick 2.0

QtObject{
	id: root;

	property variant functionKey: ({
		"left": { code: Qt.Key_Left, text: "" },
		"right": { code: Qt.Key_Right, text: "" },
		"up": { code: Qt.Key_Up, text: "" },
		"down": { code: Qt.Key_Down, text: "" },
		"home": { code: Qt.Key_Home, text: "" },
		"end": { code: Qt.Key_End, text: "" },
		"pageup": { code: Qt.Key_PageUp, text: "" },
		"pagedown": { code: Qt.Key_PageDown, text: "" },
		"tab": { code: Qt.Key_Tab, text: "" },
		"escape": { code: Qt.Key_Escape, text: "" },
		"delete": { code: Qt.Key_Delete, text: "" },
		"backspace": { code: Qt.Key_Backspace, text: ""/* \b */ },
	});
}
