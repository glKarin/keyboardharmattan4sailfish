import QtQuick 2.0
import com.meego.maliitquick 1.0
import com.jolla.xt9 1.0
import Sailfish.Silica 1.0
import com.jolla.keyboard 1.0

InputHandler {
	id: xt9Handler

	property int candidateSpaceIndex: -1
	property string preedit

	property bool hnoPrediction: true;
	onHnoPredictionChanged: {
		commit(preedit);
	}
	property variant toolbarModel: ListModel{
		ListElement{
			index: Qt.Key_Tab;
			text: "";
			label: "Tab";
		}
		ListElement{
			index: Qt.Key_Escape;
			text: "";
			label: "Esc";
		}
		ListElement{
			index: Qt.Key_Home;
			text: "";
			label: "Home";
		}
		ListElement{
			index: Qt.Key_End;
			text: "";
			label: "End";
		}
		ListElement{
			index: Qt.Key_Delete;
			text: "";
			label: "Del";
		}
		ListElement{
			index: Qt.Key_Insert;
			text: "";
			label: "Ins";
		}
		ListElement{
			index: Qt.Key_F1;
			text: "";
			label: "F1";
		}
		ListElement{
			index: Qt.Key_F2;
			text: "";
			label: "F2";
		}
		ListElement{
			index: Qt.Key_F3;
			text: "";
			label: "F3";
		}
		ListElement{
			index: Qt.Key_F4;
			text: "";
			label: "F4";
		}
		ListElement{
			index: Qt.Key_F5;
			text: "";
			label: "F5";
		}
		ListElement{
			index: Qt.Key_F6;
			text: "";
			label: "F6";
		}
		ListElement{
			index: Qt.Key_F7;
			text: "";
			label: "F7";
		}
		ListElement{
			index: Qt.Key_F8;
			text: "";
			label: "F8";
		}
		ListElement{
			index: Qt.Key_F9;
			text: "";
			label: "F9";
		}
		ListElement{
			index: Qt.Key_F10;
			text: "";
			label: "F10";
		}
		ListElement{
			index: Qt.Key_F11;
			text: "";
			label: "F11";
		}
		ListElement{
			index: Qt.Key_F12;
			text: "";
			label: "F12";
		}
		ListElement{
			index: Qt.Key_Left;
			text: "";
			label: "Left";
		}
		ListElement{
			index: Qt.Key_Down;
			text: "";
			label: "Down";
		}
		ListElement{
			index: Qt.Key_Up;
			text: "";
			label: "Up";
		}
		ListElement{
			index: Qt.Key_Right;
			text: "";
			label: "Right";
		}
		ListElement{
			index: Qt.Key_PageDown;
			text: "";
			label: "PgDn";
		}
		ListElement{
			index: Qt.Key_PageUp;
			text: "";
			label: "PgUp";
		}
	}

	// hack: currently possible to know if there's active focus only on signal handler.
	// workaround with this to avoid predictions changing while hiding keyboard
	property bool trackSurroundings

	Xt9EngineThread {
		id: thread
		// note: also china language codes being set with this, assume xt9 model just ignores such
		language: layoutRow.layout ? layoutRow.layout.languageCode : ""

		property int shiftState: keyboard.isShifted ? (keyboard.isShiftLocked ? Xt9Model.ShiftLocked
		: Xt9Model.ShiftLatched)
		: Xt9Model.NoShift
		onShiftStateChanged: setShiftState(shiftState)

		function abort(word) {
			var oldPreedit = xt9Handler.preedit
			xt9Handler.commit(word)
			xt9Handler.preedit = oldPreedit.substr(word.length, oldPreedit.length-word.length)
			if (xt9Handler.preedit !== "") {
				if(hnoPrediction)
				{
					xt9Handler.commit(xt9Handler.preedit);
				}
				else
				{
					MInputMethodQuick.sendPreedit(xt9Handler.preedit)
				}
			}
		}
	}

	Component {
		id: pasteComponent
		Row{
			height: ListView.view.height;
			PasteButton {
				onClicked: {
					xt9Handler.commit(xt9Handler.preedit)
					MInputMethodQuick.sendCommit(Clipboard.text)
					keyboard.expandedPaste = false
				}
			}
			Image {
				anchors.verticalCenter: parent.verticalCenter
				source: "image://theme/icon-m-edit"
				+ (xt9Handler.hnoPrediction ? "" : "-selected")
				+ (noPredictionMouseEvent.pressed ? ("?" + Theme.highlightColor) : "");
				MouseArea{
					id: noPredictionMouseEvent;
					anchors.fill: parent;
					onClicked: {
						xt9Handler.hnoPrediction = !xt9Handler.hnoPrediction;
					}
				}
			}
		}
	}

	Component {
		id: verticalPasteComponent
		PasteButton {
			width: parent.width
			height: geometry.keyHeightLandscape

			onClicked: {
				xt9Handler.commit(xt9Handler.preedit)
				MInputMethodQuick.sendCommit(Clipboard.text)
			}
		}
	}

	function formatText(text) {
		if (text === undefined)
		return ""
		var preeditLength = xt9Handler.preedit.length
		if (text.substr(0, preeditLength) === xt9Handler.preedit) {
			return "<font color=\"" + Theme.highlightColor + "\">" + xt9Handler.preedit + "</font>"
			+ text.substr(preeditLength)
		} else {
			return text
		}
	}

	topItem: Component {
		TopItem {
			SilicaListView {
				id: predictionList

				model: xt9Handler.hnoPrediction ? xt9Handler.toolbarModel : thread.engine;
				orientation: ListView.Horizontal
				anchors.fill: parent
				header: pasteComponent
				boundsBehavior: !keyboard.expandedPaste && Clipboard.hasText ? Flickable.DragOverBounds : Flickable.StopAtBounds

				onDraggingChanged: {
					if (!dragging && !keyboard.expandedPaste && contentX < -(headerItem.width + Theme.paddingLarge)) {
						keyboard.expandedPaste = true
						positionViewAtBeginning()
					}
				}

				delegate: BackgroundItem {
					onClicked: applyPrediction(model.text, model.index)
					width: xt9Handler.hnoPrediction ? height : (candidateText.width + (xt9Handler.hnoPrediction ? Theme.paddingSmall : Theme.paddingLarge) * 2);
					height: parent ? parent.height : 0

					// contentItem.border.width: xt9Handler.hnoPrediction ? 1 : 0;
					// contentItem.border.color: highlighted ? Theme.primaryColor : highlightColor;

					Text {
						id: candidateText
						anchors.centerIn: parent
						clip: true;
						color: highlighted ? Theme.highlightColor : Theme.primaryColor
						font { pixelSize: Theme.fontSizeSmall; family: Theme.fontFamily; bold: xt9Handler.hnoPrediction; }
						text: formatText(xt9Handler.hnoPrediction ? model.label : model.text);

					}
				}

				Connections {
					target: thread.engine
					onPredictionsChanged: {
						if(!xt9Handler.hnoPrediction)
						{
							predictionList.positionViewAtBeginning()
						}
					}
				}

				Connections {
					target: Clipboard
					onTextChanged: {
						if (Clipboard.hasText) {
							// need to have updated width before repositioning view
							positionerTimer.restart()
						}
					}
				}

				Timer {
					id: positionerTimer
					interval: 10
					onTriggered: predictionList.positionViewAtBeginning()
				}
			}
		}
	}

	verticalItem: Component {
		Item {
			id: verticalContainer

			property int inactivePadding: Theme.paddingMedium

			SilicaListView {
				id: verticalList

				model: thread.engine
				anchors.fill: parent
				clip: true
				header: Component {
					PasteButtonVertical {
						visible: Clipboard.hasText
						width: verticalList.width
						height: visible ? geometry.keyHeightLandscape : 0
						popupParent: verticalContainer
						popupAnchor: 2 // center

						onClicked: {
							xt9Handler.commit(xt9Handler.preedit)
							MInputMethodQuick.sendCommit(Clipboard.text)
						}
					}
				}

				delegate: BackgroundItem {
					id: background
					onClicked: applyPrediction(model.text, model.index)
					width: parent.width
					height: geometry.keyHeightLandscape // assuming landscape!

					Text {
						width: background.width
						horizontalAlignment: Text.AlignHCenter
						anchors.verticalCenter: parent.verticalCenter
						color: highlighted ? Theme.highlightColor : Theme.primaryColor
						font.pixelSize: Theme.fontSizeSmall
						fontSizeMode: Text.HorizontalFit
						textFormat: Text.StyledText
						text: formatText(model.text)
					}
				}

				Connections {
					target: thread.engine
					onPredictionsChanged: {
						if (!clipboardChange.running) {
							verticalList.positionViewAtIndex(0, ListView.Beginning)
						}
					}
				}
				Connections {
					target: Clipboard
					onTextChanged: {
						verticalList.positionViewAtBeginning()
						clipboardChange.restart()
					}
				}
				Timer {
					id: clipboardChange
					interval: 1000
				}
				MouseArea {
					height: parent.height
					width: verticalContainer.inactivePadding
				}
				MouseArea {
					height: parent.height
					width: verticalContainer.inactivePadding
					anchors.right: parent.right
				}
			}
		}
	}

	onActiveChanged: {
		if (!active && preedit !== "") {
			thread.acceptWord(preedit, false)
			commit(preedit)
		}

		updateButtons()
	}

	Connections {
		target: keyboard
		onFullyOpenChanged: {
			// TODO: could avoid if new keyboard is just the same as the previous one
			updateButtons()
		}
		onLayoutChanged: updateButtons()
	}

	Connections {
		target: MInputMethodQuick
		onFocusTargetChanged: {
			xt9Handler.trackSurroundings = activeEditor
		}

		onEditorStateUpdate: {
			if (!xt9Handler.trackSurroundings) {
				return
			}

			if (MInputMethodQuick.surroundingTextValid) {
				var text = MInputMethodQuick.surroundingText.substring(0, MInputMethodQuick.cursorPosition)
				thread.setContext(text)
			} else {
				thread.setContext("")
			}
		}
	}

	function updateButtons() {
		// QtQuick positions Columns and Rows on next frame. avoid wrong positions by running only when fully shown.
		if (!active || !keyboard.fullyOpen) {
			return
		}

		if(hnoPrediction)
		{
			keyboard.autocaps = false;
		}
		var layout = keyboard.layout

		var children = layout.children
		var i
		var child

		thread.startLayout(layout.width, layout.height)

		for (i = 0; i < children.length; ++i) {
			addButtonsFromChildren(children[i], layout)
		}

		thread.finishLayout()
	}

	function addButtonsFromChildren(item, layout) {
		var children = item.children
		var child

		for (var i = 0; i < children.length; ++i) {
			child = children[i]
			if (typeof child.keyType !== 'undefined') {
				if (child.keyType === KeyType.CharacterKey && child.active) {
					var mapped = item.mapToItem(layout, child.x, child.y, child.width, child.height)
					var buttonText = child.text + child.nativeAccents
					var buttonTextShifted = child.captionShifted + child.nativeAccentsShifted

					thread.addLayoutButton(mapped.x, mapped.y, mapped. width, mapped.height, buttonText, buttonTextShifted)
				}
			} else {
				addButtonsFromChildren(child, layout)
			}
		}
	}

	function applyPrediction(replacement, index) {
		if(hnoPrediction)
		{
			if(index)
			{
				MInputMethodQuick.sendKey(index, 0, replacement, Maliit.KeyClick);
			}
			else
			{
				commit(replacement);
			}
		}
		else
		{
			console.log("candidate clicked: " + replacement + "\n")
			replacement = replacement + " "
			candidateSpaceIndex = MInputMethodQuick.surroundingTextValid
			? MInputMethodQuick.cursorPosition + replacement.length : -1
			commit(replacement)
			thread.acceptPrediction(index)
		}
	}

	function handleKeyClick() {
		if(hnoPrediction)
		{
			return harm_handleKeyClick();
		}

		var handled = false
		keyboard.expandedPaste = false

		if (pressedKey.key === Qt.Key_Space) {
			if (preedit !== "") {
				thread.acceptWord(preedit, true)
				commit(preedit + " ")
				keyboard.autocaps = false // assuming no autocaps after input with xt9 preedit
			} else {
				commit(" ")
			}

			if (keyboard.shiftState !== ShiftState.LockedShift) {
				keyboard.shiftState = ShiftState.AutoShift
			}

			handled = true

		} else if (pressedKey.key === Qt.Key_Return) {
			if (preedit !== "") {
				thread.acceptWord(preedit, false)
				commit(preedit)
			}
			if (keyboard.shiftState !== ShiftState.LockedShift) {
				keyboard.shiftState = ShiftState.AutoShift
			}

		} else if (pressedKey.key === Qt.Key_Backspace && preedit !== "") {
			preedit = preedit.substr(0, preedit.length-1)
			thread.processBackspace()
			MInputMethodQuick.sendPreedit(preedit)

			if (keyboard.shiftState !== ShiftState.LockedShift) {
				if (preedit.length === 0) {
					keyboard.shiftState = ShiftState.AutoShift
				} else {
					keyboard.shiftState = ShiftState.NoShift
				}
			}

			handled = true

		} else if (pressedKey.text.length !== 0) {
			var wordSymbol = "\'-".indexOf(pressedKey.text) >= 0

			if (thread.isLetter(pressedKey.text) || wordSymbol) {
				var forceAdd = pressedKey.keyType === KeyType.PopupKey
				|| keyboard.inSymView
				|| keyboard.inSymView2
				|| wordSymbol

				thread.processSymbol(pressedKey.text, forceAdd)
				preedit += pressedKey.text

				if (keyboard.shiftState !== ShiftState.LockedShift) {
					keyboard.shiftState = ShiftState.NoShift
				}

				MInputMethodQuick.sendPreedit(preedit)
				handled = true
			} else {
				// normal symbols etc.
				if (preedit !== "") {
					thread.acceptWord(preedit, false) // do we need to notify xt9 with the appended symbol?
					commit(preedit + pressedKey.text)
				} else {
					if (candidateSpaceIndex > 0 && candidateSpaceIndex === MInputMethodQuick.cursorPosition
					&& ",.?!".indexOf(pressedKey.text) >= 0
					&& MInputMethodQuick.surroundingText.charAt(MInputMethodQuick.cursorPosition - 1) === " ") {
						if (thread.language === "FR" && "?!".indexOf(pressedKey.text) >= 0) {
							// follow French grammar rules for ? and !
							MInputMethodQuick.sendCommit(pressedKey.text + " ")
						} else {
							// replace automatically added space from candidate clicking
							MInputMethodQuick.sendCommit(pressedKey.text + " ", -1, 1)
						}
						preedit = ""
					} else {
						commit(pressedKey.text)
					}
				}

				handled = true
			}
		} else if (pressedKey.key === Qt.Key_Backspace && MInputMethodQuick.surroundingTextValid
		&& !MInputMethodQuick.hasSelection
		&& MInputMethodQuick.cursorPosition >= 2
		&& isInputCharacter(MInputMethodQuick.surroundingText.charAt(MInputMethodQuick.cursorPosition - 2))) {
			// backspacing into a word, re-activate it
			var length = 1
			var pos = MInputMethodQuick.cursorPosition - 3
			for (; pos >= 0 && isInputCharacter(MInputMethodQuick.surroundingText.charAt(pos)); --pos) {
				length++
			}
			pos++

			var word = MInputMethodQuick.surroundingText.substring(pos, pos + length)
			MInputMethodQuick.sendKey(Qt.Key_Backspace, 0, "\b", Maliit.KeyClick)
			MInputMethodQuick.sendPreedit(word, undefined, -length, length)
			thread.reactivateWord(word)
			preedit = word
			handled = true
		}

		if (pressedKey.keyType !== KeyType.ShiftKey && pressedKey.keyType !== KeyType.SymbolKey) {
			candidateSpaceIndex = -1
		}

		return handled
	}

	function isInputCharacter(character) {
		return thread.isLetter(character) || "\'-".indexOf(character) >= 0
	}

	function reset() {
		thread.reset()
		preedit = ""
	}

	function commit(text) {
		MInputMethodQuick.sendCommit(text)
		preedit = ""
	}

	function harm_handleKeyClick() {
		var handled = false
		keyboard.expandedPaste = false

		if (pressedKey.key === Qt.Key_Space) {
			preedit += " ";

			if (keyboard.shiftState !== ShiftState.LockedShift) {
				keyboard.shiftState = ShiftState.NoShift
			}

			handled = true

		} else if (pressedKey.key === Qt.Key_Return) {
			if (keyboard.shiftState !== ShiftState.LockedShift) {
				keyboard.shiftState = ShiftState.NoShift
			}

		} else if (pressedKey.key === Qt.Key_Backspace) {
			thread.processBackspace()
			MInputMethodQuick.sendKey(Qt.Key_Backspace, 0, "\b", Maliit.KeyClick)

			if (keyboard.shiftState !== ShiftState.LockedShift) {
					//k keyboard.shiftState = ShiftState.AutoShift
					keyboard.shiftState = ShiftState.NoShift
			}

			handled = true

		} else if (pressedKey.text.length !== 0) {
			var wordSymbol = "\'-".indexOf(pressedKey.text) >= 0

			// [a-zA-Z0-9\\'-]
			if (thread.isLetter(pressedKey.text) || wordSymbol) {
				var forceAdd = pressedKey.keyType === KeyType.PopupKey
				|| keyboard.inSymView
				|| keyboard.inSymView2
				|| wordSymbol

				thread.processSymbol(pressedKey.text, forceAdd)
				preedit += pressedKey.text

				if (keyboard.shiftState !== ShiftState.LockedShift) {
					keyboard.shiftState = ShiftState.NoShift
				}

				handled = true
			} else {
				// normal symbols etc.
					if (candidateSpaceIndex > 0 && candidateSpaceIndex === MInputMethodQuick.cursorPosition
					&& ",.?!".indexOf(pressedKey.text) >= 0
					&& MInputMethodQuick.surroundingText.charAt(MInputMethodQuick.cursorPosition - 1) === " ") {
						if (thread.language === "FR" && "?!".indexOf(pressedKey.text) >= 0) {
							// follow French grammar rules for ? and !
							MInputMethodQuick.sendCommit(pressedKey.text + " ")
						} else {
							// replace automatically added space from candidate clicking
							MInputMethodQuick.sendCommit(pressedKey.text + " ", -1, 1)
						}
						preedit = ""
					} else {
						commit(pressedKey.text)
					}

				handled = true
			}
		}

		if (pressedKey.keyType !== KeyType.ShiftKey && pressedKey.keyType !== KeyType.SymbolKey) {
			candidateSpaceIndex = -1
		}

		if(preedit.length > 0)
		{
			commit(preedit);
		}

		return handled
	}

}
