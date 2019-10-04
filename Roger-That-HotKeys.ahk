#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;===================================================================================;
;               _    _   _  ___        ___  ___  ___   _          __                ;
;              | \  |_  |_   |   |\ |   |    |    |   / \  |\ |  (_                 ;
;              |_/  |_  |   _|_  | \|  _|_   |   _|_  \_/  | \|  __)                ;
;===================================================================================;
   ; # - Windows key 
   ; ! - Alt 
   ; ^ - Ctrl 
   ; + - Shift 
   ; & - An ampersand may be used between any two keys or mouse buttons to combine them into a custom hotkey
   ; https://www.autohotkey.com/docs/Hotkeys.htm

;===================================================================================;
;                                  ___   _      _                                   ;
;                        /\   | |   |   / \    |_)  | |  |\ |                       ;
;                       /--\  |_|   |   \_/    | \  |_|  | \|                       ;
;===================================================================================;
   ;----------------------------------------------------------- Mouse Position
      ; #Persistent
      ; SetTimer, WatchCursor, 100
      ; return

      ; WatchCursor:
      ; MouseGetPos, xpos, ypos, id, control
      ; ToolTip, X%xpos% Y%ypos%
      ; return
   ;----------------------------------------------------------- Mouse Over Info
      ; #Persistent
      ; SetTimer, WatchCursor, 100
      ; return

      ; WatchCursor:
      ; MouseGetPos, xpos, ypos, id, control
      ; WinGetTitle, title, ahk_id %id%
      ; WinGetClass, class, ahk_id %id%
      ; ToolTip, X%xpos% Y%ypos% ahk_id %id%`nahk_class %class%`n%title%`nControl: %control%
      ; return

;===================================================================================;
;                    _              _  ___  ___   _          __                     ;
;                   |_  | |  |\ |  /    |    |   / \  |\ |  (_                      ;
;                   |   |_|  | \|  \_   |   _|_  \_/  | \|  __)                     ;
;===================================================================================;
   ;----------------------------------------------------------- Adobe Premiere
      effects(item) { 
         BlockInput, SendAndMouse
         BlockInput, On
         SetKeyDelay, 0
         MouseGetPos, xpos, ypos
         ControlGetPos, X, Y, Width, Height, Edit1, ahk_class Premiere Pro
         MouseMove, X-25, Y+611, 0
         sleep 10
         MouseClick, left, , , 1
         sleep 10
         Send +{BackSpace}
         sleep 10
         Send %item%
         sleep 10
         MouseMove, 30, 45, 0 , R
         MouseClickDrag, left, , , %xpos%, %ypos%, 0
         BlockInput, off
      }
   ;----------------------------------------------------------- Tab
      tabLeft()
      {
         send ^+{tab}
      }

      tabRight()
      {
         send ^{tab}
      }
   ;----------------------------------------------------------- Window Move
      CenterWindow(WinTitle)
      {
       ;WinGetPos,,, Width, Height, %WinTitle%
       WinMove, %WinTitle%,, A_ScreenWidth/2-(A_ScreenWidth*0.40)/2, A_ScreenHeight/5, A_ScreenWidth*0.40, A_ScreenHeight-A_ScreenHeight/3
       ;WinMaximize, A
      }
   ;----------------------------------------------------------- Open / Hide / Restore Program
      ; openHideProgram(programName, programNameExe, programClass, programPath) 
      ; {
      ;    if FileExist(programPath) {
      ;       Process, wait, %programNameExe%,1
      ;       NewPID = %ErrorLevel%
      ;       if NewPID = 0
      ;       {
      ;          Run, %programPath%
      ;          WinWait, %programName%, ,5
      ;          ; Sleep 100
      ;          ; WinActive(%programName%)
      ;          ; CenterWindow(%programName%)
      ;          WinShow ahk_class %programClass% ahk_exe %programNameExe%
      ;          SetTitleMatchMode,2
      ;          DetectHiddenWindows, On
      ;          IfWinExist, %programName%
      ;          {
      ;             WinGet, winid, ID, %programName%
      ;             DllCall("SwitchToThisWindow", "UInt", winid, "UInt", 1)
      ;             WinActivate, A
      ;          }
      ;       }
      ;       else 
      ;       {
      ;          IfWinExist ahk_class %programClass% ahk_exe %programNameExe%
      ;          {
      ;             if WinActive(ahk_class %programClass%)
      ;                WinHide
      ;             else
      ;             {
      ;                WinShow ahk_class %programClass% ahk_exe %programNameExe%
      ;                SetTitleMatchMode,2
      ;                DetectHiddenWindows, On
      ;                IfWinExist, %programName%
      ;                {
      ;                   WinGet, winid, ID, %programName%
      ;                   DllCall("SwitchToThisWindow", "UInt", winid, "UInt", 1)
      ;                   WinActivate, A
      ;                }
      ;             }
      ;          }
      ;          else 
      ;          {
      ;             WinShow ahk_class %programClass% ahk_exe %programNameExe%
      ;             SetTitleMatchMode,2
      ;             DetectHiddenWindows, On
      ;             IfWinExist, %programName%
      ;             {
      ;                WinGet, winid, ID, %programName%
      ;                DllCall("SwitchToThisWindow", "UInt", winid, "UInt", 1)
      ;                WinActivate, A
      ;             }
      ;          }
      ;       }
      ;    }
      ;    else {
      ;       MsgBox There is not such file: %programPath%
      ;    }
      ; }
   ;----------------------------------------------------------- Open / Minimize / Restore Program
      openMinimizeProgram(programName, programNameExe, programClass, programPath, specialProgram) 
      {
         if (programNameExe = "Explorer.exe")
         {
            WinGetTitle, Title, A
            if (Title = programName)
            {
               WinMinimize, A
            }
            else {
               folderFlag := false
               WinGet, id, list, , , Program Manager     
               Loop, %id%     
               {     
                  StringTrimRight,this_id, id%a_index%, 0     
                  WinGetTitle, this_title, ahk_id %this_id%
                  if (this_title = programName)
                  {    
                     folderFlag := true
                     break     
                  }         
               }
               if (folderFlag)
               {
                  DllCall("SwitchToThisWindow", "UInt", this_id, "UInt", 1)
                  WinActivate, A
               }
               else 
               {
                  Run ::{20d04fe0-3aea-1069-a2d8-08002b30309d}\%programPath%
                  GroupAdd, rogerExplorers, ahk_class %programClass%
                  Sleep 20
                  WinActive("File Explorer")
               }
            }
         }
         else 
         {
            if FileExist(programPath) {
               Process, wait, %programNameExe%,1
               NewPID = %ErrorLevel%
               if NewPID = 0
               {
                  Run, %programPath%
                  WinWait, %programName%, ,10
                  WinShow ahk_class %programClass% ahk_exe %programNameExe%
                  SetTitleMatchMode,2
                  DetectHiddenWindows, On
                  IfWinExist, %programName%
                  {
                     WinGet, winid, ID, %programName%
                     DllCall("SwitchToThisWindow", "UInt", winid, "UInt", 1)
                     WinActivate, A
                     Sleep, 100
                     WinMaximize, A
                  }
               }
               else 
               {
                  IfWinExist ahk_class %programClass% ahk_exe %programNameExe%
                  {
                     if WinActive(ahk_class %programClass%)
                     {
                        if (specialProgram)
                        {
                           WinClose, ahk_class %programClass% ahk_exe %programNameExe%
                        } 
                        else
                        {
                           WinMinimize, A
                        } 
                     }
                     else
                     {
                        if (specialProgram = true){
                           Run, %programPath%
                           WinWait, %programName%, ,10
                        }
                        else
                        {
                           WinShow ahk_class %programClass% ahk_exe %programNameExe%
                           SetTitleMatchMode,2
                           DetectHiddenWindows, On
                           IfWinExist, %programName%
                           {
                              WinGet, winid, ID, %programName%
                              DllCall("SwitchToThisWindow", "UInt", winid, "UInt", 1)
                              WinActivate, A
                              Sleep, 100
                              WinMaximize, A
                           }
                        }
                     }
                  }
                  else 
                  {
                     if (specialProgram = true){
                        Run, %programPath%
                        WinWait, %programName%, ,10
                     }
                     else
                     {
                        WinShow ahk_class %programClass% ahk_exe %programNameExe%
                        SetTitleMatchMode,2
                        DetectHiddenWindows, On
                        IfWinExist, %programName%
                        {
                           WinGet, winid, ID, %programName%
                           DllCall("SwitchToThisWindow", "UInt", winid, "UInt", 1)
                           WinActivate, A
                           Sleep, 100
                           WinMaximize, A
                        }
                     }
                  }
               }
            }
            else {
               MsgBox There is not such file: %programPath%
            }
         }
      }
   ;----------------------------------------------------------- Window Minimize
      ToggleWinMinimize(TheWindowTitle)
      {
         SetTitleMatchMode,2
         DetectHiddenWindows, Off
         IfWinActive, %TheWindowTitle%
         {
            WinMinimize, %TheWindowTitle%
         }
         Else
         {
            IfWinExist, %TheWindowTitle%
            {
               WinGet, winid, ID, %TheWindowTitle%
               DllCall("SwitchToThisWindow", "UInt", winid, "UInt", 1)
               WinActivate, %TheWindowTitle%
            }
         }
         Return
      }
   ;----------------------------------------------------------- Close Task
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
   ;----------------------------------------------------------- Close Tab or Close Window
      closeTabOrWindow()
      {
         programFlag := false
         programsArray := ["BCompare.exe", "sublime_text.exe", "chrome.exe", "iexplore.exe", "pythonw.exe", "Code.exe"]
         exceptionsArray := ["Adobe Premiere Pro.exe"]
         for index, element in programsArray 
         {
            if WinActive("ahk_exe " + element) 
            {
               ; MsgBox % "Element number " . index . " is " . element
               programFlag := true
            }
         }
         for index, element in exceptionsArray
         {
            if WinActive("ahk_exe " + element) 
            {
               return
            }
         }
         if programFlag = 1 
         {
            send ^{w}
         }
         else 
         {
            WinClose, A
         }
      }
   ;----------------------------------------------------------- Custom Image True/False/doNothing
      SearchImage(imageName,x1,y1,x2,y2)
      {
         WinGetActiveStats, Title, Width, Height, X, Y
         ; MsgBox The active window "%Title%" is %Width% wide`, %Height% tall`, and positioned at %X%`,%Y%.
         if (X = -8 && Y = -8) {
            X := X + 8   ;Position X = 0
            Y := Y + 8   ;Position Y = 0
         }
         if (x2 = 0) {
            x2 := Width
         }
         if (y2 = 0) {
            y2 := Height
         }
         ; MsgBox INIT X%x1%Y%y1% FINAL X%x2%Y%y2%
         ImageSearch, FoundX, FoundY, %x1%, %y1%, %x2%, %y2%, %A_WorkingDir%\Images\%imageName%.bmp
         if ErrorLevel = 2
         {
            MsgBox Your image either doesn't exist or isn't in this location.
            return "doNothing"
         }
         else if ErrorLevel = 1
         {
            ; tooltip Image could not be found on the screen.
            ; sleep 2000
            ; tooltip
            return false
         }
         else
         {
            ; tooltip Found! Location %FoundX%x%FoundY%.
            ; sleep 2000
            ; tooltip
            return true
         }
      }

