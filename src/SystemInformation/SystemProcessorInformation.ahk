; ===========================================================================================================================================================================
; Returns a SYSTEM_PROCESSOR_INFORMATION structure from the NtQuerySystemInformation function.
; Tested with AutoHotkey v2.0-beta.3
; ===========================================================================================================================================================================

SystemProcessorInformation()
{
	#DllLoad "ntdll.dll"

	static SYSTEM_PROCESSOR_INFORMATION := 0x01

	Buf := Buffer(0, 0)
	DllCall("ntdll\NtQuerySystemInformation", "Int", SYSTEM_PROCESSOR_INFORMATION, "Ptr", Buf.Ptr, "UInt", 0, "UInt*", &Size := 0)
	Buf := Buffer(Size, 0)
	if !(DllCall("ntdll\NtQuerySystemInformation", "Int", SYSTEM_PROCESSOR_INFORMATION, "Ptr", Buf.Ptr, "UInt", Buf.Size, "UInt*", 0))
	{
		PROCESSOR_INFORMATION := Map()
		PROCESSOR_INFORMATION["ProcessorArchitecture"] := NumGet(Buf, 0, "UShort")
		PROCESSOR_INFORMATION["ProcessorLevel"]        := NumGet(Buf, 2, "UShort")
		PROCESSOR_INFORMATION["ProcessorRevision"]     := NumGet(Buf, 4, "UShort")
		PROCESSOR_INFORMATION["MaximumProcessors"]     := NumGet(Buf, 6, "UShort")
		PROCESSOR_INFORMATION["ProcessorFeatureBits"]  := NumGet(Buf, 8, "UInt")
		return PROCESSOR_INFORMATION
	}
	return false
}

; Example ===================================================================================================================================================================

MsgBox SystemProcessorInformation()["MaximumProcessors"]