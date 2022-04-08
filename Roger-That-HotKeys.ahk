#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
programs_PID := {}

;===================================================================================;
;=                  |~~\ |~~|~~~|~|\  |~|~~~|~~~|~ /~~\ |\  |/~~\                   ;
;=                  |   ||--|-- | | \ | |   |   | |    || \ |`--.                   ;
;=                  |__/ |__|  _|_|  \|_|_  |  _|_ \__/ |  \|\__/                   ;
;===================================================================================;
    ; # - Windows key
    ; ! - Alt
    ; ^ - Ctrl
    ; + - Shift
    ; & - An ampersand may be used between any two keys or mouse buttons to combine them into a custom hotkey
    ; https://www.autohotkey.com/docs/Hotkeys.htm

;===================================================================================;
;=                         /\  |   |~~|~~ /~~\   |~~\|   ||\  |                     ;
;=                        /__\ |   |  |  |    |  |__/|   || \ |                     ;
;=                       /    \ \_/   |   \__/   |  \ \_/ |  \|                     ;
;===================================================================================;
    ;------------------------------------------------------------ Mouse Position
        ; #Persistent
        ; SetTimer, WatchCursor, 100
        ; Return

        ; WatchCursor:
        ; MouseGetPos, xpos, ypos, id, control
        ; ToolTip, X%xpos% Y%ypos%
        ; Return

    ;------------------------------------------------------------ Mouse Over Info
        ; #Persistent
        ; SetTimer, WatchCursor, 100
        ; Return

        ; WatchCursor:
        ; MouseGetPos, xpos, ypos, id, control
        ; WinGetTitle, title, ahk_id %id%
        ; WinGetClass, class, ahk_id %id%
        ; ToolTip, X%xpos% Y%ypos% ahk_id %id%`nahk_class %class%`n%title%`nControl: %control%
        ; Return