;===================================================================================;
;                      _    _    _    __   _                __                      ;
;                     |_)  |_)  / \  /__  |_)   /\   |\/|  (_                       ;
;                     |    | \  \_/  \_|  | \  /--\  |  |  __)                      ;
;===================================================================================;
   ;----------------------------------------------------------- Adobe Premiere
      #IfWinActive ahk_exe Adobe Premiere Pro.exe
      ;---------------------------------------- Scroll Speed
         #NoEnv
         #SingleInstance
         #MaxHotkeysPerInterval 120
         Process, Priority, , H
         SendMode Input
         #SingleInstance force

         ; Show scroll velocity as a tooltip while scrolling. 1 or 0.
         tooltips := 0

         ; The length of a scrolling session.
         ; Keep scrolling within this time to accumulate boost.
         ; Default: 500. Recommended between 400 and 1000.
         timeout := 600

         ; If you scroll a long distance in one session, apply additional boost factor.
         ; The higher the value, the longer it takes to activate, and the slower it accumulates.
         ; Set to zero to disable completely. Default: 30.
         boost := 60

         ; Spamming applications with hundreds of individual scroll events can slow them down.
         ; This sets the maximum number of scrolls sent per click, i.e. max velocity. Default: 60.
         limit := 60

         ; Runtime variables. Do not modify.
         distance := 0
         vmax := 1

         ; Key bindings
         WheelUp::    Goto Scroll
         WheelDown::  Goto Scroll
         #WheelUp::   Suspend
         #WheelDown:: Goto Quit

         Scroll:
            t := A_TimeSincePriorHotkey
            if (A_PriorHotkey = A_ThisHotkey && t < timeout) {
               ; Remember how many times we've scrolled in the current direction
               distance++
               ; Calculate acceleration factor using a 1/x curve
               v := (t < 80 && t > 1) ? (250.0 / t) - 1 : 1
               ; Apply boost
               if (boost > 1 && distance > boost) {
                  ; Hold onto the highest speed we've achieved during this boost
                  if (v > vmax)
                     vmax := v
                  else
                     v := vmax

                  v *= distance / boost
               }
               ; Validate
               v := (v > 1) ? ((v > limit) ? limit : Floor(v)) : 1
               if (v > 1 && tooltips)
                  QuickToolTip("×"v, timeout)
               MouseClick, %A_ThisHotkey%, , , v
            }
            else {
               ; Combo broken, so reset session variables
               distance := 0
               vmax := 1
               MouseClick %A_ThisHotkey%
            }
            return

         Quit:
            QuickToolTip("Exiting Accelerated Scrolling...", 1000)
            Sleep 1000
            ExitApp

         QuickToolTip(text, delay) {
            ToolTip, %text%
            SetTimer ToolTipOff, %delay%
            return

            ToolTipOff:
            SetTimer ToolTipOff, Off
            ToolTip
            return
         }
      ;Alt + B -------------------------------- Camera Blur 6%
         !b::
            effects("Camera Blur 6%")
         Return
      ;Alt + C -------------------------------- Split Clip
         !c::
            Send ^{k}
         return
      ;Alt + D -------------------------------- Delete Clip
         !d::
            Send {d}
            Send !{Backspace}
         Return
      ;Alt + R -------------------------------- Speed/Duration
         !r::
            Send ^{r}
         Return
      ;Alt + S -------------------------------- Video Size 71%
         !s::
            effects("Video Size 71%")
         Return
      ;Alt + P -------------------------------- Photo Size 48% Zoom
         !p::
            effects("Photo Size 48% Zoom")
         Return
      #IfWinActive
   ;----------------------------------------------------------- Spyder Phyton
      #IfWinActive ahk_exe pythonw.exe
         program := "ahk_exe pythonw.exe"
         ;Alt + N/T ------------------------------ Spyder New Tab
            !n::
            !t::
               Send ^{n}
            Return
         ;Alt + C -------------------------------- Clear Console and Run
            !c:: 
               Send ^{l}
               Sleep 500
               Send {F5}
            Return
         ;Alt + R -------------------------------- Reload 
            !r:: 
               send {F5}
            Return
      #IfWinActive
   ;----------------------------------------------------------- Chrome
      #IfWinActive ahk_exe chrome.exe
         program := "ahk_exe chrome.exe"
         ;Alt + T -------------------------------- Chrome New Tab
            !t::
               Send ^{t}
            Return
         ;Alt + S -------------------------------- Search Bar 
            !s:: 
               Send ^{e}
            Return
         ;Alt + R -------------------------------- Reload 
            !r:: 
               Send {F5}
            Return
         ;Alt + Arrow Left ----------------------- Arrow Left - Chance Previous Tab
            !Left::
               tabLeft()
            Return
         ;Alt + Arrow Right ---------------------- Arrow Right - Chance Next Tab
            !Right::
               tabRight()
            Return
         ;Alt + Mouse Wheel ---------------------- Mouse Wheel
            !WheelLeft::
               tabLeft()
            Return

            !WheelRight::
               tabRight()
            Return

            !WheelUp::
               tabLeft()
            Return

            !WheelDown::
               tabRight()
            Return
      #IfWinActive
   ;----------------------------------------------------------- Explorer
      #IfWinActive ahk_exe explorer.exe
         program := "ahk_exe explorer.exe"
         ;Alt + 1 -------------------------------- File Explorer View as List
            !1::
               SetTimer detect_key_released, 50	
               WinActive(program)
               Send ^+{5}
            Return
         ;Alt + 2 -------------------------------- File Explorer View as List + Size
            !2::
               SetTimer detect_key_released, 50	
               WinActive(program)
               Send ^+{6}
            Return
         ;Alt + 3 -------------------------------- File Explorer View as Folder
            !3::
               SetTimer detect_key_released, 50
               WinActive(program)
               Send ^+{2}
            Return
         ;---------------------------------------- Detect if Alt Key was released
            detect_key_released:
               If !GetKeyState("LAlt", "P") {
                  Send {Tab}
                  SetTimer detect_key_released, off
                  ;MsgBox Alt released
                Return
               }
            Return
      #IfWinActive
   ;----------------------------------------------------------- Sublime Text
      #IfWinActive ahk_exe sublime_text.exe
         program := "ahk_exe sublime_text.exe"
         ;Alt + B -------------------------------- Project Folder
            !b::
               Send ^{b}
            Return
         ;Alt + F -------------------------------- Find / Find and Replace in Folder 
            !f::
               ; imageName = Sublime-Search-001
               ; statusSearch := SearchImage(imageName,0,720,0,0)
               ; if (statusSearch = true) {
               ;    Send {ESC}
               ; } else if (statusSearch = false) {
                  Send ^+{f}
               ; }
            return
         ;Alt + G -------------------------------- Go to Line
            !g::
               Send ^{g}
            return
         ;Alt + T -------------------------------- New File
            !t::
               Send ^{n}
            Return
         ;Alt + Arrow Left ----------------------- Arrow Left - Chance Previous Tab
            !Left::
               tabLeft()
            Return
         ;Alt + Arrow Right ---------------------- Arrow Right - Chance Next Tab
            !Right::
               tabRight()
            Return
         ;Alt + Mouse Wheel ---------------------- Mouse Wheel
            !WheelLeft::
               tabLeft()
            Return

            !WheelRight::
               tabRight()
            Return

            !WheelUp::
               tabLeft()
            Return

            !WheelDown::
               tabRight()
            Return
         ;Ctrl + F -------------------------------- Find
            ^f::
               ; imageName = Sublime-Search-002
               ; statusSearch := SearchImage(imageName,0,720,0,0)
               ; if (statusSearch = true) {
               ;    Send {ESC}
               ; } else if (statusSearch = false) {
                  Send ^{f}
               ; }
            return
      #IfWinActive
   ;----------------------------------------------------------- Visual Studio Code
      #IfWinActive ahk_exe Code.exe
         program := "ahk_exe Code.exe"
         ;Alt + B -------------------------------- Project Folder
            !b::
               imageName = VS-Code-Explorer
               statusSearch := SearchImage(imageName,0,35,0,110)
               if (statusSearch = true) {
                  Send ^{b}
               } else if (statusSearch = false) {
                  Send ^+{e}
               }
            Return
         ;Alt + F -------------------------------- Find / Find and Replace in Folder 
            !f::
               imageName = VS-Code-Search-001
               statusSearch := SearchImage(imageName,0,35,0,110)
               if (statusSearch = true) {
                  Send ^{b}
               } else if (statusSearch = false) {
                  Send ^+{f}
               }
            return
         ;Alt + G -------------------------------- Go to Line
            !g::
               Send ^{g}
            return
         ;Alt + H -------------------------------- Find and Replace Local
            !h::
               imageName = VS-Code-Search-001
               statusSearch := SearchImage(imageName,0,35,0,110)
               if (statusSearch = true) {
                  Send ^{b}
               } else if (statusSearch = false) {
                  Send ^+{h}
               }
            return
         ;Alt + T -------------------------------- New File
            !t::
               Send ^{n}
            Return
         ;Alt + Arrow Left ----------------------- Arrow Left - Chance Previous Tab
            !Left::
               tabLeft()
            Return
         ;Alt + Arrow Right ---------------------- Arrow Right - Chance Next Tab
            !Right::
               tabRight()
            Return
         ;Alt + Mouse Wheel ---------------------- Mouse Wheel
            !WheelLeft::
               tabLeft()
            Return

            !WheelRight::
               tabRight()
            Return

            !WheelUp::
               tabLeft()
            Return

            !WheelDown::
               tabRight()
            Return

      #IfWinActive
   ;----------------------------------------------------------- WhatsApp
      #IfWinActive ahk_exe WhatsApp.exe
         program := "ahk_exe WhatsApp.exe"
         ;Alt + Arrow Left ----------------------- Arrow Left - Chance Previous Tab
            !Left::
               tabLeft()
            Return
         ;Alt + Arrow Right ---------------------- Arrow Right - Chance Next Tab
            !Right::
               tabRight()
            Return
         ;Alt + Mouse Wheel ---------------------- Mouse Wheel
            !WheelLeft::
               tabLeft()
            Return

            !WheelRight::
               tabRight()
            Return

            !WheelUp::
               tabLeft()
            Return

            !WheelDown::
               tabRight()
            Return
      #IfWinActive
   ;----------------------------------------------------------- Telegram
      #IfWinActive ahk_exe Telegram.exe
         program := "ahk_exe Telegram.exe"
         ;Alt + Arrow Left ----------------------- Arrow Left - Chance Previous Tab
            !Left::
               tabLeft()
            Return
         ;Alt + Arrow Right ---------------------- Arrow Right - Chance Next Tab
            !Right::
               tabRight()
            Return
         ;Alt + Mouse Wheel ---------------------- Mouse Wheel
            !WheelLeft::
               tabLeft()
            Return

            !WheelRight::
               tabRight()
            Return

            !WheelUp::
               tabLeft()
            Return

            !WheelDown::
               tabRight()
            Return
      #IfWinActive

