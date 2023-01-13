; =============================================================================================================================================================
; Author ........: jNizM
; Released ......: 2021-12-22
; Modified ......: 2023-01-13
; Tested with....: AutoHotkey v2.0.2 (x64)
; Tested on .....: Windows 11 - 22H2 (x64)
; Function ......: SystemDeviceInformation()
;
; Parameter(s)...: No parameters used
;
; Return ........: Returns a SYSTEM_DEVICE_INFORMATION structure from the NtQuerySystemInformation function.
; =============================================================================================================================================================

#Requires AutoHotkey v2.0


SystemDeviceInformation()
{
	#DllLoad "ntdll.dll"

	static STATUS_SUCCESS              := 0x00000000
	static STATUS_INFO_LENGTH_MISMATCH := 0xC0000004
	static STATUS_BUFFER_TOO_SMALL     := 0xC0000023
	static SYSTEM_DEVICE_INFORMATION   := 0x00000007

	Buf := Buffer(0x0018)
	NT_STATUS := DllCall("ntdll\NtQuerySystemInformation", "Int", SYSTEM_DEVICE_INFORMATION, "Ptr", Buf.Ptr, "UInt", Buf.Size, "UInt*", &Size := 0, "UInt")

	while (NT_STATUS = STATUS_INFO_LENGTH_MISMATCH) || (NT_STATUS = STATUS_BUFFER_TOO_SMALL)
	{
		Buf := Buffer(Size)
		NT_STATUS := DllCall("ntdll\NtQuerySystemInformation", "Int", SYSTEM_DEVICE_INFORMATION, "Ptr", Buf.Ptr, "UInt", Buf.Size, "UInt*", &Size := 0, "UInt")
	}

	if (NT_STATUS = STATUS_SUCCESS)
	{
		DEVICE_INFORMATION := Map()
		DEVICE_INFORMATION["NumberOfDisks"]         := NumGet(Buf, 0x0000, "UInt")
		DEVICE_INFORMATION["NumberOfFloppies"]      := NumGet(Buf, 0x0004, "UInt")
		DEVICE_INFORMATION["NumberOfCdRoms"]        := NumGet(Buf, 0x0008, "UInt")
		DEVICE_INFORMATION["NumberOfTapes"]         := NumGet(Buf, 0x000C, "UInt")
		DEVICE_INFORMATION["NumberOfSerialPorts"]   := NumGet(Buf, 0x0010, "UInt")
		DEVICE_INFORMATION["NumberOfParallelPorts"] := NumGet(Buf, 0x0014, "UInt")
		return DEVICE_INFORMATION
	}

	throw OSError()
}


; =============================================================================================================================================================
; Example
; =============================================================================================================================================================

MsgBox SystemDeviceInformation()["NumberOfDisks"]