;===================================================================================;
;=                      |~~|   ||\  | /~~~~|~~~|~ /~~\ |\  |/~~\                    ;
;=                      |--|   || \ ||     |   | |    || \ |`--.                    ;
;=                      |   \_/ |  \| \__  |  _|_ \__/ |  \|\__/                    ;
;===================================================================================;
    ;------------------------------------------------------------ Tab
        tabLeft() {
            send ^+{tab}
        }

        tabRight() {
            send ^{tab}
        }

    ;------------------------------------------------------------ Window Move
        CenterWindow() {
            WinGetTitle, WinTitle, A
            WinMove, %WinTitle%,, A_ScreenWidth/2-(A_ScreenWidth*0.40)/2, (A_ScreenHeight*1.50)/5, A_ScreenWidth*0.40, A_ScreenHeight-A_ScreenHeight/3
        }

    ;------------------------------------------------------------ Open / Minimize / Restore Program
        openMinimizeProgram(programName, programNameExe, programClass, programPath, specialProgram, PID_ID) {
            if (programNameExe = "Explorer.exe") {
                WinGetTitle, Title, A
                if (Title = programName) {
                    WinMinimize, A
                } else {
                    folderFlag := false
                    WinGet, id, list, , , Program Manager

                    Loop, %id%
                    {
                        StringTrimRight,this_id, id%a_index%, 0
                        WinGetTitle, this_title, ahk_id %this_id%
                        if (this_title = programName) {
                            folderFlag := true
                            break
                        }
                    }

                    if (folderFlag) {
                        DllCall("SwitchToThisWindow", "UInt", this_id, "UInt", 1)
                        WinActivate, A
                    } else {
                        Run ::{20d04fe0-3aea-1069-a2d8-08002b30309d}\%programPath%
                        GroupAdd, rogerExplorers, ahk_class %programClass%
                        Sleep 20
                        WinActive("File Explorer")
                    }
                }
            } else {
                Process, Exist, %programNameExe%
                {
                    if (! errorLevel) {
                        if FileExist(programPath) {
                            Run, %programPath%
                            WinWait, %programName%, ,10
                            SetTitleMatchMode,2
                            DetectHiddenWindows, On
                            WinGet, winid, ID, %programName%
                            DllCall("SwitchToThisWindow", "UInt", winid, "UInt", 1)
                            WinActivate, A
                            WinGet, PID_ID, PID, A
                            Return PID_ID
                        } else {
                            MsgBox There is not such file: %programPath%
                            Return 0
                        }
                    } else {
                        IfWinActive ahk_class %programClass% ahk_exe %programNameExe%
                        {
                            if (!specialProgram) {
                                WinMinimize, ahk_pid %PID_ID%
                            }
                            Return 2
                        } else {
                            if (!specialProgram) {
                                SetTitleMatchMode,2
                                DetectHiddenWindows, On
                                WinGet, winid, ID, %programName%
                                DllCall("SwitchToThisWindow", "UInt", winid, "UInt", 1)
                                WinActivate, ahk_pid %PID_ID%
                            }
                            Return 1
                        }
                    }
                }
            }
        }

    ;------------------------------------------------------------ Close Task
        closeTask()
        {
            WinGet, appPID, PID, A
            WinGet, activeprocess, ProcessName, A

            if WinActive("ahk_exe explorer.exe") {
                GroupClose, rogerExplorers, A
            }
            else {
                WinClose, A
                sleep 2000
                Process, Exist, activeprocess
                if(!errorlevel)
                Process, Close, %appPID%
            }
        }

    ;------------------------------------------------------------ Close Tab or Close Window
        closeTabOrWindow() {
            programFlag := false
            programsArray := ["BCompare.exe", "sublime_text.exe", "chrome.exe", "iexplore.exe", "pythonw.exe", "Code.exe"]
            exceptionsArray := ["Adobe Premiere Pro.exe"]

            for index, element in programsArray {
                if WinActive("ahk_exe " + element)
                {
                ; MsgBox % "Element number " . index . " is " . element
                programFlag := true
                }
            }

            for index, element in exceptionsArray {
                if WinActive("ahk_exe " + element) {
                    Return
                }
            }

            if (programFlag = 1){
                send ^{w}
            } else {
                WinClose, A
            }
        }

    ;------------------------------------------------------------ Search Custom Image True / False / Do Nothing
        searchImage(imageName,x1,y1,x2,y2) {
            CoordMode, Pixel, Mouse
            CoordMode, ToolTip
            ImageSearch, FoundX, FoundY, %x1%, %y1%, %x2%, %y2%, *75 %A_WorkingDir%\Images\%imageName%.bmp

            if (ErrorLevel = 2) {
                msg = Your image either doesn't exist or isn't in this location.
                tooltip %msg%
                sleep 3000
                tooltip
                return "doNothing"
            } else if (ErrorLevel = 1) {
                ; msg = Image not found, check your coordinates x1,y1 (%x1%,%y1%) and x2,y2 (%x2%,%y2%).
                ; tooltip %msg%
                ; sleep 3000
                ; tooltip
                return false
            } else {
                ; msg = Found! Location %FoundX%x%FoundY%.
                ; tooltip %msg%
                ; sleep 2000
                ; tooltip
                return true
            }
        }

    ;------------------------------------------------------------ Search Custom Image Click True / False / Do Nothing
        searchImageClick(imageName,x1,y1,x2,y2) {
            CoordMode, Pixel, Mouse
            CoordMode, ToolTip
            ImageSearch, FoundX, FoundY, %x1%, %y1%, %x2%, %y2%, *75 %A_WorkingDir%\Images\%imageName%.bmp

            if (ErrorLevel = 2) {
                msg = Your image either doesn't exist or isn't in this location.
                tooltip %msg%
                sleep 5000
                tooltip
                return "doNothing"
            } else if (ErrorLevel = 1) {
                ; msg = Image not found, check your coordinates x1,y1 (%x1%,%y1%) and x2,y2 (%x2%,%y2%).
                ; tooltip %msg%
                ; sleep 5000
                ; tooltip
                return false
            } else {
                ; msg = Found! Location %FoundX%x%FoundY%.
                ; tooltip %msg%
                ; sleep 2000
                ; tooltip
                SendEvent {click %FoundX%, %Foundy%, Left}
                DllCall("SetCursorPos", "int", A_ScreenWidth/2, "int", A_ScreenHeight/2)
                return true
            }
        }

;===================================================================================;
;=                     |~~\|~~\ /~~\  /~~\|~~\  /\  |\  /|/~~\                      ;
;=                     |__/|__/|    ||  __|__/ /__\ | \/ |`--.                      ;
;=                     |   |  \ \__/  \__/|  \/    \|    |\__/                      ;
;===================================================================================;
    ;------------------------------------------------------------ Chrome
        #IfWinActive ahk_exe chrome.exe
            program := "ahk_exe chrome.exe"

            ; Win + T -------------------------------- New Tab
                #t::
                    Send ^{t}
                Return

            ; Win + L -------------------------------- Search Bar
                #l::
                    Send ^{e}
                Return

            ; Win + R -------------------------------- Hard Refresh
                #r::
                    Send ^{F5}
                Return

            ; Win + Alt + Left ----------------------- Previous Tab
                #!Left::
                    tabLeft()
                Return

            ; Win + Alt + Right ---------------------- Forward Tab
                #!Right::
                    tabRight()
                Return

            ; Win + Alt + Mouse Wheel ---------------- Mouse Wheel
                #!WheelLeft::
                    tabLeft()
                Return

                #!WheelRight::
                    tabRight()
                Return

                #!WheelUp::
                    tabLeft()
                Return

                #!WheelDown::
                    tabRight()
                Return
        #IfWinActive

    ;------------------------------------------------------------ Explorer
        #IfWinActive ahk_exe explorer.exe
            program := "ahk_exe explorer.exe"

            ; Alt + 1 -------------------------------- File Explorer View as List
                !1::
                    SetTimer detect_key_released, 50
                    ControlFocus, DirectUIHWND3, A
                    Send ^+{5}
                Return

            ; Alt + 2 -------------------------------- File Explorer View as List + Size
                !2::
                    SetTimer detect_key_released, 50
                    ControlFocus, DirectUIHWND3, A
                    Send ^+{6}
                Return

            ; Alt + 3 -------------------------------- File Explorer View as Folder
                !3::
                    SetTimer detect_key_released, 50
                    ControlFocus, DirectUIHWND3, A
                    Send ^+{2}
                Return

            ; Alt + 4 -------------------------------- File Explorer View as Large Files
                !4::
                    SetTimer detect_key_released, 50
                    ControlFocus, DirectUIHWND3, A
                    Send ^+{1}
                Return

            ;----------------------------------------- Detect if Alt Key was released
                detect_key_released:
                    If !GetKeyState("LAlt", "P") {
                        Send {Tab}
                        SetTimer detect_key_released, off
                        ;MsgBox Alt released
                        Return
                    }
                    Return
        #IfWinActive

    ;------------------------------------------------------------ Visual Studio Code
        #IfWinActive ahk_exe Code.exe
            program := "ahk_exe Code.exe"

            ; Win + B -------------------------------- Toggle Explorer
                #b::
                    Send ^{b}
                Return

            ; Win + D -------------------------------- Select Word
                #d::
                    Send ^{d}
                Return

            ; Win + G -------------------------------- Go to Line
                #g::
                    Send ^{g}
                Return

            ; Win + H -------------------------------- Find and Replace Local
                #h::
                    Send ^{h}
                return

            ; Win + J -------------------------------- Toggle Terminal
                #j::
                    Send ^{j}
                return

            ; Win + L -------------------------------- Select Line
                #l::
                    Send ^{l}
                return

            ; Win + P -------------------------------- Files
                #p::
                    Send ^{p}
                Return
            ; Win + R -------------------------------- Run File
                #r::
                    Send ^{r}
                Return

            ; Win + S -------------------------------- Save File
                #s::
                    Send ^{s}
                Return

            ; Win + T -------------------------------- New File
                #t::
                    Send ^{n}
                Return

            ; Win + Z -------------------------------- Undo
                #z::
                    Send ^{z}
                Return

            ; Win + \ -------------------------------- Split Window
                #\::
                    Send ^{\}
                Return

            ; Win + Enter ---------------------------- New Line Below
                #Enter::
                    Send ^{Enter}
                Return

            ; Win + Shift + Enter -------------------- New Line Above
                #+Enter::
                    Send ^+{Enter}
                Return

            ; Win + Shift + K ------------------------ Delete Line
                #+k::
                    Send ^+{k}
                return

            ; Win + Shift + P ------------------------ Settings
                #+p::
                    Send ^+{p}
                Return

            ; Win + Shift + Z ------------------------ Redo
                #+z::
                    Send ^+{z}
                Return

            ; Win + Alt + Left ----------------------- Previous Tab
                #!Left::
                    Send ^!{Left}
                Return

            ; Win + Alt + Right ---------------------- Forward Tab
                #!Right::
                    Send ^!{Right}
                Return

            ; Win + Alt + Mouse Wheel ---------------- Mouse Wheel
                #!WheelLeft::
                    tabLeft()
                Return

                #!WheelRight::
                    tabRight()
                Return

                #!WheelUp::
                    tabLeft()
                Return

                #!WheelDown::
                    tabRight()
                Return
        #IfWinActive

