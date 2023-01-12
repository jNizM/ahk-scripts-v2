; =============================================================================================================================================================
; Author ........: jNizM
; Released ......: 2016-06-20
; Modified ......: 2023-01-12
; Tested with....: AutoHotkey v2.0.2 (x64)
; Tested on .....: Windows 11 - 22H2 (x64)
; Function ......: GetModuleBaseAddr()
;
; Parameter(s)...: ProcessID - The process identifier of the process.
;                  ModuleName - The name of the module.
;
; Return ........: Retrieves the base address and size of the module in the context of the owning process.
; =============================================================================================================================================================

#Requires AutoHotkey v2.0


GetModuleBaseAddr(ProcessID, ModuleName)
{
    static TH32CS_SNAPMODULE   := 0x00000008
    static TH32CS_SNAPMODULE32 := 0x00000010
    
    if !(hSnapshot := DllCall("CreateToolhelp32Snapshot", "UInt", TH32CS_SNAPMODULE | TH32CS_SNAPMODULE32, "UInt", ProcessID, "Ptr"))
        throw OSError()

    MODULEENTRY32 := Buffer(A_PtrSize = 8 ? 568 : 548)
    NumPut("UInt", MODULEENTRY32.Size, MODULEENTRY32, 0)
    if !(DllCall("Module32First", "Ptr", hSnapshot, "Ptr", MODULEENTRY32))
    {
        DllCall("CloseHandle", "Ptr", hSnapshot)
        throw OSError()
    }

    BaseAddr := Map()
    while (DllCall("Module32Next", "Ptr", hSnapshot, "Ptr", MODULEENTRY32))
    {
        Module := StrGet(MODULEENTRY32.Ptr + (A_PtrSize = 8 ? 48 : 32), 256, "cp0")
        if (Module = ModuleName)
        {
            BaseAddr["BaseAddr"] := Format("{:#016x}", NumGet(MODULEENTRY32, (A_PtrSize = 8 ? 24 : 20), "uptr"))
            BaseAddr["BaseSize"] := NumGet(MODULEENTRY32, (A_PtrSize = 8 ? 32 : 24), "uint")
        }
    }

    DllCall("CloseHandle", "Ptr", hSnapshot)
    return BaseAddr
}


; =============================================================================================================================================================
; Example
; =============================================================================================================================================================

ModuleBaseAddr := GetModuleBaseAddr(16084, "user32.dll")
MsgBox "BaseAddr:`t" ModuleBaseAddr["BaseAddr"] "`nBaseSize:`t`t" ModuleBaseAddr["BaseSize"] " bytes"