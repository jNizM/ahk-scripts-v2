; ===========================================================================================================================================================================
; Returns a SYSTEM_DEVICE_INFORMATION structure from the NtQuerySystemInformation function.
; Tested with AutoHotkey v2.0-beta.3
; ===========================================================================================================================================================================

SystemDeviceInformation()
{
	#DllLoad "ntdll.dll"

	static STATUS_SUCCESS            := 0x00000000
	static SYSTEM_DEVICE_INFORMATION := 0x00000007

	DllCall("ntdll\NtQuerySystemInformation", "Int", SYSTEM_DEVICE_INFORMATION, "Ptr", 0, "UInt", 0, "UInt*", &Size := 0, "UInt")
	Buf := Buffer(Size, 0)
	if (DllCall("ntdll\NtQuerySystemInformation", "Int", SYSTEM_DEVICE_INFORMATION, "Ptr", Buf.Ptr, "UInt", Buf.Size, "UInt*", 0, "UInt") = STATUS_SUCCESS)
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
	return false
}

; Example ===================================================================================================================================================================

MsgBox SystemDeviceInformation()["NumberOfDisks"]