;===================================================================================;
;=                           /~~\|~~|\  ||~~|~~\  /\  |                             ;
;=                          |  __|--| \ ||--|__/ /__\ |                             ;
;=                           \__/|__|  \||__|  \/    \|__                           ;
;===================================================================================;
    ; Win + A -------------------------------- Select All
        #a::
            Send ^{a}
        Return

    ; Win + C -------------------------------- Copy
        #c::
            Send ^{c}
        Return

    ; Win + F -------------------------------- Find
        #f::
            Send ^{f}
        Return

    ; Win + V -------------------------------- Paste
        #v::
            Send ^{v}
        Return

    ; Win + X -------------------------------- Cut
        #x::
            Send ^{x}
        Return

    ; Win + Tab ------------------------------ Alt + Tab
        #Tab::
            Send !{Tab}
        Return

    ; Win + Shift + Tab ---------------------- Alt + Shift + Tab
        #+Tab::
            Send !+{Tab}
        Return

    ; Alt + E --------------------------------------------------- Alt Tab File Explorer
        !e::
            IfWinNotExist, ahk_class CabinetWClass
            {
                Run ::{20d04fe0-3aea-1069-a2d8-08002b30309d}
                GroupAdd, rogerExplorers, ahk_class CabinetWClass
                WinActive("File Explorer")
            } else {
                WinGet, winid, ID, File Explorer
                DllCall("SwitchToThisWindow", "UInt", winid, "UInt", 1)
                GroupActivate, rogerExplorers, r
                WinActivate, A
            }
        Return

    ; Win + Alt + H --------------------------------------------- Open Startup Folder
        #!h::
            Run, C:\Users\%A_Username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
        Return

    ; Win + Alt + O --------------------------------------------- Process Name and CommandLine
        #!o::
            Gui, Add, ListView, x2 y0 w400 h500, Process Name|Command Line
            for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process")
                LV_Add("", process.Name, process.CommandLine)
            Gui, Show,, Process List
        Return

    ; Win + Alt + P --------------------------------------------- Get Process Path
        #!p::
            PID = 0
            WinGet, hWnd,, A
            DllCall("GetWindowThreadProcessId", "UInt", hWnd, "UInt *", PID)
            hProcess := DllCall("OpenProcess",  "UInt", 0x400 | 0x10, "Int", False
                                            ,  "UInt", PID)
            PathLength = 260*2
            VarSetCapacity(FilePath, PathLength, 0)
            DllCall("Psapi.dll\GetModuleFileNameExW", "UInt", hProcess, "Int", 0
                                        , "Str", FilePath, "UInt", PathLength)
            DllCall("CloseHandle", "UInt", hProcess)
            MsgBox, %FilePath%
        Return

    ; Win + Alt + R --------------------------------------------- Reload
        #!r::
            ;MsgBox, Reloaded
            SplashTextOn, [ Width, Height, Title, Text]
            SplashTextOn,500,200,AutoHotKey,Roger-That's Hotkey's been reloaded.
            Sleep 1000
            SplashTextOff
            Reload
        Return

    ; Win + E --------------------------------------------------- Open File Explorer Group
        #e::
            Run, explorer.exe
            GroupAdd, rogerExplorers, ahk_class CabinetWClass
            Sleep 50
            WinActive("File Explorer")
        Return

    ; Win + Q --------------------------------------------------- Close Program
        #q::
            closeTask()
        Return

    ; Win + W --------------------------------------------------- Close Window
        #w::
            closeTabOrWindow()
        Return

    ; Win + Numpad . -------------------------------------------- Run AutoHotKey Spy
        #NumPadDot::
            Run, C:\Program Files\AutoHotkey\WindowSpy.ahk
        Return

