; =============================================================================================================================================================
; Author ........: jNizM
; Released ......: 2022-02-21
; Modified ......: 2023-02-08
; Tested with....: AutoHotkey v2.0.2 (x64)
; Tested on .....: Windows 11 - 22H2 (x64)
; Function ......: IsRemoteSession()
;
; Parameter(s)...: No parameters used
;
; Return ........: Returns TRUE that the current session is a remote session, and FALSE that the current session is a local session.
; =============================================================================================================================================================

#Requires AutoHotkey v2.0


IsRemoteSession()
{
    #DllLoad "wtsapi32.dll"

    static WTS_CURRENT_SERVER_HANDLE := 0
    static WTSIsRemoteSession        := 29
    static ProcessId                 := DllCall("kernel32\GetCurrentProcessId")

    ; retrieves the Remote Desktop Services session associated with a specified process
    if !(DllCall("kernel32\ProcessIdToSessionId", "UInt", ProcessId, "UInt*", &SessionId := 0))
        throw OSError()

    ; retrieves session information for the specified session on the specified Remote Desktop Session Host (RD Session Host)
    if !(DllCall("wtsapi32\WTSQuerySessionInformation", "Ptr", WTS_CURRENT_SERVER_HANDLE, "UInt", SessionId, "Int", WTSIsRemoteSession, "Ptr*", &Buf := 0, "UInt*", &Size := 0))
    {
        DllCall("wtsapi32\WTSFreeMemory", "Ptr", Buf)
        throw OSError()
    }
    IsRemoteSession := NumGet(Buf, "Int")
    DllCall("wtsapi32\WTSFreeMemory", "Ptr", Buf)

    return IsRemoteSession
}


; =============================================================================================================================================================
; Example
; =============================================================================================================================================================

MsgBox IsRemoteSession()