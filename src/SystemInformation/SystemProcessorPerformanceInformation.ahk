; =============================================================================================================================================================
; Author ........: jNizM
; Released ......: 2021-12-22
; Modified ......: 2023-01-13
; Tested with....: AutoHotkey v2.0.2 (x64)
; Tested on .....: Windows 11 - 22H2 (x64)
; Function ......: SystemProcessorPerformanceInformation()
;
; Parameter(s)...: No parameters used
;
; Return ........: Returns a SYSTEM_PROCESSOR_PERFORMANCE_INFORMATION structure from the NtQuerySystemInformation function.
; =============================================================================================================================================================

#Requires AutoHotkey v2.0


SystemProcessorPerformanceInformation()
{
	#DllLoad "ntdll.dll"

	static STATUS_SUCCESS                           := 0x00000000
	static STATUS_INFO_LENGTH_MISMATCH              := 0xC0000004
	static STATUS_BUFFER_TOO_SMALL                  := 0xC0000023
	static SYSTEM_PROCESSOR_PERFORMANCE_INFORMATION := 0x00000008

	Buf := Buffer(0x0030)
	NT_STATUS := DllCall("ntdll\NtQuerySystemInformation", "Int", SYSTEM_PROCESSOR_PERFORMANCE_INFORMATION, "Ptr", Buf.Ptr, "UInt", Buf.Size, "UInt*", &Size := 0, "UInt")

	while (NT_STATUS = STATUS_INFO_LENGTH_MISMATCH) || (NT_STATUS = STATUS_BUFFER_TOO_SMALL)
	{
		Buf := Buffer(Size)
		NT_STATUS := DllCall("ntdll\NtQuerySystemInformation", "Int", SYSTEM_PROCESSOR_PERFORMANCE_INFORMATION, "Ptr", Buf.Ptr, "UInt", Buf.Size, "UInt*", &Size := 0, "UInt")
	}

	if (NT_STATUS = STATUS_SUCCESS)
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

	throw OSError()
}


; =============================================================================================================================================================
; Example
; =============================================================================================================================================================

MsgBox SystemProcessorPerformanceInformation()["IdleTime"]