;===================================================================================;
;=                     |  |  |~|~|\  ||~~\  /~~\ |  |  |/~~\                        ;
;=                     |  |  | | | \ ||   ||    ||  |  |`--.                        ;
;=                      \/ \/ _|_|  \||__/  \__/  \/ \/ \__/                        ;
;===================================================================================;
    ; Win + 0 --------------------------------------------------- Window Resize 50%x50%% Screen Size
        #Numpad0::
            CenterWindow()
        Return

;===================================================================================;
;=       /~~ /~~\ |\  /||\  /||~~|\  |~~|~~|~~|~~\    /~~ /~~\ |~~\ |~~/~~\         ;
;=      |   |    || \/ || \/ ||--| \ |  |  |--|   |  |   |    ||   ||--`--.         ;
;=       \__ \__/ |    ||    ||__|  \|  |  |__|__/    \__ \__/ |__/ |__\__/         ;
;===================================================================================;
    ;----------------------------------------------------------- Key Map
        ; #InstallKeybdHook
        ; ^!t::
        ; 	KeyHistory
        ; Return

    ; Right Ctrl ----------------------------------------------- Double Pressed
        ; ~RControl::
        ;    if (A_PriorHotkey != "~RControl" or A_TimeSincePriorHotkey > 400) {
        ;       ; Too much time between presses, so this isn't a double-press.
        ;       KeyWait, RControl
        ;       return
        ;    }
        ;    MsgBox You double-pressed the right control key.
        ; return

    ; Win + Alt + T -------------------------------------------- Test
        #!t::
            ;---------------------------------------------- Get Active Window Size/Position
                ; WinGetActiveStats, Title, Width, Height, X, Y
                ; MsgBox, The active window "%Title%" is %Width% wide`, %Height% tall`, and positioned at %X%`,%Y%.

            ;---------------------------------------------- Mouse Move x1,y1 - x2,y2
                ; WinGetActiveStats, Title, Width, Height, X, Y
                ; x1 := 0
                ; y1 := 0
                ; x2 := 300
                ; y2 := 80
                ; MouseMove, x1,y1
                ; Sleep, 1000
                ; MouseMove, x2,y2
                ; MsgBox, "position" %x1% "x" %Y% " - " %Width% "x" %y2%

            ;---------------------------------------------- Get Book Online
                ; Loop, 540
                ; {
                ;    if (A_Index < 8) {
                ;       SendEvent {click 666,13}
                ;    } else if (A_Index >= 8 and A_Index < 100) {
                ;       SendEvent {click 673,13}
                ;    } else {
                ;       SendEvent {click 679,12}
                ;    }
                ;    Sleep 100
                ;    MouseMove, 800,13
                ;    Sleep 3000
                ;    Send {PrintScreen}
                ;    Sleep 500
                ;    Send {Enter}
                ;    Sleep 1000
                ; }

            ;---------------------------------------------- Find Folder
                ; Loops through all programs and open folder to check if the there is one named Downloads open
                ; WinGet, id, list, , , Program Manager
                ; Loop, %id%
                ; {
                ;    StringTrimRight,this_id, id%a_index%, 0
                ;    WinGetTitle, this_title, ahk_id %this_id%
                ;    if (this_title = "Downloads")
                ;    {
                ;       MsgBox, %this_title%
                ;       break
                ;    }
                ; }

            ;---------------------------------------------- Close Everything
                ; WinGet, id, list, , , Program Manager
                ; Loop, %id%
                ; {
                ;   StringTrimRight,this_id, id%a_index%, 0
                ;   WinGetTitle, this_title, ahk_id %this_id%
                ;   if !WinActive("ahk_exe WhatsApp.exe"){
                ;     ;MsgBox, %this_title%
                ;     winclose,%this_title%
                ;   }
                ; }

            ;---------------------------------------------- Window Hide - Window Show
                ; programName    := "WhatsApp"
                ; programNameExe := "WhatsappTray.exe"
                ; programClass   := "Chrome_WidgetWin_1"
                ; WinHide ahk_class %programClass% ;ahk_exe %programNameExe%
                ; Sleep, 3000
                ; WinShow ahk_class %programClass% ;ahk_exe %programNameExe%

                MouseMove,A_ScreenWidth/2, A_ScreenHeight/2, 100
        Return