;===================================================================================;
;                          __   _         _   _                                     ;
;                         /__  |_  |\ |  |_  |_)   /\   |                           ;
;                         \_|  |_  | \|  |_  | \  /--\  |_                          ;
;===================================================================================;
   ;Alt + D --------------------------------------------------- Minimize Program
      !d::
         ; id := WinExist("A")
         ; WinMinimize, ahk_id %id%
         ; ; MsgBox % id
         ; ; sleep 1000
         ; ; WinRestore, ahk_id %id%
         WinMinimize, A
      return
   ;Alt + E --------------------------------------------------- Alt Tab File Explorer
      !e::
         IfWinNotExist, ahk_class CabinetWClass 
         {
            Run ::{20d04fe0-3aea-1069-a2d8-08002b30309d}
            GroupAdd, rogerExplorers, ahk_class CabinetWClass
            WinActive("File Explorer")
         }
         else 
         {
            WinGet, winid, ID, File Explorer
            DllCall("SwitchToThisWindow", "UInt", winid, "UInt", 1)
            GroupActivate, rogerExplorers, r
            WinActivate, A
         }
      Return
   ;Alt + H --------------------------------------------------- Open Startup Folder
      !h::
         Run, C:\Users\%A_Username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
      Return
   ;Alt + O --------------------------------------------------- Process Name and CommandLine
      !o::
         Gui, Add, ListView, x2 y0 w400 h500, Process Name|Command Line
         for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process")
             LV_Add("", process.Name, process.CommandLine)
         Gui, Show,, Process List
      return
   ;Alt + P --------------------------------------------------- Get Process Path
      !p::
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
      return
   ;Alt + Q --------------------------------------------------- Close Program - Task
      !q::				
         if WinActive("ahk_exe Adobe Premiere Pro.exe") {
         }	
         else {												
            closeTask()
         }
      return
   ;Alt + R --------------------------------------------------- Reload 
      !r:: 
         ;MsgBox, Reloaded
         SplashTextOn, [ Width, Height, Title, Text]
         SplashTextOn,500,200,AutoHotKey,Roger-That's Hotkey's been reloaded.
         Sleep 1000
         SplashTextOff
         Reload
      Return
   ;Alt + W --------------------------------------------------- Close Window
      !w::
           closeTabOrWindow()
      return
   ;Shift + Numpad - ------------------------------------------ Volume Up
      +NumpadAdd::
         SoundSet, +2
      Return
   ;Shift + Numpad + ------------------------------------------ Volume Down
      +NumpadSub::
         SoundSet, -2
      Return
   ;Shift + Numpad * ------------------------------------------ Volume Mute
      +NumpadMult::
         send {Volume_Mute}
      return
   ;Shift + WheelUp ------------------------------------------- Volume Up
      +WheelUp::
         SoundSet, +4
      Return
   ;Shift + WheelDown ----------------------------------------- Volume Down
      +WheelDown::
         SoundSet, -4
      Return
   ;Alt + Numpad . -------------------------------------------- Run AutoHotKey Spy
      !NumPadDot::
         Run, C:\Program Files\AutoHotkey\WindowSpy.ahk
      Return

