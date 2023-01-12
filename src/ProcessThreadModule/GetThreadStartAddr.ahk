; =============================================================================================================================================================
; Author ........: jNizM
; Released ......: 2016-06-20
; Modified ......: 2023-01-12
; Tested with....: AutoHotkey v2.0.2 (x64)
; Tested on .....: Windows 11 - 22H2 (x64)
; Function ......: GetThreadStartAddr()
;
; Parameter(s)...: ProcessID - The process identifier of the process.
;
; Return ........: Retrieves the start address of a thread.
; =============================================================================================================================================================

#Requires AutoHotkey v2.0


GetThreadStartAddr(ProcessID)
{
    #DllLoad "ntdll.dll"

    static TH32CS_SNAPTHREAD               := 0x00000004
    static THREAD_QUERY_INFORMATION        := 0x0040
    static ThreadQuerySetWin32StartAddress := 9

    if !(hSnapshot := DllCall("CreateToolhelp32Snapshot", "UInt", TH32CS_SNAPTHREAD, "UInt", ProcessID, "Ptr"))
        throw OSError()

    THREADENTRY32 := Buffer(28)
    NumPut("UInt", THREADENTRY32.Size, THREADENTRY32, 0)
    if !(DllCall("Thread32First", "Ptr", hSnapshot, "Ptr", THREADENTRY32))
    {
        DllCall("CloseHandle", "Ptr", hSnapshot)
        throw OSError()
    }

    StartAddr := Map()
    while (DllCall("Thread32Next", "Ptr", hSnapshot, "Ptr", THREADENTRY32))
    {
        OwnerProcessID := NumGet(THREADENTRY32, 12, "UInt")
        if (OwnerProcessID = ProcessID)
        {
            ThreadID := NumGet(THREADENTRY32, 8, "UInt")
            if !(hThread := DllCall("OpenThread", "UInt", THREAD_QUERY_INFORMATION, "Int", false, "UInt", ThreadID, "Ptr"))
                continue
            if (DllCall("ntdll\NtQueryInformationThread", "Ptr", hThread, "UInt", ThreadQuerySetWin32StartAddress, "Ptr*", &ThreadStartAddr := 0, "UInt", A_PtrSize, "UInt*", 0) != 0)
                continue
            StartAddr[ThreadID] := Format("{:#016x}", ThreadStartAddr)
            DllCall("CloseHandle", "Ptr", hThread)
        }
    }

    DllCall("CloseHandle", "Ptr", hSnapshot)
    return StartAddr
}


; =============================================================================================================================================================
; Example
; =============================================================================================================================================================

for k, v in GetThreadStartAddr(16084)
    MsgBox "ThreadID:`t" k "`nStartAddr:`t" v