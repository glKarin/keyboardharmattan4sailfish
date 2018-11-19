Name:		keyboard-harmattan
Version:	1.0.0harmattan1
Release:	1
Summary: Layouts of virtual keyboard on Sailfish OS, include arrows, no-prediction...

BuildArch: noarch
Vendor: karin <beyondk2000@gmail.com>
Packager: karin <beyondk2000@gmail.com>
Group:		System/GUI/Other
License:	GPLv2
URL:		https://github.com/glKarin/keyboardharmattan4sailfish
Source0:	%{name}.tar.gz
BuildRoot:	%(mktemp -ud %{name})

Requires: jolla-keyboard

%description
 Layouts of virtual keyboard on Sailfish OS.
 Including English, Chinese Pinyin with arrow keys.
 And a English with controllable-prediction for Karin-Console.

%prep
%setup -q -n %{name}


%build

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/usr/share/maliit/plugins/com/jolla/harmattan
install -D -m 644 ./usr/share/maliit/plugins/com/jolla/layouts/harmattan_dev.conf $RPM_BUILD_ROOT/usr/share/maliit/plugins/com/jolla/layouts/harmattan_dev.conf
install -D -m 644 ./usr/share/maliit/plugins/com/jolla/layouts/harmattan_dev.qml $RPM_BUILD_ROOT/usr/share/maliit/plugins/com/jolla/layouts/harmattan_dev.qml
install -D -m 644 ./usr/share/maliit/plugins/com/jolla/layouts/harmattan_en.conf $RPM_BUILD_ROOT/usr/share/maliit/plugins/com/jolla/layouts/harmattan_en.conf
install -D -m 644 ./usr/share/maliit/plugins/com/jolla/layouts/harmattan_en.qml $RPM_BUILD_ROOT/usr/share/maliit/plugins/com/jolla/layouts/harmattan_en.qml
install -D -m 644 ./usr/share/maliit/plugins/com/jolla/layouts/harmattan_zh_cn_pinyin.conf $RPM_BUILD_ROOT/usr/share/maliit/plugins/com/jolla/layouts/harmattan_zh_cn_pinyin.conf
install -D -m 644 ./usr/share/maliit/plugins/com/jolla/layouts/harmattan_zh_cn_pinyin.qml $RPM_BUILD_ROOT/usr/share/maliit/plugins/com/jolla/layouts/harmattan_zh_cn_pinyin.qml
install -D -m 644 ./usr/share/maliit/plugins/com/jolla/harmattan/HarmBackspaceKey.qml $RPM_BUILD_ROOT/usr/share/maliit/plugins/com/jolla/harmattan/HarmBackspaceKey.qml
install -D -m 644 ./usr/share/maliit/plugins/com/jolla/harmattan/HarmChineseContextAwareCommaKey.qml $RPM_BUILD_ROOT/usr/share/maliit/plugins/com/jolla/harmattan/HarmChineseContextAwareCommaKey.qml
install -D -m 644 ./usr/share/maliit/plugins/com/jolla/harmattan/HarmChineseContextAwarePeriodKey.qml $RPM_BUILD_ROOT/usr/share/maliit/plugins/com/jolla/harmattan/HarmChineseContextAwarePeriodKey.qml
install -D -m 644 ./usr/share/maliit/plugins/com/jolla/harmattan/HarmContextAwareCommaKey.qml $RPM_BUILD_ROOT/usr/share/maliit/plugins/com/jolla/harmattan/HarmContextAwareCommaKey.qml
install -D -m 644 ./usr/share/maliit/plugins/com/jolla/harmattan/HarmContext.qml $RPM_BUILD_ROOT/usr/share/maliit/plugins/com/jolla/harmattan/HarmContext.qml
install -D -m 644 ./usr/share/maliit/plugins/com/jolla/harmattan/HarmFuncKey.qml $RPM_BUILD_ROOT/usr/share/maliit/plugins/com/jolla/harmattan/HarmFuncKey.qml
install -D -m 644 ./usr/share/maliit/plugins/com/jolla/HarmXt9InputHandler.qml $RPM_BUILD_ROOT/usr/share/maliit/plugins/com/jolla/HarmXt9InputHandler.qml


%clean
rm -rf $RPM_BUILD_ROOT


%files
%defattr(-,root,root,-)
%doc
/usr/share/maliit/plugins/com/jolla/layouts/harmattan_dev.conf
/usr/share/maliit/plugins/com/jolla/layouts/harmattan_dev.qml
/usr/share/maliit/plugins/com/jolla/layouts/harmattan_en.conf
/usr/share/maliit/plugins/com/jolla/layouts/harmattan_en.qml
/usr/share/maliit/plugins/com/jolla/layouts/harmattan_zh_cn_pinyin.conf
/usr/share/maliit/plugins/com/jolla/layouts/harmattan_zh_cn_pinyin.qml
/usr/share/maliit/plugins/com/jolla/harmattan/HarmBackspaceKey.qml
/usr/share/maliit/plugins/com/jolla/harmattan/HarmChineseContextAwareCommaKey.qml
/usr/share/maliit/plugins/com/jolla/harmattan/HarmChineseContextAwarePeriodKey.qml
/usr/share/maliit/plugins/com/jolla/harmattan/HarmContextAwareCommaKey.qml
/usr/share/maliit/plugins/com/jolla/harmattan/HarmContext.qml
/usr/share/maliit/plugins/com/jolla/harmattan/HarmFuncKey.qml
/usr/share/maliit/plugins/com/jolla/HarmXt9InputHandler.qml



%changelog
* Sun Nov 18 2018 Karin Zhao <beyondk2000@gmail.com> - 1.0.0harmattan1
  * Add new English layout for No-Prediction input.


%post
if [ "$1" = "1" ]; then
systemctl-user restart maliit-server.service
		echo "keyboard-harmattan install done."
fi


%postun
if [ "$1" = "0" ]; then
systemctl-user restart maliit-server.service
		echo "keyboard-harmattan remove done."
fi

