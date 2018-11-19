import QtQuick 2.0
import com.meego.maliitquick 1.0
import com.jolla.keyboard 1.0
import ".."
import "../harmattan"

KeyboardLayout {
	splitSupported: true

	HarmContext{
		id: harmContext;
	}

	KeyboardRow {
		CharacterKey { caption: "q"; captionShifted: "Q"; symView: "1"; symView2: "€" }
		CharacterKey { caption: "w"; captionShifted: "W"; symView: "2"; symView2: "£" }
		CharacterKey { caption: "e"; captionShifted: "E"; symView: "3"; symView2: "$"; accents: "èeéêë€"; accentsShifted: "ÈEÉÊË€" }
		CharacterKey { caption: "r"; captionShifted: "R"; symView: "4"; symView2: "¥" }
		CharacterKey { caption: "t"; captionShifted: "T"; symView: "5"; symView2: "₹"; accents: "tþ"; accentsShifted: "TÞ" }
		CharacterKey { caption: "y"; captionShifted: "Y"; symView: "6"; symView2: "%"; accents: "ýy¥"; accentsShifted: "ÝY¥" }
		CharacterKey { caption: "u"; captionShifted: "U"; symView: "7"; symView2: "<"; accents: "űûùuúü"; accentsShifted: "ŰÛÙUÚÜ" }
		CharacterKey { caption: "i"; captionShifted: "I"; symView: "8"; symView2: ">"; accents: "îïìií"; accentsShifted: "ÎÏÌIÍ" }
		CharacterKey { caption: "o"; captionShifted: "O"; symView: "9"; symView2: "["; accents: "őøöôòoó"; accentsShifted: "ŐØÖÔÒOÓ" }
		CharacterKey { caption: "p"; captionShifted: "P"; symView: "0"; symView2: "]" }
	}

	KeyboardRow {
		splitIndex: 5

		CharacterKey { caption: "a"; captionShifted: "A"; symView: "*"; symView2: "`"; accents: "aäàâáãå"; accentsShifted: "AÄÀÂÁÃÅ"}
		CharacterKey { caption: "s"; captionShifted: "S"; symView: "#"; symView2: "^"; accents: "sß$"; accentsShifted: "S$" }
		CharacterKey { caption: "d"; captionShifted: "D"; symView: "+"; symView2: "|"; accents: "dð"; accentsShifted: "DÐ" }
		CharacterKey { caption: "f"; captionShifted: "F"; symView: "-"; symView2: "_" }
		CharacterKey { caption: "g"; captionShifted: "G"; symView: "="; symView2: "§" }
		CharacterKey { caption: "h"; captionShifted: "H"; symView: "("; symView2: "{" }
		CharacterKey { caption: "j"; captionShifted: "J"; symView: ")"; symView2: "}" }
		CharacterKey { caption: "k"; captionShifted: "K"; symView: "!"; symView2: "¡" }
		CharacterKey { caption: "l"; captionShifted: "L"; symView: "?"; symView2: "¿" }

		HarmContextAwareCommaKey { }
	}

	KeyboardRow {
		splitIndex: 5

		ShiftKey {
			implicitWidth: punctuationKeyWidth;
			property bool implicitSeparator: false;
			property string symView;
		}

		CharacterKey { caption: "z"; captionShifted: "Z"; symView: "@"; symView2: "«" }
		CharacterKey { caption: "x"; captionShifted: "X"; symView: "~"; symView2: "»" }
		CharacterKey { caption: "c"; captionShifted: "C"; symView: "/"; symView2: "\""; accents: "cç"; accentsShifted: "CÇ" }
		CharacterKey { caption: "v"; captionShifted: "V"; symView: "\\"; symView2: "“" }
		CharacterKey { caption: "b"; captionShifted: "B"; symView: "'"; symView2: "”" }
		CharacterKey { caption: "n"; captionShifted: "N"; symView: ";"; symView2: "„"; accents: "nñ"; accentsShifted: "NÑ" }
		CharacterKey { caption: "m"; captionShifted: "M"; symView: ":"; symView2: "&" }

		CharacterKey {
			caption: "."
			captionShifted: "."
			// implicitWidth: punctuationKeyWidth
			// fixedWidth: !splitActive
			// separator: SeparatorState.HiddenSeparator
		}

		BackspaceKey {
			implicitWidth: punctuationKeyWidth;
			property bool implicitSeparator: false;
			property string symView;
		}
	}

	KeyboardRow {
		splitIndex: 5

		SymbolKey {
			implicitWidth: punctuationKeyWidth * 1.5;
		}
		HarmFuncKey{
			implicitWidth: punctuationKeyWidth;
			hcaption: "left";
			property bool implicitSeparator: false;
			property string symView;
		}
		HarmFuncKey{
			implicitWidth: punctuationKeyWidth;
			hcaption: "down";
			property bool implicitSeparator: false;
			property string symView;
		}
		SpacebarKey {
			languageLabel: "Harmattan EN"
		}
		SpacebarKey {
			active: splitActive
			languageLabel: ""
		}
		HarmFuncKey{
			implicitWidth: punctuationKeyWidth;
			hcaption: "up";
			property bool implicitSeparator: false;
			property string symView;
		}
		HarmFuncKey{
			implicitWidth: punctuationKeyWidth;
			hcaption: "right";
			property bool implicitSeparator: false;
			property string symView;
		}
		EnterKey {
			implicitWidth: punctuationKeyWidth * 1.5;
		}
	}
}
