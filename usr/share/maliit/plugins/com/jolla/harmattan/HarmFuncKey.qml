import QtQuick 2.0
import com.meego.maliitquick 1.0
import Sailfish.Silica 1.0
import ".."

FunctionKey {
	property string hcaption;
	property string hcaptionShifted;
	property string hsymView;
	property string hsymView2;
	property int functionKeyWidth: 52;
	property int firstPressInterval: 400;
	property int repeatPressInterval: 100;
	
	property string __keyname: attributes.inSymView && hsymView.length > 0 ? (attributes.inSymView2 && hsymView2.length > 0 ? hsymView2 : hsymView) : (attributes.isShifted && hcaptionShifted.length > 0 ? hcaptionShifted : hcaption);


	icon.source: (__keyname === "up" || __keyname === "down" || __keyname === "left" || __keyname === "right" || __keyname === "backspace") ? "image://theme/icon-m-" + __keyname + (pressed ? ("?" + Theme.highlightColor) : "") : "";
	repeat: true;
	key: Qt.Key_unknown;
	implicitWidth: functionKeyWidth;
	background.visible: icon.source == "";

	onPressedChanged: {
		if(pressed) {
			keyPressEvent()
			if(repeat) {
				autorepeatTimer.interval = firstPressInterval;
				autorepeatTimer.start()
			}
		} else {
			autorepeatTimer.stop();
		}
	}

	Timer {
		id: autorepeatTimer
		repeat: true

		onTriggered: {
			interval = repeatPressInterval;
			if (pressed) {
				keyPressEvent()
			} else {
				stop()
			}
		}
	}

	function keyPressEvent() {
		if(__keyname && __keyname.length > 0)
		{
			var keyinfo = harmContext.functionKey[__keyname];
			if(keyinfo) {
				MInputMethodQuick.sendKey(keyinfo.code, 0, keyinfo.text, Maliit.KeyClick)
			}
		}
	}
}
