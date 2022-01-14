; ===========================================================================================================================================================================
; Retrieves information about a particular global group in the security database, which is the SAM database or, in the case of domain controllers, the Active Directory.
; Tested with AutoHotkey v2.0-beta.3
; ===========================================================================================================================================================================

NetGroupGetInfo(GroupName, ServerName := "127.0.0.1")
{
	#DllLoad "netapi32.dll"

	static NERR_SUCCESS := 0
	static GROUP_INFO_1 := 1

	NET_API_STATUS := DllCall("netapi32\NetGroupGetInfo", "WStr", ServerName
	                                                    , "WStr", GroupName
	                                                    , "UInt", GROUP_INFO_1
	                                                    , "Ptr*", &Buf := 0
	                                                    , "UInt")

	if (NET_API_STATUS = NERR_SUCCESS)
	{
		GROUP_INFO := Map()
		GROUP_INFO["name"]    := (Ptr := NumGet(Buf, A_PtrSize * 0, "Ptr")) ? StrGet(Ptr) : ""
		GROUP_INFO["comment"] := (Ptr := NumGet(Buf, A_PtrSize * 1, "Ptr")) ? StrGet(Ptr) : ""

		DllCall("netapi32\NetApiBufferFree", "Ptr", Buf, "UInt")
		return GROUP_INFO
	}

	DllCall("netapi32\NetApiBufferFree", "Ptr", Buf, "UInt")
	return false
}

; ===========================================================================================================================================================================

for k, v in NetGroupGetInfo("G_GROUP_TEST", "dc.contoso.com")
	output .= k ": " v "`n"
MsgBox output