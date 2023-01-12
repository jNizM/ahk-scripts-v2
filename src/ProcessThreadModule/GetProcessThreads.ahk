; =============================================================================================================================================================
; Author ........: jNizM
; Released ......: 2016-06-20
; Modified ......: 2023-01-12
; Tested with....: AutoHotkey v2.0.2 (x64)
; Tested on .....: Windows 11 - 22H2 (x64)
; Function ......: GetProcessThreads()
;
; Parameter(s)...: ProcessID - The process identifier of the process.
;
; Return ........: Retrieves a list of all threads in a process.
; =============================================================================================================================================================

#Requires AutoHotkey v2.0


GetProcessThreads(ProcessID)
{
    static TH32CS_SNAPTHREAD := 0x00000004

    if !(hSnapshot := DllCall("CreateToolhelp32Snapshot", "UInt", TH32CS_SNAPTHREAD, "UInt", ProcessID, "Ptr"))
        throw OSError()

    THREADENTRY32 := Buffer(28)
    NumPut("UInt", THREADENTRY32.Size, THREADENTRY32, 0)
    if !(DllCall("Thread32First", "Ptr", hSnapshot, "Ptr", THREADENTRY32))
    {
        DllCall("CloseHandle", "Ptr", hSnapshot)
        throw OSError()
    }

    Threads := Array()
    while (DllCall("Thread32Next", "Ptr", hSnapshot, "Ptr", THREADENTRY32))
    {
        OwnerProcessID := NumGet(THREADENTRY32, 12, "UInt")
        if (OwnerProcessID = ProcessID)
        {
            Threads.Push(NumGet(THREADENTRY32, 8, "UInt"))
        }
    }

    DllCall("CloseHandle", "Ptr", hSnapshot)
    return Threads
}


; =============================================================================================================================================================
; Example
; =============================================================================================================================================================

Threads := GetProcessThreads(16084)
loop Threads.Length
    MsgBox Threads[A_Index]