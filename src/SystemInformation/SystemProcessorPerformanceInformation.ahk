; ===========================================================================================================================================================================
; Returns a SYSTEM_PROCESSOR_PERFORMANCE_INFORMATION structure from the NtQuerySystemInformation function.
; Tested with AutoHotkey v2.0-beta.3
; ===========================================================================================================================================================================

SystemProcessorPerformanceInformation()
{
	#DllLoad "ntdll.dll"

	static STATUS_SUCCESS                           := 0x00000000
	static SYSTEM_PROCESSOR_PERFORMANCE_INFORMATION := 0x00000008

	DllCall("ntdll\NtQuerySystemInformation", "Int", SYSTEM_PROCESSOR_PERFORMANCE_INFORMATION, "Ptr", 0, "UInt", 0, "UInt*", &Size := 0)
	Buf := Buffer(Size, 0)
	if (DllCall("ntdll\NtQuerySystemInformation", "Int", SYSTEM_PROCESSOR_PERFORMANCE_INFORMATION, "Ptr", Buf.Ptr, "UInt", Buf.Size, "UInt*", 0) = STATUS_SUCCESS)
	{
		DEVICE_INFORMATION := Map()
		DEVICE_INFORMATION["IdleTime"]       := NumGet(Buf, 0x0000, "Int64")
		DEVICE_INFORMATION["KernelTime"]     := NumGet(Buf, 0x0008, "Int64")
		DEVICE_INFORMATION["UserTime"]       := NumGet(Buf, 0x0010, "Int64")
		DEVICE_INFORMATION["DpcTime"]        := NumGet(Buf, 0x0018, "Int64")
		DEVICE_INFORMATION["InterruptTime"]  := NumGet(Buf, 0x0020, "Int64")
		DEVICE_INFORMATION["InterruptCount"] := NumGet(Buf, 0x0028, "UInt")
		return DEVICE_INFORMATION
	}
	return false
}

; Example ===================================================================================================================================================================

MsgBox SystemProcessorPerformanceInformation()["IdleTime"]