;===================================================================================;
;                _                 _    _    _    __   _                            ;
;               |_)  | |  |\ |    |_)  |_)  / \  /__  |_)   /\   |\/|               ;
;               | \  |_|  | \|    |    | \  \_/  \_|  | \  /--\  |  |               ;
;===================================================================================;
   ;Win + C --------------------------------------------------- Run Chrome
      ; #c::
      ;    programName    := "Google Chrome"
      ;    programNameExe := "chrome.exe"
      ;    programClass   := "Chrome_WidgetWin_1"
      ;    programPath     =  C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk
      ;    openMinimizeProgram(programName, programNameExe, programClass, programPath, false)
      ; return
   ;Win + C --------------------------------------------------- GitHub Folder
      #c::
         programName    := "Codes"
         programNameExe := "Explorer.exe"
         programClass   := "CabinetWClass"
         programPath     =  D:\Codes
         openMinimizeProgram(programName, programNameExe, programClass, programPath, false)
      return
   ;Win + D --------------------------------------------------- Open Downloads Folder
      #d::
         programName    := "Downloads"
         programNameExe := "Explorer.exe"
         programClass   := "CabinetWClass"
         programPath     =  C:\Users\%A_Username%\Downloads
         openMinimizeProgram(programName, programNameExe, programClass, programPath, false)
      return
   ;Win + E --------------------------------------------------- Open File Explorer Group
      #e::
            Run, explorer.exe
            GroupAdd, rogerExplorers, ahk_class CabinetWClass
            Sleep 50
            WinActive("File Explorer")
      Return
   ;Win + Q --------------------------------------------------- Close Program - Task
      #q::																	
         closeTask()
      return
   ;Win + S --------------------------------------------------- Run Sublime
      #s::
         programName := "Sublime Text"
         programNameExe := "sublime_text.exe"
         programClass := "PX_WINDOW_CLASS"
         programPath = C:\Roger-That\Programs\Sublime Text 3 Portable\Sublime Text Build 3207\sublime_text.exe
         openMinimizeProgram(programName, programNameExe, programClass, programPath, false)
      Return
   ;Win + S---------------------------------------------------- Run Skype - Commented Out
      ; #n::
      ;    programName    := "Skype"
      ;    programNameExe := "Skype.exe"
      ;    programClass   := "Chrome_WidgetWin_1"
      ;    programPath     =  C:\Program Files (x86)\Microsoft\Skype for Desktop\Skype.exe
      ;    openMinimizeProgram(programName, programNameExe, programClass, programPath, true)
      ; Return
   ;Win + T --------------------------------------------------- Run Telegram
      #t::
         programName    := "Telegram"
         programNameExe := "Telegram.exe"
         programClass   := "Qt5QWindowIcon"
         programPath     =  C:\Users\%A_Username%\AppData\Roaming\Telegram Desktop\Telegram.exe
         openMinimizeProgram(programName, programNameExe, programClass, programPath, true)
      return
   ;Win + V --------------------------------------------------- Run Visio Studio Code - Commented Out
      #v::
         programName    := "Visual Studio Code"
         programNameExe := "Code.exe"
         programClass   := "Chrome_WidgetWin_1"
         programPath     =  C:\Users\%A_Username%\AppData\Local\Programs\Microsoft VS Code\Code.exe
         openMinimizeProgram(programName, programNameExe, programClass, programPath, false)
      Return
   ;Win + X --------------------------------------------------- Open Downloads Folder
      #x::
         programName    := "Roger-That"
         programNameExe := "Explorer.exe"
         programClass   := "CabinetWClass"
         programPath     =  D:\Roger-That
         openMinimizeProgram(programName, programNameExe, programClass, programPath, false)
      return
   ;Win + W --------------------------------------------------- Run WhatsApp
      ; #w::
      ;    programName    := "WhatsApp"
      ;    programNameExe := "WhatsappTray.exe"
      ;    programClass   := "Chrome_WidgetWin_1"
      ;    programPath     =  C:\Program Files (x86)\WhatsappTray\WhatsappTray.exe
      ;    openMinimizeProgram(programName, programNameExe, programClass, programPath, true)
      ; return
   ;Win + W --------------------------------------------------- Close Program - Task
      #w::																	
         closeTask()
      return

