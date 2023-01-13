; =============================================================================================================================================================
; Author ........: jNizM
; Released ......: 2021-12-22
; Modified ......: 2023-01-13
; Tested with....: AutoHotkey v2.0.2 (x64)
; Tested on .....: Windows 11 - 22H2 (x64)
; Function ......: SystemProcessorInformation()
;
; Parameter(s)...: No parameters used
;
; Return ........: Returns a SYSTEM_PROCESSOR_INFORMATION structure from the NtQuerySystemInformation function.
; =============================================================================================================================================================

#Requires AutoHotkey v2.0


SystemProcessorInformation()
{
	#DllLoad "ntdll.dll"

	static STATUS_SUCCESS               := 0x00000000
	static STATUS_INFO_LENGTH_MISMATCH  := 0xC0000004
	static STATUS_BUFFER_TOO_SMALL      := 0xC0000023
	static SYSTEM_PROCESSOR_INFORMATION := 0x00000001

	Buf := Buffer(0x000C)
	NT_STATUS := DllCall("ntdll\NtQuerySystemInformation", "Int", SYSTEM_PROCESSOR_INFORMATION, "Ptr", Buf.Ptr, "UInt", Buf.Size, "UInt*", &Size := 0, "UInt")

	while (NT_STATUS = STATUS_INFO_LENGTH_MISMATCH) || (NT_STATUS = STATUS_BUFFER_TOO_SMALL)
	{
		Buf := Buffer(Size)
		NT_STATUS := DllCall("ntdll\NtQuerySystemInformation", "Int", SYSTEM_PROCESSOR_INFORMATION, "Ptr", Buf.Ptr, "UInt", Buf.Size, "UInt*", &Size := 0, "UInt")
	}

	if (NT_STATUS = STATUS_SUCCESS)
	{
		PROCESSOR_INFORMATION := Map()
		PROCESSOR_INFORMATION["ProcessorArchitecture"] := NumGet(Buf, 0x0000, "UShort")
		PROCESSOR_INFORMATION["ProcessorLevel"]        := NumGet(Buf, 0x0002, "UShort")
		PROCESSOR_INFORMATION["ProcessorRevision"]     := NumGet(Buf, 0x0004, "UShort")
		PROCESSOR_INFORMATION["MaximumProcessors"]     := NumGet(Buf, 0x0006, "UShort")
		PROCESSOR_INFORMATION["ProcessorFeatureBits"]  := NumGet(Buf, 0x0008, "UInt")
		return PROCESSOR_INFORMATION
	}

	throw OSError()
}


; =============================================================================================================================================================
; Example
; =============================================================================================================================================================

MsgBox SystemProcessorInformation()["MaximumProcessors"]