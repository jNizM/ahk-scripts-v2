; ===========================================================================================================================================================================
; Returns a SYSTEM_SECUREBOOT_INFORMATION structure from the NtQuerySystemInformation function.
; Tested with AutoHotkey v2.0-beta.3
; ===========================================================================================================================================================================

SystemSecureBootInformation()
{
	#DllLoad "ntdll.dll"

	static STATUS_SUCCESS                := 0x00000000
	static SYSTEM_SECUREBOOT_INFORMATION := 0x00000091

	DllCall("ntdll\NtQuerySystemInformation", "Int", SYSTEM_SECUREBOOT_INFORMATION, "Ptr", 0, "UInt", 0, "UInt*", &Size := 0)
	Buf := Buffer(Size, 0)
	if (DllCall("ntdll\NtQuerySystemInformation", "Int", SYSTEM_SECUREBOOT_INFORMATION, "Ptr", Buf.Ptr, "UInt", Buf.Size, "UInt*", 0) = STATUS_SUCCESS)
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