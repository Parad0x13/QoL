#Requires AutoHotkey v2.0
version := Round(2.1, 1)
default_functions := []

/*
	Quality of Life (QoL) script designed to make common tasks just a little easier
	Rewritten to adhere to AHK v2 standards
	Bryan A. Tremblay (Parad0x13)

	[NOTE] Standard macro calls will be Shift+Alt+Key
	Some useful reminders:
		https://www.autohotkey.com/docs/v2/lib/
		https://www.autohotkey.com/docs/v2/Hotkeys.htm
		^ (ctrl), ! (alt), + (shift), # (LWin/RWin)

		XButton1, XButton2
*/

default_functions.Push(["(c)lick", "Constantly left clicks"])
click() {
	MouseGetPos &mouseX, &mouseY
	Loop {
		MouseClick "L", mouseX, mouseY
		Sleep 10	; This may not be necessary, but I don't want to eff around and find out
	}
}
^!C::click()

; [TODO] Add cursor locations for both entire screen and active window (relative)
default_functions.Push(["(l)ocation", "Displays cursor information"])
location() {
	MouseGetPos &mouseX, &mouseY
	color := PixelGetColor(mouseX, mouseY)
	MsgBox "Cursor: (" mouseX ", " mouseY ") `nColor: " color
}
^!L::location()

default_functions.Push(["(t)imestamp", "YYYY.MM.DD.HHHH.TMZ"])
timestamp() {
	timezone := "MST"
	Send FormatTime("YYYYMMDDHH24MISS", "yyyy.MM.dd.HHmm." timezone)
}
^!T::timestamp()

default_functions.Push(["(h)ash", "Generates a random a-z:A-Z hash len(6)"])
hash() {
	a := StrSplit("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
	retVal := ""
	Loop 6 {
		retVal := retVal a[Random(1, a.Length)]
	}
	Send retVal
}
^!H::hash()

default_functions.Push(["(m)ist", "Loads up the mist A.I."])
mist() {
	Run A_Desktop "\mist\mist.bat"
}
^!M::mist()

default_functions.Push(["(q)uick", "Custom scripting function"])
quick() {
	msgbox "hi"
}
^!Q::quick()

default_functions.Push(["(r)eload/mode selection", "Forces a reload/mode selection of this script"])
modes := ["Default", "SomethingElse"]
mode_current := modes[1]
mode_selection() {
	;myGui := Gui()

	msg := "QoL Script " version " Mode Selection (Current mode: " mode_current ")`n"
	msg := msg "`nctrl+alt+"
	for function in default_functions {
		msg := msg "`n" function[1] ": " function[2]
	}
	msg := msg "`n"
	;text := myGui.Add("Text",, msg)

	;mode := MyGUI.Add("DDL", "vcbx w200 Choose1", modes)
	;mode.OnEvent("Change", selectMode)

	;btn := myGui.Add("Button", "Default w80", "OK")
	;btn.OnEvent("Click", setMode)

	;myGui.Show()

	; [BUG] Stopgap for now because the mode system does not work properly
	; [BUG] e.g. use the autoclicker functionality and you'll see everything breaks
	MsgBox msg
	Reload
}
^!R::mode_selection()

; [TODO] Can I do this inline? It seems silly to have it as it's own function
selectMode(obj, *) {
	global mode_current := modes[obj.value]
}

setMode(obj, *) {
	if mode_current == "Default" {
		Reload
	}
	else {
		MsgBox "Unknown mode selected, setting to default mode"
		global mode_current := "Default"
		setMode(obj)
	}
}

; [NOTE] waitUntilImageFound(image_loc, times) exists in QoL v1.x and may be reimplemented here later

;palworld_autorun() {
;	Send "{w Down}"
;	Send "{shift Down}"
;}
;XButton1::palworld_autorun()
