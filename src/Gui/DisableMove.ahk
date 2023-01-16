; =============================================================================================================================================================
; Author ........: jNizM
; Released ......: 2017-04-13
; Modified ......: 2023-01-16
; Tested with....: AutoHotkey v2.0.2 (x64)
; Tested on .....: Windows 11 - 22H2 (x64)
; Function ......: GuiDisableMove()
;
; Parameter(s)...: Handle - Gui.Hwnd
;
; Return ........: Disables the GUI Move function.
; =============================================================================================================================================================

#Requires AutoHotkey v2.0


Main := Gui()
Main.OnEvent("Close", (*) => ExitApp)
Main.Show("w400 h300")
GuiDisableMove(Main.Hwnd)


GuiDisableMove(Handle)
{
    static SC_MOVE      := 0xF010
    static MF_BYCOMMAND := 0x00000000

    hMenu := DllCall("user32\GetSystemMenu", "Ptr", Handle, "Int", False, "Ptr")
    DllCall("user32\RemoveMenu", "Ptr", hMenu, "UInt", SC_MOVE, "UInt", MF_BYCOMMAND)
    return DllCall("user32\DrawMenuBar", "Ptr", Handle)
}


; =============================================================================================================================================================