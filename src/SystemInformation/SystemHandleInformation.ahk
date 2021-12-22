; ===========================================================================================================================================================================
; Returns a SYSTEM_DEVICE_INFORMATION structure from the NtQuerySystemInformation function.
; Tested with AutoHotkey v2.0-beta.3
; ===========================================================================================================================================================================

SystemHandleInformation()
{
	#DllLoad "ntdll.dll"

	static STATUS_SUCCESS              := 0x00000000
	static STATUS_INFO_LENGTH_MISMATCH := 0xC0000004
	static STATUS_BUFFER_TOO_SMALL     := 0xC0000023
	static SYSTEM_HANDLE_INFORMATION   := 0x00000010

	Buf := Buffer(0, 0)
	NT_STATUS := DllCall("ntdll\NtQuerySystemInformation", "Int", SYSTEM_HANDLE_INFORMATION, "Ptr", Buf.Ptr, "UInt", Buf.Size, "UInt*", &Size := 0, "UInt")

	while (NT_STATUS = STATUS_INFO_LENGTH_MISMATCH) || (NT_STATUS = STATUS_BUFFER_TOO_SMALL)
	{
		Buf := Buffer(Size, 0)
		NT_STATUS := DllCall("ntdll\NtQuerySystemInformation", "Int", SYSTEM_HANDLE_INFORMATION, "Ptr", Buf.Ptr, "UInt", Buf.Size, "UInt*", &Size := 0, "UInt")
	}

	if (NT_STATUS = STATUS_SUCCESS)
	{
		HANDLE_INFORMATION := Map()
		HANDLE_INFORMATION["NumberOfHandles"] := NumGet(Buf, 0x0000, "UInt")
		Addr := Buf.Ptr + 0x0008
		loop HANDLE_INFORMATION["NumberOfHandles"]
		{
			HANDLE := Map()
			HANDLE["UniqueProcessId"]       := NumGet(Addr, 0x0000, "UShort")
			HANDLE["CreatorBackTraceIndex"] := NumGet(Addr, 0x0002, "UShort")
			HANDLE["ObjectTypeIndex"]       := NumGet(Addr, 0x0004, "UChar")
			HANDLE["HandleAttributes"]      := NumGet(Addr, 0x0005, "UChar")
			HANDLE["HandleValue"]           := NumGet(Addr, 0x0006, "UShort")
			HANDLE["Object"]                := NumGet(Addr, 0x0008, "Ptr*")
			HANDLE["GrantedAccess"]         := NumGet(Addr, 0x0010, "UInt")
			HANDLE_INFORMATION[A_Index]     := HANDLE
			Addr += 0x0018
		}

		return HANDLE_INFORMATION
	}

	return false
}

; Example ===================================================================================================================================================================

MsgBox SystemHandleInformation()["NumberOfHandles"]

Handle := SystemHandleInformation()
for i, v in Handle {
	for k, v in Handle[i]
		MsgBox k ": " v
}