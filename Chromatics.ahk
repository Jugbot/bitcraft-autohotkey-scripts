#Requires AutoHotkey v2.0

isTimerOn := false

myTimer() {
    Click()
}

F1:: {
    global isTimerOn, myTimer
    if isTimerOn {
        SetTimer(myTimer, 0) ; Stop timer
        isTimerOn := false
    } else {
        SetTimer(myTimer, 10) ; Start timer
        isTimerOn := true
    }
}

