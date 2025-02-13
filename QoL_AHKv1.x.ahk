; Quality of Life (QoL) script designed to make common tasks just a little easier
; Bryan A. Tremblay (Parad0x13)
version = v1.4

; RAID Shadow Legends with Sandboxie global variables
g_scr1 = 0
g_scr2 = 0
g_scr3 = 0
g_scr4 = 0

; Standard macro calls will be Shift+Alt+Key

; Some useful reminders:
; ^ shift
; ! alt
; + shift
; # LWin/RWin
; Send Commands: https://autohotkey.com/docs/commands/Send.htm

; (c)lick. Simply clicks... constantly... for whatever reason you might want
; The delay of 10ms is there incase the application requires a delay
click() {
;	MouseGetPos mouseX, mouseY
;	Loop {
;		Click %mouseX%, %mouseY%
;		random rand, 4000, 12000
;		;msgbox %rand%
;		Sleep %rand%
;	}

	MouseGetPos mouseX, mouseY
	Loop {
		Click %mouseX%, %mouseY%
	}
}
^!C::
click()
return

; (l)ocation. Gives you the X, Y location of the cursor on screen with some additional info
; [TODO] Add cursor locations for both entire screen and active window (relative)
location() {
	MouseGetPos mouseX, mouseY
	PixelGetColor color, %mouseX%, %mouseY%
	MsgBox Cursor: (%mouseX%, %mouseY%) `nColor: %color%
}
^!L::
location()
return

; (t)imestamp inputs the date time group from when the macro is called
; Helpful for standardizing timestamps
; Current standard is YYYY.MM.DD.HHHH.TMZ
; This standard is preferred for sorting purposes
; https://autohotkey.com/docs/commands/FormatTime.htm
; [TODO] Make it so you don't have to set timezone manually
timestamp() {
	timezone = MST    ; 2023.12.11.1449.MST Changed to MST from EST
	FormatTime time,, yyyy.MM.dd.HHmm
	Send %time%.%timezone%
}
^!T::
timestamp()
return

; [TODO] Make this nicer... I hate copy-pasta
; Taken from https://autohotkey.com/board/topic/84783-functionrandom-string-generator/
;------------------------------------ SC_RandomString ----------------------------------
; This will generate a random string according to options
; U = Upper case
; L = Lower case
; D = Digit ( number )
; M = Maximum numbers
;
; Specify one of these letters and then ( optional ) have a number after it
; That will be the Minimum number of that type of character
; The rest of the characters will be random ( while still fitting the options )
;
; This will return 1 if the Max ( M10 ) is samller than all the other options that add up
;
; Example
;-----------
 MsgBox,% SC_RandomString(" M10 U L2 D5")   ; This will have a Minimum of 2 lower case and 5 Digits, everything else will be a random between U L and D
;---------------------------------------------------------------------------------------------
SC_RandomString( Options ) {
	Div := 0, Total := 0
	If not RegExMatch( Options, "(M|m)(\d+)", _)
		Return 1
	If RegExMatch( Options, "(U|u)(\d?)", __)
		Div++, U := 1
	If RegExMatch( Options, "(L|l)(\d?)", ___)
		Div++, L := 1
	If RegExMatch( Options, "(D|d)(\d?)", ____)
		Div++, D := 1
	Max := _2, Un := __2, Ln := ___2, Dn := ____2, Un := Un > 0 ? Un : 1, Ln := Ln > 0 ? Ln : 1, Dn := Dn > 0 ? Dn : 1, Total := ( Un + LN + Dn ) , Un := U < 0 ? 0 : Un, Ln := L < 0 ? 0 : Ln, Dn := D < 0 ? 0 : Dn
	If ( Un + LN + Dn ) > Max 
		Return 2
	SC_Loop:
	Loop, %Total% {
		Random, Ran, 65, 90
		Out .= Un > 0 ? ( Chr(Ran) , Un-- ) : "" 
		If StrLen( Out ) = Max
			Goto, End
		Random, Ran, 97, 122
		Out .= Ln > 0 ? ( Chr(Ran), Ln-- ) : ""
		If StrLen( Out ) = Max
			Goto, End
		Random, Ran, 0,9
		Out .= Dn > 0 ? ( Ran, Dn-- ) : ""
		If StrLen( Out ) = Max
			Goto, End
	}
	If StrLen( Out ) < Max {
		Un+= U > 0 ? 1 : 0,Ln+= L > 0 ? 1 : 0,Dn+= D > 0 ? 1 : 0
		Goto, SC_Loop
	}
	End:
	Loop, Parse, Out,
	{
		gOut .= A_LoopField ","
		Sort, gOut, Random D`,
	}
	Loop, Parse, gOut, `,
	{
		If A_LoopField = %Last%
		Return SC_RandomString( Options ) 
		Last := A_LoopField
	}
	StringReplace, Out, gOut, `,,,All
	Return Out
}
;--------------------------------- End of function --------------------------------

