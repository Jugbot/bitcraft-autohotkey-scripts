#Requires AutoHotkey v2.0

/*
BoatSpam - Multiple methods for sending keyboard input to background windows

HOTKEYS:
- F3: Start the boat spam (finds BitCraft window and starts sending 'W' key)
- F4: Stop the boat spam
- 1-9, 0, -, =: Switch between different input methods

METHODS:
1. PostMessage: Standard Windows message posting (WM_KEYDOWN/UP)
2. SendMessage: Synchronous Windows message sending
3. ControlSend: AutoHotkey's standard background sending
4. ControlSend to Control: Sends to specific control within window
5. WM_CHAR: Sends character message directly
6. Multiple Messages: Combines KEYDOWN, CHAR, and KEYUP messages
7. Activate and Send: Briefly activates window and uses Send()
8. SendInput with Focus: Activates window and uses SendInput()
9. ScanCode: PostMessage with proper scan codes
10. ControlSend Raw: Uses {Raw} mode
11. ControlSend VK: Uses virtual key codes {vk57}
12. ControlSend SC: Uses scan codes {sc011}

Try different methods if one doesn't work. Games often filter certain types of input.
*/

SetControlDelay -1

; Global variables
bitcraftHWND := 0
currentMethod := 1
timerActive := false
ClickInBackground(winTitle, x, y) {
    if (!winTitle)
        winTitle := "A"
    ControlClick(
        "x" x " y" y,
        winTitle,
        , , ,
        "NA"
    )
}

; Method 1: PostMessage (current method)
MainLoop_PostMessage() {
    global bitcraftHWND
    OutputDebug("Method 1: PostMessage - Simulating 'W' key press...")
    ; Simulate 'W' key down
    PostMessage(0x100, 0x57, 0,, "ahk_id " bitcraftHWND) ; WM_KEYDOWN, 'W' key
    Sleep(50)
    ; Simulate 'W' key up
    PostMessage(0x101, 0x57, 0,, "ahk_id " bitcraftHWND) ; WM_KEYUP, 'W' key
    Sleep(Random(50, 100))
}

; Method 2: SendMessage
MainLoop_SendMessage() {
    global bitcraftHWND
    OutputDebug("Method 2: SendMessage - Simulating 'W' key press...")
    ; Send key down
    SendMessage(0x100, 0x57, 0,, "ahk_id " bitcraftHWND) ; WM_KEYDOWN, 'W' key
    Sleep(50)
    ; Send key up
    SendMessage(0x101, 0x57, 0,, "ahk_id " bitcraftHWND) ; WM_KEYUP, 'W' key
    Sleep(Random(50, 100))
}

; Method 3: ControlSend
MainLoop_ControlSend() {
    global bitcraftHWND
    OutputDebug("Method 3: ControlSend - Sending 'W' key...")
    try {
        ControlSend("w",, "ahk_id " bitcraftHWND)
    } catch as e {
        OutputDebug("ControlSend failed: " e.message)
    }
    Sleep(Random(50, 100))
}

; Method 4: ControlSend with specific control
MainLoop_ControlSendControl() {
    global bitcraftHWND
    OutputDebug("Method 4: ControlSend to specific control...")
    try {
        ; Try to find the main control (often the client area)
        controls := WinGetControls("ahk_id " bitcraftHWND)
        if (controls.Length > 0) {
            ; Try the first control (usually the main window)
            ControlSend("w", controls[1], "ahk_id " bitcraftHWND)
        } else {
            ; Fallback to window
            ControlSend("w",, "ahk_id " bitcraftHWND)
        }
    } catch as e {
        OutputDebug("ControlSend to control failed: " e.message)
    }
    Sleep(Random(50, 100))
}

; Method 5: WM_CHAR message
MainLoop_WMChar() {
    global bitcraftHWND
    OutputDebug("Method 5: WM_CHAR - Sending 'W' character...")
    PostMessage(0x102, 0x77, 0,, "ahk_id " bitcraftHWND) ; WM_CHAR, 'w' (lowercase)
    Sleep(Random(50, 100))
}

; Method 6: Multiple message types
MainLoop_Multiple() {
    global bitcraftHWND
    OutputDebug("Method 6: Multiple messages - Sending 'W' key...")
    ; Send WM_KEYDOWN
    PostMessage(0x100, 0x57, 0,, "ahk_id " bitcraftHWND)
    Sleep(10)
    ; Send WM_CHAR
    PostMessage(0x102, 0x77, 0,, "ahk_id " bitcraftHWND)
    Sleep(10)
    ; Send WM_KEYUP
    PostMessage(0x101, 0x57, 0,, "ahk_id " bitcraftHWND)
    Sleep(Random(50, 100))
}

; Method 7: Activate window briefly then send
MainLoop_ActivateAndSend() {
    global bitcraftHWND
    OutputDebug("Method 7: Activate and Send...")
    currentWindow := WinGetID("A")
    try {
        WinActivate("ahk_id " bitcraftHWND)
        Sleep(10)
        Send("w")
        Sleep(10)
        ; Restore previous window
        if (currentWindow != bitcraftHWND)
            WinActivate("ahk_id " currentWindow)
    } catch as e {
        OutputDebug("Activate and send failed: " e.message)
    }
    Sleep(Random(50, 100))
}

