; =============================================================================================================================================================
; Author ........: jNizM
; Released ......: 2017-04-13
; Modified ......: 2023-01-16
; Tested with....: AutoHotkey v2.0.2 (x64)
; Tested on .....: Windows 11 - 22H2 (x64)
; Function ......: GuiDisableCloseButton()
;
; Parameter(s)...: Handle - Gui.Hwnd
;
; Return ........: Disables the GUI Close Button.
; =============================================================================================================================================================

#Requires AutoHotkey v2.0


Main := Gui()
Main.OnEvent("Close", (*) => ExitApp)
Main.Show("w400 h300")
GuiDisableCloseButton(Main.Hwnd)


GuiDisableCloseButton(Handle)
{
    static SC_CLOSE    := 0xF060
    static MF_GRAYED   := 0x00000001
    static MF_DISABLED := 0x00000002

    hMenu := DllCall("user32\GetSystemMenu", "Ptr", Handle, "Int", False, "Ptr")
    DllCall("user32\EnableMenuItem", "Ptr", hMenu, "UInt", SC_CLOSE, "UInt", MF_GRAYED | MF_DISABLED)
    return DllCall("user32\DrawMenuBar", "Ptr", Handle)
}


; =============================================================================================================================================================