;===================================================================================;
;       _   _                _        ___   _   _      _   _    _    _   __         ;
;      /   / \  |\/|  |\/|  |_  |\ |   |   |_  | \    /   / \  | \  |_  (_          ;
;      \_  \_/  |  |  |  |  |_  | \|   |   |_  |_/    \_  \_/  |_/  |_  __)         ;
;===================================================================================;
   ;----------------------------------------------------------- Close Everything     
      ;#c::     
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
      ;return
   ;----------------------------------------------------------- Open Code Folder
      ;#c::
      ;	Run ::{20d04fe0-3aea-1069-a2d8-08002b30309d}\C:\Users\%A_Username%\Box Sync\Box\Arduino\Codes
      ;	GroupAdd, rogerExplorers, ahk_class CabinetWClass
      ;return
   ;----------------------------------------------------------- Key Map
      ; #InstallKeybdHook
      ; ^!t::
      ; 	KeyHistory
      ; Return
   ;----------------------------------------------------------- Find Fodler
      ; Loops through all programs and open folder to check if the there is one named Downloads open
      ; #!t::
      ;    WinGet, id, list, , , Program Manager
      ;    Loop, %id%
      ;    {
      ;      StringTrimRight,this_id, id%a_index%, 0
      ;      WinGetTitle, this_title, ahk_id %this_id%
      ;      if (this_title = "Downloads")
      ;      {
      ;        MsgBox, %this_title%
      ;        break
      ;      }
      ;    }
      ;    return
   ;Win + Alt + T --------------------------------------------- Test
      #!t::
         Loop, 540
         {
            if (A_Index < 8) {
               SendEvent {click 666,13}
            } else if (A_Index >= 8 and A_Index < 100) {
               SendEvent {click 673,13}
            } else {
               SendEvent {click 679,12}
            }
            Sleep 100
            MouseMove, 800,13
            Sleep 3000
            Send {PrintScreen}
            Sleep 500
            Send {Enter}
            Sleep 1000
         }
         return
   