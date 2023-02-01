; =============================================================================================================================================================
; Author ........: jNizM
; Released ......: 2016-07-07
; Modified ......: 2023-02-01
; Tested with....: AutoHotkey v2.0.2 (x64)
; Tested on .....: Windows 11 - 22H2 (x64)
; Function ......: GetProcessHandles()
;
; Parameter(s)...: ProcessID - The process identifier of the process.
;
; Return ........: Retrieves all Handles in the context of the owning process.
; =============================================================================================================================================================

#Requires AutoHotkey v2.0


GetProcessHandles(ProcessID)
{
    #DllLoad "advapi32.dll"
    #DllLoad "ntdll.dll"

    static PROCESS_DUP_HANDLE        := 0x0040
    static TOKEN_ADJUST_PRIVILEGES   := 0x0020
    static DUPLICATE_SAME_ACCESS     := 0x00000002
    static OBJECT_NAME_INFORMATION   := 1
    static OBJECT_TYPE_INFORMATION   := 2
    static hCurrentProcess           := DllCall("GetCurrentProcess", "Ptr")

    hToken   := OpenProcessToken(hCurrentProcess, TOKEN_ADJUST_PRIVILEGES)
    LUID     := LookupPrivilegeValue("SeDebugPrivilege")
    AdjustTokenPrivileges(hToken, LUID)
    CloseHandle(hToken)

    hProcess := OpenProcess(ProcessID, PROCESS_DUP_HANDLE)
    mHandles := SystemHandleInformation(ProcessID)
    ProcessHandles := Map()
    for i, v in mHandles
    {
        PH := Map()
        HandleValue := mHandles[i]["HandleValue"]
        if !(hDublicate := DuplicateObject(hProcess, hCurrentProcess, HandleValue, DUPLICATE_SAME_ACCESS))
            continue
        PH["Handle"] := HandleValue
        PH["Name"]   := QueryObject(hDublicate, OBJECT_NAME_INFORMATION)
        PH["Type"]   := QueryObject(hDublicate, OBJECT_TYPE_INFORMATION)
        PH["Path"]   := GetFinalPathNameByHandle(hDublicate)
        ProcessHandles[A_Index] := PH
        CloseHandle(hDublicate)
    }
    CloseHandle(hProcess)
    return ProcessHandles


    AdjustTokenPrivileges(hToken, LUID)
    {
        static SE_PRIVILEGE_ENABLED := 0x00000002

        TOKEN_PRIVILEGES := Buffer(16, 0)
        NumPut("UInt", 1, TOKEN_PRIVILEGES, 0)
        NumPut("Int64", LUID, TOKEN_PRIVILEGES, 4)
        NumPut("UInt", SE_PRIVILEGE_ENABLED, TOKEN_PRIVILEGES, 12)
        if !(DllCall("advapi32\AdjustTokenPrivileges", "Ptr", hToken, "Int", 0, "Ptr", TOKEN_PRIVILEGES, "UInt", TOKEN_PRIVILEGES.Size, "Ptr", 0, "Ptr", 0))
            return false
        return true
    }

    CloseHandle(hObject)
    {
        if (hObject)
            DllCall("CloseHandle", "Ptr", hObject)
    }

    DuplicateObject(hProcess, hCurrentProcess, Handle, Options)
    {
        static STATUS_SUCCESS := 0x00000000

        NT_STATUS := DllCall("ntdll\NtDuplicateObject", "Ptr", hProcess, "Ptr", Handle, "Ptr", hCurrentProcess, "Ptr*", &hDublicate := 0, "UInt", 0, "UInt", 0, "UInt", Options)
        if (NT_STATUS = STATUS_SUCCESS)
            return hDublicate
        return false
    }

    GetFinalPathNameByHandle(hFile)
    {
        Size := DllCall("GetFinalPathNameByHandleW", "Ptr", hFile, "Ptr", 0, "UInt", 0, "UInt", 0, "UInt")
        VarSetStrCapacity(&FilePath, Size)
        if !(DllCall("GetFinalPathNameByHandleW", "Ptr", hFile, "Str", FilePath, "UInt", Size, "UInt", 0, "UInt"))
            return
        return FilePath
    }

    LookupPrivilegeValue(Name)
    {
        if !(DllCall("advapi32\LookupPrivilegeValueW", "Ptr", 0, "Str", Name, "Int64*", &LUID := 0))
            return false
        return LUID
    }

    QueryObject(Handle, OBJECT_INFORMATION_CLASS)
    {
        static STATUS_SUCCESS := 0x00000000

        DllCall("ntdll\NtQueryObject", "Ptr", Handle, "UInt", OBJECT_INFORMATION_CLASS, "Ptr", 0, "UInt", 0, "UInt*", &Size := 0, "UInt")
        Buf := Buffer(Size, 0)
        NT_STATUS := DllCall("ntdll\NtQueryObject", "Ptr", Handle, "UInt", OBJECT_INFORMATION_CLASS, "Ptr", Buf.Ptr, "UInt", Buf.Size, "UInt*", &Size := 0, "UInt")
        if (NT_STATUS = STATUS_SUCCESS)
        {
            switch OBJECT_INFORMATION_CLASS
            {
                case 1:
                    ObjectInformation := StrGet(NumGet(buf, A_PtrSize, "UPtr"), NumGet(buf, 0, "UShort") // 2, "UTF-16")
                case 2:
                    ObjectInformation .= StrGet(NumGet(buf, A_PtrSize, "UPtr"), NumGet(buf, 0, "UShort") // 2, "UTF-16")
            }
            return ObjectInformation
        }
        return
    }

    OpenProcess(ProcessID, DesiredAccess, InheritHandle := 0)
    {
        if !(hProcess := DllCall("OpenProcess", "UInt", DesiredAccess, "Int", InheritHandle, "UInt", ProcessID, "Ptr"))
            return false
        return hProcess
    }

    OpenProcessToken(hProcess, DesiredAccess)
    {
        if !(DllCall("advapi32\OpenProcessToken", "Ptr", hProcess, "UInt", DesiredAccess, "Ptr*", &hToken := 0))
            return false
        return hToken
    }

    SystemHandleInformation(ProcessID)
    {
        static STATUS_SUCCESS               := 0x00000000
        static STATUS_INFO_LENGTH_MISMATCH  := 0xC0000004
        static STATUS_BUFFER_TOO_SMALL      := 0xC0000023
        static SYSTEM_HANDLE_INFORMATION    := 0x00000010
        static SYSTEM_HANDLE_INFORMATION_EX := 0x00000040

        Buf := Buffer(0, 0)
        NT_STATUS := DllCall("ntdll\NtQuerySystemInformation", "Int", SYSTEM_HANDLE_INFORMATION_EX, "Ptr", Buf.Ptr, "UInt", Buf.Size, "UInt*", &Size := 0, "UInt")
        while (NT_STATUS = STATUS_INFO_LENGTH_MISMATCH) || (NT_STATUS = STATUS_BUFFER_TOO_SMALL)
        {
            Buf := Buffer(Size, 0)
            NT_STATUS := DllCall("ntdll\NtQuerySystemInformation", "Int", SYSTEM_HANDLE_INFORMATION_EX, "Ptr", Buf.Ptr, "UInt", Buf.Size, "UInt*", &Size := 0, "UInt")
        }
        if (NT_STATUS = STATUS_SUCCESS)
        {
            NumberOfHandles := NumGet(Buf, 0x0000, "UInt")
            Addr := Buf.Ptr + 0x0010
            HANDLE_INFORMATION := Map()
            loop NumberOfHandles
            {
                if (NumGet(Addr, 0x0008, "UInt") = ProcessID)
                {
                    HANDLE := Map()
                    HANDLE["UniqueProcessId"]   := NumGet(Addr, 0x0008, "UInt")
                    HANDLE["HandleValue"]       := NumGet(Addr, 0x0010, "UInt")
                    HANDLE["GrantedAccess"]     := NumGet(Addr, 0x0018, "UInt")
                    HANDLE["HandleAttributes"]  := NumGet(Addr, 0x0020, "UInt")
                    HANDLE_INFORMATION[A_Index] := HANDLE
                }
                Addr += 0x0028
            }
            return HANDLE_INFORMATION
        }
        return false
    }
}


; =============================================================================================================================================================
; Example
; =============================================================================================================================================================

ProcessID := 1284

Main := Gui("+Resize +MinSize1024x576")
Main.MarginX := 10
Main.MarginY := 10
LV := Main.AddListView("xm ym w800 r30", ["Handle", "Type", "Name", "Path"])
for i, v in PH := GetProcessHandles(ProcessID)
    LV.Add("", PH[i]["Handle"], PH[i]["Type"], PH[i]["Name"], PH[i]["Path"])
Main.OnEvent("Close", (*) => ExitApp)
Main.OnEvent("Size", Gui_Size)
Main.Title := LV.GetCount()
Main.Show()


Gui_Size(thisGui, MinMax, Width, Height)
{
    if (MinMax = -1)
        return
    LV.Move(,, Width - 20, Height - 20)
    LV.Redraw()
}