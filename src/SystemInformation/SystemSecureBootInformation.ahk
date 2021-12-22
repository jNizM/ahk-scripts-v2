; ===========================================================================================================================================================================
; Returns a SYSTEM_SECUREBOOT_INFORMATION structure from the NtQuerySystemInformation function.
; Tested with AutoHotkey v2.0-beta.3
; ===========================================================================================================================================================================

SystemSecureBootInformation()
{
	#DllLoad "ntdll.dll"

	static STATUS_SUCCESS                := 0x00000000
	static STATUS_INFO_LENGTH_MISMATCH   := 0xC0000004
	static STATUS_BUFFER_TOO_SMALL       := 0xC0000023
	static SYSTEM_SECUREBOOT_INFORMATION := 0x00000091

	Buf := Buffer(0x0002, 0)
	NT_STATUS := DllCall("ntdll\NtQuerySystemInformation", "Int", SYSTEM_SECUREBOOT_INFORMATION, "Ptr", Buf.Ptr, "UInt", Buf.Size, "UInt*", &Size := 0, "UInt")

	while (NT_STATUS = STATUS_INFO_LENGTH_MISMATCH) || (NT_STATUS = STATUS_BUFFER_TOO_SMALL)
	{
		Buf := Buffer(Size, 0)
		NT_STATUS := DllCall("ntdll\NtQuerySystemInformation", "Int", SYSTEM_SECUREBOOT_INFORMATION, "Ptr", Buf.Ptr, "UInt", Buf.Size, "UInt*", &Size := 0, "UInt")
	}

	if (NT_STATUS = STATUS_SUCCESS)
	{
		SECUREBOOT_INFORMATION := Map()
		SECUREBOOT_INFORMATION["SecureBootEnabled"] := NumGet(Buf, 0x0000, "UChar")
		SECUREBOOT_INFORMATION["SecureBootCapable"] := NumGet(Buf, 0x0001, "UChar")
		return SECUREBOOT_INFORMATION
	}

	return false
}

; Example ===================================================================================================================================================================

MsgBox SystemSecureBootInformation()["SecureBootEnabled"]