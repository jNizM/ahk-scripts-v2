; =============================================================================================================================================================
; Author ........: jNizM, lexikos
; Released ......: 2009-11-06
; Modified ......: 2023-01-16
; Tested with....: AutoHotkey v2.0.2 (x64)
; Tested on .....: Windows 11 - 22H2 (x64)
; Function ......: SetTaskbarProgress()
;
; Parameter(s)...: Handle - Gui.Hwnd
;                  Value  - in 0-100 %
;                  State  - see https://learn.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-itaskbarlist3-setprogressstate
;
; Return ........: Displays or updates a progress bar hosted in a taskbar button to show the specific percentage completed of the full operation.
; =============================================================================================================================================================

#Requires AutoHotkey v2.0


Main := Gui()
Main.MarginX := 15
Main.MarginY := 15
Main.SetFont("s9", "Segoe UI")

BT1 := Main.AddButton("xm ym w200", "Start")
BT1.OnEvent("Click", Start)

PG1 := Main.AddProgress("xm y+10 w200")

Main.OnEvent("Close", (*) => ExitApp)
Main.Show("AutoSize")


Start(GuiCtrl, *)
{
    static TBPF := Map("NOPROGRESS", 0, "INDETERMINATE", 1, "NORMAL", 2, "ERROR", 4, "PAUSED", 8)
    loop 100
    {
        PG1.Value := A_Index
        SetTaskbarProgress(Main.Hwnd, A_Index)
        Sleep 50
    }
}


SetTaskbarProgress(Handle, Value, State := 2)
{
    static CLSID_TaskbarList := "{56FDF344-FD6D-11D0-958A-006097C9A090}"
    static IID_ITaskbarList3 := "{EA1AFB91-9E28-4B86-90E9-9E9F8A5EEFAF}"
    static SetProgressValue  := 9
    static SetProgressState  := 10
    static ITaskbarList3     := false

    if !(ITaskbarList3)
        try ITaskbarList3 := ComObject(CLSID_TaskbarList, IID_ITaskbarList3)

    ComCall(SetProgressState, ITaskbarList3, "Ptr", Handle, "Int", State)
    ComCall(SetProgressValue, ITaskbarList3, "Ptr", Handle, "Int64", Value, "Int64", 100)
    return (ITaskbarList3 ? 0 : 1)
}


; =============================================================================================================================================================