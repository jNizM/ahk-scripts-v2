; =============================================================================================================================================================
; Author ........: jNizM
; Released ......: 2017-01-10
; Modified ......: 2023-01-16
; Tested with....: AutoHotkey v2.0.2 (x64)
; Tested on .....: Windows 11 - 22H2 (x64)
; Function ......: IsProcessElevated()
;
; Parameter(s)...: ProcessID - The process identifier of the process.
;
; Return ........: Retrieves whether a token has elevated privileges.
; =============================================================================================================================================================

#Requires AutoHotkey v2.0


IsProcessElevated(ProcessID)
{
    static INVALID_HANDLE_VALUE              := -1
    static PROCESS_QUERY_INFORMATION         := 0x0400
    static PROCESS_QUERY_LIMITED_INFORMATION := 0x1000
    static TOKEN_QUERY                       := 0x0008
    static TOKEN_QUERY_SOURCE                := 0x0010
    static TokenElevation                    := 20

    hProcess := DllCall("OpenProcess", "UInt", PROCESS_QUERY_INFORMATION, "Int", False, "UInt", ProcessID, "Ptr")
    if (!hProcess) || (hProcess = INVALID_HANDLE_VALUE)
    {
        hProcess := DllCall("OpenProcess", "UInt", PROCESS_QUERY_LIMITED_INFORMATION, "Int", False, "UInt", ProcessID, "Ptr")
        if (!hProcess) || (hProcess = INVALID_HANDLE_VALUE)
            throw OSError()
    }

    if !(DllCall("advapi32\OpenProcessToken", "Ptr", hProcess, "UInt", TOKEN_QUERY | TOKEN_QUERY_SOURCE, "Ptr*", &hToken := 0))
    {
        DllCall("CloseHandle", "Ptr", hProcess)
        throw OSError()
    }

    if !(DllCall("advapi32\GetTokenInformation", "Ptr", hToken, "Int", TokenElevation, "UInt*", &IsElevated := 0, "UInt", 4, "UInt*", &Size := 0))
    {
        DllCall("CloseHandle", "Ptr", hToken)
        DllCall("CloseHandle", "Ptr", hProcess)
        throw OSError()
    }

    DllCall("CloseHandle", "Ptr", hToken)
    DllCall("CloseHandle", "Ptr", hProcess)
    return IsElevated
}


; =============================================================================================================================================================
; Example
; =============================================================================================================================================================

MsgBox IsProcessElevated(19256)