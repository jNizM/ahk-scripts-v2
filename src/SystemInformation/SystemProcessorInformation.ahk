; ===========================================================================================================================================================================
; Returns a SYSTEM_PROCESSOR_INFORMATION structure from the NtQuerySystemInformation function.
; Tested with AutoHotkey v2.0-beta.3
; ===========================================================================================================================================================================

SystemProcessorInformation()
{
	#DllLoad "ntdll.dll"

	static STATUS_SUCCESS               := 0x00000000
	static SYSTEM_PROCESSOR_INFORMATION := 0x00000001

	DllCall("ntdll\NtQuerySystemInformation", "Int", SYSTEM_PROCESSOR_INFORMATION, "Ptr", 0, "UInt", 0, "UInt*", &Size := 0)
	Buf := Buffer(Size, 0)
	if (DllCall("ntdll\NtQuerySystemInformation", "Int", SYSTEM_PROCESSOR_INFORMATION, "Ptr", Buf.Ptr, "UInt", Buf.Size, "UInt*", 0) = STATUS_SUCCESS)
	{
		PROCESSOR_INFORMATION := Map()
		PROCESSOR_INFORMATION["ProcessorArchitecture"] := NumGet(Buf, 0x0000, "UShort")
		PROCESSOR_INFORMATION["ProcessorLevel"]        := NumGet(Buf, 0x0002, "UShort")
		PROCESSOR_INFORMATION["ProcessorRevision"]     := NumGet(Buf, 0x0004, "UShort")
		PROCESSOR_INFORMATION["MaximumProcessors"]     := NumGet(Buf, 0x0006, "UShort")
		PROCESSOR_INFORMATION["ProcessorFeatureBits"]  := NumGet(Buf, 0x0008, "UInt")
		return PROCESSOR_INFORMATION
	}
	return false
}

; Example ===================================================================================================================================================================

MsgBox SystemProcessorInformation()["MaximumProcessors"]