; ===========================================================================================================================================================================
; Returns a SYSTEM_PROCESSOR_POWER_INFORMATION structure from the NtQuerySystemInformation function.
; Tested with AutoHotkey v2.0-beta.3
; ===========================================================================================================================================================================

SystemProcessorPowerInformation()
{
	#DllLoad "ntdll.dll"

	static STATUS_SUCCESS                     := 0x00000000
	static STATUS_INFO_LENGTH_MISMATCH        := 0xC0000004
	static STATUS_BUFFER_TOO_SMALL            := 0xC0000023
	static SYSTEM_PROCESSOR_POWER_INFORMATION := 0x0000003D

	Buf := Buffer(0x0030, 0)
	NT_STATUS := DllCall("ntdll\NtQuerySystemInformation", "Int", SYSTEM_PROCESSOR_POWER_INFORMATION, "Ptr", Buf.Ptr, "UInt", Buf.Size, "UInt*", &Size := 0, "UInt")

	while (NT_STATUS = STATUS_INFO_LENGTH_MISMATCH) || (NT_STATUS = STATUS_BUFFER_TOO_SMALL)
	{
		Buf := Buffer(Size, 0)
		NT_STATUS := DllCall("ntdll\NtQuerySystemInformation", "Int", SYSTEM_PROCESSOR_POWER_INFORMATION, "Ptr", Buf.Ptr, "UInt", Buf.Size, "UInt*", &Size := 0, "UInt")
	}

	if (NT_STATUS = STATUS_SUCCESS)
	{
		PROCESSOR_POWER_INFORMATION := Map()
		PROCESSOR_POWER_INFORMATION["CurrentFrequency"]          := NumGet(Buf, 0x0000, "UChar")
		PROCESSOR_POWER_INFORMATION["ThermalLimitFrequency"]     := NumGet(Buf, 0x0001, "UChar")
		PROCESSOR_POWER_INFORMATION["ConstantThrottleFrequency"] := NumGet(Buf, 0x0002, "UChar")
		PROCESSOR_POWER_INFORMATION["DegradedThrottleFrequency"] := NumGet(Buf, 0x0003, "UChar")
		PROCESSOR_POWER_INFORMATION["LastBusyFrequency"]         := NumGet(Buf, 0x0004, "UChar")
		PROCESSOR_POWER_INFORMATION["LastC3Frequency"]           := NumGet(Buf, 0x0005, "UChar")
		PROCESSOR_POWER_INFORMATION["LastAdjustedBusyFrequency"] := NumGet(Buf, 0x0006, "UChar")
		PROCESSOR_POWER_INFORMATION["ProcessorMinThrottle"]      := NumGet(Buf, 0x0007, "UChar")
		PROCESSOR_POWER_INFORMATION["ProcessorMaxThrottle"]      := NumGet(Buf, 0x0008, "UChar")
		PROCESSOR_POWER_INFORMATION["NumberOfFrequencies"]       := NumGet(Buf, 0x000C, "UInt")
		PROCESSOR_POWER_INFORMATION["PromotionCount"]            := NumGet(Buf, 0x0010, "UInt")
		PROCESSOR_POWER_INFORMATION["DemotionCount"]             := NumGet(Buf, 0x0014, "UInt")
		PROCESSOR_POWER_INFORMATION["ErrorCount"]                := NumGet(Buf, 0x0018, "UInt")
		PROCESSOR_POWER_INFORMATION["RetryCount"]                := NumGet(Buf, 0x001C, "UInt")
		PROCESSOR_POWER_INFORMATION["CurrentFrequencyTime"]      := NumGet(Buf, 0x0020, "UInt64")
		PROCESSOR_POWER_INFORMATION["CurrentProcessorTime"]      := NumGet(Buf, 0x0028, "UInt64")
		PROCESSOR_POWER_INFORMATION["CurrentProcessorIdleTime"]  := NumGet(Buf, 0x0030, "UInt64")
		PROCESSOR_POWER_INFORMATION["LastProcessorTime"]         := NumGet(Buf, 0x0038, "UInt64")
		PROCESSOR_POWER_INFORMATION["LastProcessorIdleTime"]     := NumGet(Buf, 0x0040, "UInt64")
		PROCESSOR_POWER_INFORMATION["Energy"]                    := NumGet(Buf, 0x0048, "UInt64")
		return PROCESSOR_POWER_INFORMATION
	}

	return false
}

; Example ===================================================================================================================================================================

MsgBox SystemProcessorPowerInformation()["CurrentFrequency"]