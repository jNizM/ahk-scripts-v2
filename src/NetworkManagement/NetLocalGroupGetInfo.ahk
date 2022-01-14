; ===========================================================================================================================================================================
; Retrieves information about a particular local group account on a server.
; Tested with AutoHotkey v2.0-beta.3
; ===========================================================================================================================================================================

NetLocalGroupGetInfo(GroupName, ServerName := "127.0.0.1")
{
	#DllLoad "netapi32.dll"

	static NERR_SUCCESS         := 0
	static LOCALGROUP_INFO_1    := 1

	NET_API_STATUS := DllCall("netapi32\NetLocalGroupGetInfo", "WStr", ServerName
	                                                         , "WStr", GroupName
	                                                         , "UInt", LOCALGROUP_INFO_1
	                                                         , "Ptr*", &Buf := 0
	                                                         , "UInt")

	if (NET_API_STATUS = NERR_SUCCESS)
	{
		LOCALGROUP_INFO := Map()
		LOCALGROUP_INFO["name"]    := (Ptr := NumGet(Buf, A_PtrSize * 0, "Ptr")) ? StrGet(Ptr) : ""
		LOCALGROUP_INFO["comment"] := (Ptr := NumGet(Buf, A_PtrSize * 1, "Ptr")) ? StrGet(Ptr) : ""

		DllCall("netapi32\NetApiBufferFree", "Ptr", Buf, "UInt")
		return LOCALGROUP_INFO
	}

	DllCall("netapi32\NetApiBufferFree", "Ptr", Buf, "UInt")
	return false
}

; ===========================================================================================================================================================================

for k, v in NetLocalGroupGetInfo("L_GROUP_TEST", "dc.contoso.com")
	output .= k ": " v "`n"
MsgBox output