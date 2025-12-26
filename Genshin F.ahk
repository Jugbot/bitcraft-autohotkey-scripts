#Requires AutoHotkey v2.0

toggle := false
timerInterval := 500
hwnd := 0

OutputDebug("Toggle with Alt+F")

SendFKey() {
    global hwnd, toggle
    if !hwnd {
        OutputDebug("Genshin Impact window not found!")
        return ToggleLoop()
    }
    if !WinActive(hwnd) {
        OutputDebug("Genshin Impact window is not active!")
        return ToggleLoop()
    }
    Send('F')
}

ToggleLoop() {
    global toggle, timerInterval, hwnd
    toggle := !toggle
    if toggle {
        OutputDebug("Activating window.")
        winTitle := "ahk_exe GenshinImpact.exe"
        WinActivate(winTitle)
        hwnd := WinWaitActive(winTitle)
        OutputDebug("Sending F key")
        SetTimer(SendFKey, timerInterval)
    }
    else {
        OutputDebug("Pausing")
        SetTimer(SendFKey, 0)
    }

}

!f::
{
    ToggleLoop()
}