; (h)ash
hash() {
	Send % SC_RandomString("M6 UL")
}
^!H::
hash()
return

; (m)ist
mist() {
	Run, %A_Desktop%/mist/mist.bat
}
^!M::
mist()
return

rs3_clearFirstThree() {
	mousemove 38,787,1
	Loop 3 {
		Loop 15 {
			click right
			mousemove 0,45,1,rel
			click
			mousemove 0,-45,1,rel
		}
		mousemove 35,0,1,rel
	}
	send {7}
}

;`::
;rs3_clearFirstThree()
;return

rs3_craftFourToSix() {
	MouseGetPos mouseX, mouseY
	mousemove 140,787,1

	Loop 3 {
		click right
		mousemove 0,25,1,rel
		click
		sleep 2000
		send {space}
		sleep 6000
		mousemove 0,-25,1,rel
		mousemove 35,0,1,rel
	}
}

; Just continuously jump for a rust server... modded thing
;XButton2::
;Loop {
;	Send {space}
;	Sleep 500
;}
;return

; (q)uick allows you to quickly script something if you need to, just delete code when you don't need it anymore!
; If you need to be really quick you can remove the ^! and then put it back afterwards!
;quick() {
;	MouseGetPos mouseX, mouseY
;	Loop {
;		Loop 40 {
;			random x, -10, 10
;			random y, -10, 10
;			click %mouseX% + x, %mouseY% + y, 5
;			Sleep 2000
;		}
;		rs3_craftFourToSix()
;		rs3_clearFirstThree()
;	}
;}

;quick() {
;	; Quick play Cookie Clicker
;	Loop {
;		Loop 100
;			Click 300, 450    ; Cookie
;		;Click 300, 450    ; Cookie
;
;		Click 1650 130    ; Upgrades
;		Click 1700, 180    ; x1 button
;
;		; Cursor
;		PixelGetColor, color, 1685, 214
;		if(color == 0xFFFFFF)
;			Click 1685, 214
;
;		; Grandma
;		PixelGetColor, color, 1682, 286
;		if(color == 0xFFFFFF)
;			Click 1682, 286
;
;		; Farm
;		PixelGetColor, color, 1686, 351
;		if(color == 0xFFFFFF)
;			Click 1686, 351
;	}
;}

;quick() {
;	; Quick craft for RUST
;	mousemove 1200, 880, 1
;	click
;	mousemove 1700, 880, 1
;	click
;}

; Click to collect item every 60 seconds
; Doesn't seem to work though...
;quick() {
;	MouseGetPos mouseX, mouseY
;	Loop {
;		click %mouseX%, %mouseY%, 5
;		Sleep 60500
;	}
;}

;quick() {
;	MouseGetPos mouseX, mouseY
;	Loop {
;		click %mouseX%, %mouseY%, 5
;		; Sleep 5000
;		Sleep 1000
;	}
;}
^!Q::
quick()
return

; Rust buy max stack of 10 smoke grenades constantly for recycling
quick() {
	Loop {
		Click 1740 880
		Send 10
		Click 1740 845
		Sleep 2800
	}
}
return

;MButton::
;Loop 6 {
	;Click
	;Sleep 395
;}
;return

; For RUST chest placement
;Left::
;send {a}
;sleep 250
;return

;goToSafe() {
;	send {ENTER}
;	send {/}
;	send home safe
;	send {ENTER}
;}
;`::
;goToSafe()
;return

;XButton1::
;loop {
;	send ``
;	send {shift down} {space down}
;	sleep 10
;	send {space up} {shift up}
;	sleep 500
;}
;return

