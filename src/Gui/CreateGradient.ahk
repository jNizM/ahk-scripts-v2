; =============================================================================================================================================================
; Author(s) .....: jNizM, just me, SKAN
; Released ......: 2006-05-23
; Modified ......: 2023-01-16
; Tested with....: AutoHotkey v2.0.2 (x64)
; Tested on .....: Windows 11 - 22H2 (x64)
; Function ......: CreateGradient()
;
; Parameter(s)...: Handle - Picture.Hwnd
;                  Colors - Array of Colors
;
; Return ........: Creates a gradient bitmap for picture controls.
; =============================================================================================================================================================

#Requires AutoHotkey v2.0


Main := Gui()
Main.MarginX := 0
Main.MarginY := 0
PIC1 := Main.AddPicture("xm ym w400 h400 0x4E")
CreateGradient(PIC1.Hwnd, ["0x3399FF", "0xFF3399"]*)
Main.OnEvent("Close", ExitFunc)
Main.Show("AutoSize")


ExitFunc(*)
{
    if (hBITMAP)
        DllCall("gdi32\DeleteObject", "ptr", hBITMAP)
    ExitApp
}


CreateGradient(Handle, Colors*)
{
    static IMAGE_BITMAP        := 0
    static LR_COPYDELETEORG    := 0x00000008
    static LR_CREATEDIBSECTION := 0x00002000
    static STM_SETIMAGE        := 0x0172
    global hBITMAP

    ControlGetPos(,, &OutW, &OutW, Handle)
    Addr := Bits := Buffer(Colors.Length * 2 * 4)
    for each, Color in Colors
        Addr := NumPut("UInt", Color, "UInt", Color, Addr)

    hBITMAP := DllCall("gdi32\CreateBitmap", "Int", 2, "Int", Colors.Length, "UInt", 1, "UInt", 32, "Ptr", 0, "Ptr")
    hBITMAP := DllCall("user32\CopyImage", "Ptr", hBITMAP, "UInt", IMAGE_BITMAP, "Int", 0, "Int", 0, "UInt", LR_COPYDELETEORG | LR_CREATEDIBSECTION, "Ptr")
    DllCall("gdi32\SetBitmapBits", "Ptr", hBITMAP, "UInt", Bits.Size, "Ptr", Bits)
    hBITMAP := DllCall("user32\CopyImage", "Ptr", hBITMAP, "UInt", 0, "Int", OutW, "Int", OutW, "UInt", LR_COPYDELETEORG | LR_CREATEDIBSECTION, "Ptr")
    SendMessage(STM_SETIMAGE, IMAGE_BITMAP, hBitMAP, Handle)
    return true
}


; =============================================================================================================================================================