; Method 8: SendInput with focus
MainLoop_SendInput() {
    global bitcraftHWND
    OutputDebug("Method 8: SendInput with focus...")
    currentWindow := WinGetID("A")
    try {
        WinActivate("ahk_id " bitcraftHWND)
        SendInput("w")
        ; Restore previous window
        if (currentWindow != bitcraftHWND)
            WinActivate("ahk_id " currentWindow)
    } catch as e {
        OutputDebug("SendInput failed: " e.message)
    }
    Sleep(Random(50, 100))
}

; Method 9: Extended key codes with scan codes
MainLoop_ScanCode() {
    global bitcraftHWND
    OutputDebug("Method 9: ScanCode - Sending 'W' with scan code...")
    ; W key scan code is 0x11
    PostMessage(0x100, 0x57, 0x110001,, "ahk_id " bitcraftHWND) ; WM_KEYDOWN with scan code
    Sleep(50)
    PostMessage(0x101, 0x57, 0xC0110001,, "ahk_id " bitcraftHWND) ; WM_KEYUP with scan code
    Sleep(Random(50, 100))
}

; Method 10: ControlSend with Raw mode
MainLoop_ControlSendRaw() {
    global bitcraftHWND
    OutputDebug("Method 10: ControlSend Raw - Sending 'W' key...")
    try {
        ControlSend("{Raw}w",, "ahk_id " bitcraftHWND)
    } catch as e {
        OutputDebug("ControlSend Raw failed: " e.message)
    }
    Sleep(Random(50, 100))
}

; Method 11: ControlSend with virtual key
MainLoop_ControlSendVK() {
    global bitcraftHWND
    OutputDebug("Method 11: ControlSend VK - Sending 'W' key...")
    try {
        ControlSend("{vk57}",, "ahk_id " bitcraftHWND) ; VK_W = 0x57
    } catch as e {
        OutputDebug("ControlSend VK failed: " e.message)
    }
    Sleep(Random(50, 100))
}

; Method 12: ControlSend with scan code
MainLoop_ControlSendSC() {
    global bitcraftHWND
    OutputDebug("Method 12: ControlSend SC - Sending 'W' key...")
    try {
        ControlSend("{sc011}",, "ahk_id " bitcraftHWND) ; W scan code = 0x11
    } catch as e {
        OutputDebug("ControlSend SC failed: " e.message)
    }
    Sleep(Random(50, 100))
}

; Main loop function that calls the selected method
MainLoop() {
    global currentMethod
    switch currentMethod {
        case 1: MainLoop_PostMessage()
        case 2: MainLoop_SendMessage()
        case 3: MainLoop_ControlSend()
        case 4: MainLoop_ControlSendControl()
        case 5: MainLoop_WMChar()
        case 6: MainLoop_Multiple()
        case 7: MainLoop_ActivateAndSend()
        case 8: MainLoop_SendInput()
        case 9: MainLoop_ScanCode()
        case 10: MainLoop_ControlSendRaw()
        case 11: MainLoop_ControlSendVK()
        case 12: MainLoop_ControlSendSC()
        default: MainLoop_PostMessage()
    }
}

F2:: {
    global bitcraftHWND
    bitcraftHWND := WinExist("BitCraft")
    if 0 == bitcraftHWND {
        MsgBox("BitCraft window not found!")
        Return
    }
    WinActivate("ahk_id " bitcraftHWND)
    
    ; Send("{w Down}")

    Loop {
        WinGetPos(&mainX, &mainY, &mainW, &mainH, "BitCraft")
        ClickInBackground("BitCraft", mainW - 100, 130)
        Sleep(Random(300, 700))
        ClickInBackground("BitCraft", mainW - 160, 130)
        Sleep(Random(300, 700))
    }
}

F3:: {
    global bitcraftHWND, currentMethod, timerActive
    bitcraftHWND := WinExist("Genshin Impact")
    if 0 == bitcraftHWND {
        MsgBox("Genshin Impact window not found!")
        Return
    }
    
    if (!timerActive) {
        OutputDebug("Starting boat spam with method " currentMethod "...")
        SetTimer(MainLoop, 10)
        timerActive := true
    } else {
        OutputDebug("Boat spam already running...")
    }
}

; F4 to stop the spam
F4:: {
    global timerActive
    SetTimer(MainLoop, 0)
    timerActive := false
    OutputDebug("Boat spam stopped.")
}

; Number keys to switch methods (1-12)
1:: {
    global currentMethod := 1
    OutputDebug("Switched to Method 1: PostMessage")
}

2:: {
    global currentMethod := 2
    OutputDebug("Switched to Method 2: SendMessage")
}

3:: {
    global currentMethod := 3
    OutputDebug("Switched to Method 3: ControlSend")
}

4:: {
    global currentMethod := 4
    OutputDebug("Switched to Method 4: ControlSend with Control")
}

5:: {
    global currentMethod := 5
    OutputDebug("Switched to Method 5: WM_CHAR")
}

6:: {
    global currentMethod := 6
    OutputDebug("Switched to Method 6: Multiple Messages")
}

7:: {
    global currentMethod := 7
    OutputDebug("Switched to Method 7: Activate and Send")
}

8:: {
    global currentMethod := 8
    OutputDebug("Switched to Method 8: SendInput with Focus")
}

9:: {
    global currentMethod := 9
    OutputDebug("Switched to Method 9: ScanCode")
}

0:: {
    global currentMethod := 10
    OutputDebug("Switched to Method 10: ControlSend Raw")
}

-:: {
    global currentMethod := 11
    OutputDebug("Switched to Method 11: ControlSend VK")
}

=:: {
    global currentMethod := 12
    OutputDebug("Switched to Method 12: ControlSend SC")
}