;+LButton::
;click d
;mousemove -300,0,2,rel
;click u
;mousemove 300,0,2,rel
;return

; (r)eload also should display available functions
; [TODO] Make it so I don't have to manually add each available function to this MsgBox script
reload() {
	global version
	MsgBox QoL Script %version% Reloaded`n`nctrl+alt+`n(c)lick: constantly left clicks`n(h)ash: generates a random a-z:A-Z hash len(6)`n(l)ocation: displays cursor information`n(r)eload`n(m)ist: loads up the mist A.I.`n(q)uick: custom scripting function`n(t)imestamp: YYYY.MM.DD.HHHH.TMZ
	Reload
}
^!R::
reload()
return

; RUST 1000x server manage initial inventory
;F2::
;Send {tab}
;Sleep 100
;MouseClickDrag, Left,  790,  620,  790,  500, 2
;MouseClickDrag, Left,  910, 1000,  910,  500, 2
;MouseClickDrag, Left, 1200, 1010, 1200,  500, 2
;MouseClickDrag, Left, 1100, 1000,  910, 1000, 2
;MouseClickDrag, Left,  820, 1000,  710, 1000, 2
;return

;;;;;;;;;; BEG STUFF FOR RAID AND SANDBOXIE ;;;;;;;;;;

; I effing HATE AHK with so very much of my being it's unbearable
; It has to be the ugliest language next to baby speak... christ it's so effing bad
;mirrorClicksForRAID() {
;	global g_scr1, g_scr2, g_scr3, g_scr4
;	MouseGetPos, x, y
;	w := A_ScreenWidth / 2
;	h := A_ScreenHeight / 2

;	if(x < w and y < h) {
;		x1 := x + 0, y1 := y + 0
;		x2 := x + w, y2 := y + 0
;		x3 := x + 0, y3 := y + h
;		x4 := x + w, y4 := y + h
;	}
;	if(x > w and y < h) {
;		x1 := x - w, y1 := y + 0
;		x2 := x + 0, y2 := y + 0
;		x3 := x - w, y3 := y + h
;		x4 := x + 0, y4 := y + h
;	}
;	if(x < w and y > h) {
;		x1 := x + 0, y1 := y - h
;		x2 := x + w, y2 := y - h
;		x3 := x + 0, y3 := y + 0
;		x4 := x + w, y4 := y + 0
;	}
;	if(x > w and y > h) {
;		x1 := x - w, y1 := y - h
;		x2 := x + 0, y2 := y - h
;		x3 := x - w, y3 := y + 0
;		x4 := x + 0, y4 := y + 0
;	}
;
;	if(g_scr1 == 1) {
;		MouseMove, x1, y1, 0
;		Click
;	}
;	if(g_scr2 == 1) {
;		MouseMove, x2, y2, 0
;		Click
;	}
;	if(g_scr3 == 1) {
;		MouseMove, x3, y3, 0
;		Click
;	}
;	if(g_scr4 == 1) {
;		MouseMove, x4, y4, 0
;		Click
;	}
;	MouseMove x, y, 0
;}
;!LButton::
;mirrorClicksForRAID()
;return

;!Numpad0::global g_scr1 := 0, g_scr2 := 0, g_scr3 := 0, g_scr4 := 0, return
;!Numpad1::global g_scr1 := !g_scr1, return
;!Numpad2::global g_scr2 := !g_scr2, return
;!Numpad3::global g_scr3 := !g_scr3, return
;!Numpad4::global g_scr4 := !g_scr4, return
;!Numpad5::
;global g_scr1, g_scr2, g_scr3, g_scr4
;MsgBox Screens = %g_scr1%, %g_scr2%, %g_scr3%, %g_scr4%
;return

;;;;;;;;;; FIN STUFF FOR RAID AND SANDBOXIE ;;;;;;;;;;

;;;;;;;;;; BEG New World Scripts ;;;;;;;;;;
;#;M;a;x;T;h;r;e;a;d;s;P;e;r;H;o;t;k;e;y 2    ; Needed otherwise loop will never break
; For some reason I can't get this to work correctly in its own function... Needs to be as a hotkey
;fastWalking := 0
;XButton2::
;fastWalking := 1
;Send {w down}
;Loop {
;	Send 2
;	Sleep 100
;	Send {Shift}
;	Sleep 100
;	Send 1
;	Sleep 100
;	Send 2
;	Sleep 1000

;	Send r
;	Sleep 1800

;	Send {Shift}
;	Sleep 100
;	Send 1
;	Sleep 100
;	Send 2
;	Sleep 1000

;	Loop 7 {
;		Send {Shift}
;		Sleep 100
;		Send 1
;		Sleep 100
;		Send 2
;		Sleep 2300
;	}

;	Sleep 1000

	;;;;; Above is the case with using the axe's dash move
	;;;;; Below is without it

	;Loop {
	;	Send {Shift}
	;	Sleep 100
	;	Send 1
	;	Sleep 100
	;	Send 2
	;	Sleep 2300
	;}
;}

;speedwalk := !speedWalk
;Loop {
	;if not speedWalk
		;break

	; Designed to keep your weapon sheathed or unsheathed depending on when you started the speed walk
	;Send {w down}    ; Start Walk
	;Send {Shift}    ; Dodge Roll

	;Sleep 100
	;Send 2    ; Take weapon 2 out
	;Sleep 100
	;Send 1    ; Take weapon 1 out
	;Sleep 2200
;}
return

; Only detect w when pressed down, overrides the speedWalk functionality
;$w::
;Send {w down}
;if fastWalking {
;	Send 1
;	Reload
;}
;return

; Needed otherwise the game will continue walking
;$w up::
;Send {w up}
;return

waitUntilImageFound(image_loc, times) {
	WinGetPos,,, width, height, A

	if (times = -1)
		times := 1000

	Loop %times% {
		IfNotExist %image_loc%
			MsgBox Image does not exist

		ImageSearch, FoundX, FoundY, width / 4, height / 4, (width / 4) * 3, (height / 4) * 3, *100 %image_loc%
		if (ErrorLevel = 0) {
			return true
		}
		else if (ErrorLevel = 2) {
			MsgBox, Error with image search. Looked for %image_loc%
		}
	}
	return false
}

; Fishing, doesn't seem to want to find the fish image on screen in the game for some reason...
^!F::
;;MButton::    ; Simple button click for ease of use. Because I'm lazy...
;Click, Down
;Sleep 1960
;;Sleep 650
;;Sleep 100
;Click, Up

;waitUntilImageFound("C:/Users/Bryan/Desktop/fish.png", -1)
;Click

;Loop {
;	if (waitUntilImageFound("C:/Users/Bryan/Desktop/fish_green.png", 75) = false) {
;		break
;	}
;	Click, Down
;	Sleep 2000
;	Click, Up
;}
;SoundSetWaveVolume, 8
;SoundPlay, C:\Users\Bryan\Desktop\DoneFishing.wav
;;MsgBox,,, Done Fishing!, 3
;return

;;;;;;;;;; FIN New World Scripts ;;;;;;;;;;

;;;;;;;;;; BEG Genshin Impact Scripts ;;;;;;;;;;
;;;;;;;;;; Need to run AHK as admin for this to work in Genshin Impact

; Autowalk/run
;XButton1::
;Send {Shift down}
;Send {w down}
;Sleep 300
;Send {Shift up}
;return

;autoWalk = 0
;XButton1::
;autoWalk := !autoWalk

;if (autoWalk) {
;	Send {w down}
;	Loop {
;		Send {Shift down}
;		Sleep 400
;		Send {Shift up}
;		Sleep 13000    ; Wait until energy is depleted and refilled
		;Sleep 2000
;	}
;}
;return

; Only detect w when pressed down, overrides the speedWalk functionality
;$w::
;Send {w down}
;if (autoWalk) {
;	Send {shift up}    ; Why not... seem to have issues every now and again otherwise
;	Reload
;}
;return

; Needed otherwise the game will continue walking
;$w up::
;Send {w up}
;return

;;;;;;;;;; FIN Genshin Impact Scripts ;;;;;;;;;;

;;;;;;;;;; BEG Rust Scripts ;;;;;;;;;;

; This will toggle between the foundation types
;;;foundationToggle := 0
;;;XButton2::    ; bind mouse4 clear < rust
;Click Down Right
;if (foundationToggle = 0)
;{
	;MouseMove 978, 228    ; Square Foundation
;	MouseMove 1269, 491    ; Square Floor
;	foundationToggle := 1
;}
;else
;{
	;MouseMove 1092, 274    ; Triangle Foundation
;	MouseMove 1250, 610    ; Triangle Floor
;	foundationToggle := 0
;}
;Click
;Click Up Right

; Remove item from inventory
;;;SendEvent {Click Down}{Click 0, -500, Relative, Up}
;;;MouseMove 0, 500, 0, Relative

;;;return

;;;;;;;;;; FIN Rust Scripts ;;;;;;;;;;

;;;; RAID Click to sell a row of artifacts ;;;;
;XButton1::
;	MouseGetPos mouseX, mouseY
;	Loop 6 {
;		Click
;		MouseMove 140, 0, 1, Relative
;	}
;	MouseMove mouseX, mouseY
;	MouseMove 0, 140, 1, Relative
;return

;;;;;;;;;; BEG Diablo 4 Scripts ;;;;;;;;;;
;XButton1::
;    SendEvent {Click Down}    ; Effing no real autorun in this game wtf...
;return

;XButton2::
;	Send {Space}
;return
;;;;;;;;;; FIN Diablo 4 Scripts ;;;;;;;;;;

;;;;;;;;;; BEG RUST Scripts ;;;;;;;;;;
;XButton2::
	;Send {Space}
	;Sleep 100
	;Send {Enter}
	;Sleep 100
	;Send /nomini
	;Sleep 100
	;Send {Enter}
	;Sleep 100
	;Send {2}
;;;;;;;;;; FIN RUST Scripts ;;;;;;;;;;

;;;;;;;;;; BEG Valheim Scripts ;;;;;;;;;;
;XButton1::    ; Autorun, will have to press w and shift again though to reset it
;    SendEvent {w Down}
;	SendEvent {shift Down}
;return
;;;;;;;;;; FIN Diablo 4 Scripts ;;;;;;;;;;

;;;;;;;;;;
;XButton1::
;	SendEvent {Shift Down}
;	SendEvent {W Down}
;return
;;;;;;;;;;

;;;;;;;;;;
; Palworld Autorun

;XButton1::
;	SendEvent {Shift down}
;	SendEvent {W Down}
;Return
;;;;;;;;;

; Test for rebinding e and f... doesn't seem to work the way I want it to though
;#IfWinActive Pal
	;e::f
	;f::e
;Return

;XButton2::
;	Send {1}
;	Sleep 2100
;	Send {2}
;Return

; Macro to quick mine in Palworld? Doesn't seem to work very well, not at all with pics
; For some reason you have to click shift to fix a bug here?
;XButton2::
;	Click Down
;	Loop {
;		Sleep 300
;		Send {C}
;	}
;Return

; Macro for Palworld to click the sort button for your inventory, lazy mofos
; Disabled because the button position changes depending on what menu you are in
;`::
;	MouseMove 680, 150
;	Click
;Return

; Macro for Ace Rust 3x Solo/Duo/Trio/Quad initial hotbar setup
;XButton2::
;	Send {Enter}
;	Send /loadout save
;	Send {Enter}
;	;Send {Tab}
;	;MouseClickDrag L, 990, 1000, 990, 2000
;	;MouseClickDrag L, 900, 1000, 700, 1000
;	;MouseClickDrag L, 800, 1000, 990, 1000
;Return

;;;;;;;;;; FarCry 6 Autorun ;;;;;;;;;;
;XButton1::
;	SendEvent {Shift down}
;	SendEvent {W Down}
;Return

; Macro for Starbound to Beam Up or Beam Down
;^!Space::
;click 1890, 310
;click 1890, 276
;Return
;XButton1::
	;Send ~
	;Send 3

	;loop 3 {
	;	send {d down}
	;	sleep 10
	;	send {d up}
		
	;	sleep 10

	;	send {d down}
	;	sleep 10
	;	send {d up}

	;	sleep 275
	;}
;Return

;XButton1::
;	Send e
;	Sleep 100
;	Send {`` down}
;	Sleep 100
;	Send {`` up}
;Return
