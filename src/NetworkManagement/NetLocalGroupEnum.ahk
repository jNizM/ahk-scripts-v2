; ===========================================================================================================================================================================
; Returns information about each local group account on the specified server.
; Tested with AutoHotkey v2.0-beta.3
; ===========================================================================================================================================================================

NetLocalGroupEnum(ServerName := "127.0.0.1")
{
	#DllLoad "netapi32.dll"

	static NERR_SUCCESS         := 0
	static LOCALGROUP_INFO_1    := 1
	static MAX_PREFERRED_LENGTH := -1

	NET_API_STATUS := DllCall("netapi32\NetLocalGroupEnum", "WStr",  ServerName
	                                                      , "UInt",  LOCALGROUP_INFO_1
	                                                      , "Ptr*",  &Buf := 0
	                                                      , "UInt",  MAX_PREFERRED_LENGTH
	                                                      , "UInt*", &EntriesRead := 0
	                                                      , "UInt*", &TotalEntries := 0
	                                                      , "UPtr*", 0
	                                                      , "UInt")

	if (NET_API_STATUS = NERR_SUCCESS)
	{
		Addr := Buf
		LOCALGROUP_INFO := Map()
		loop EntriesRead
		{
			INFO := Map()
			INFO["name"]             := (Ptr := NumGet(Addr, A_PtrSize * 0, "Ptr")) ? StrGet(Ptr) : ""
			INFO["comment"]          := (Ptr := NumGet(Addr, A_PtrSize * 1, "Ptr")) ? StrGet(Ptr) : ""
			LOCALGROUP_INFO[A_Index] := INFO

			Addr += A_PtrSize * 2
		}

		DllCall("netapi32\NetApiBufferFree", "Ptr", Buf, "UInt")
		return LOCALGROUP_INFO
	}

	DllCall("netapi32\NetApiBufferFree", "Ptr", Buf, "UInt")
	return false
}

; ===========================================================================================================================================================================

LocalGroupEnum := NetLocalGroupEnum("dc.contoso.com")
for i, v in LocalGroupEnum {
	for k, v in LocalGroupEnum[i]
		output .= k ": " v "`n"
	MsgBox output
	output := ""
}