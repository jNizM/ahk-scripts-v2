; ===========================================================================================================================================================================
; Retrieves information about each global group in the security database, which is the SAM database or, in the case of domain controllers, the Active Directory.
; Tested with AutoHotkey v2.0-beta.3
; ===========================================================================================================================================================================

NetGroupEnum(ServerName := "127.0.0.1")
{
	#DllLoad "netapi32.dll"

	static NERR_SUCCESS         := 0
	static GROUP_INFO_1         := 1
	static MAX_PREFERRED_LENGTH := -1

	NET_API_STATUS := DllCall("netapi32\NetGroupEnum", "WStr",  ServerName
	                                                 , "UInt",  GROUP_INFO_1
	                                                 , "Ptr*",  &Buf := 0
	                                                 , "UInt",  MAX_PREFERRED_LENGTH
	                                                 , "UInt*", &EntriesRead := 0
	                                                 , "UInt*", &TotalEntries := 0
	                                                 , "UInt*", 0
	                                                 , "UInt")

	if (NET_API_STATUS = NERR_SUCCESS)
	{
		Addr := Buf
		GROUP_INFO := Map()
		loop EntriesRead
		{
			INFO := Map()
			INFO["name"]        := (Ptr := NumGet(Addr, A_PtrSize * 0, "Ptr")) ? StrGet(Ptr) : ""
			INFO["comment"]     := (Ptr := NumGet(Addr, A_PtrSize * 1, "Ptr")) ? StrGet(Ptr) : ""
			GROUP_INFO[A_Index] := INFO

			Addr += A_PtrSize * 2
		}

		DllCall("netapi32\NetApiBufferFree", "Ptr", Buf, "UInt")
		return GROUP_INFO
	}

	DllCall("netapi32\NetApiBufferFree", "Ptr", Buf, "UInt")
	return false	
}

; ===========================================================================================================================================================================

GroupEnum := NetGroupEnum("dc.contoso.com")
for i, v in GroupEnum {
	for k, v in GroupEnum[i]
		output .= k ": " v "`n"
	MsgBox output
	output := ""
}