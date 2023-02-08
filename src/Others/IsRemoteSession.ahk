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
    static WTS_CURRENT_SESSION       := -1
    static WTSSessionId              := 4
    static WTSIsRemoteSession        := 29

    if !(DllCall("wtsapi32\WTSQuerySessionInformation", "Ptr", WTS_CURRENT_SERVER_HANDLE, "UInt", WTS_CURRENT_SESSION, "Int", WTSSessionId, "Ptr*", &Buf := 0, "UInt*", &Size := 0))
    {
        DllCall("wtsapi32\WTSFreeMemory", "Ptr", Buf)
        throw OSError()
    }
    SessionId := NumGet(Buf, "UInt")
    DllCall("wtsapi32\WTSFreeMemory", "Ptr", Buf)

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