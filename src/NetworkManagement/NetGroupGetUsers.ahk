; ===========================================================================================================================================================================
; Retrieves a list of the members in a particular global group in the security database, which is the SAM database or the Active Directory.
; Tested with AutoHotkey v2.0-beta.3
; ===========================================================================================================================================================================

NetGroupGetUsers(GroupName, ServerName := "127.0.0.1")
{
	#DllLoad "netapi32.dll"

	static NERR_SUCCESS         := 0
	static GROUP_USERS_INFO_0   := 0
	static MAX_PREFERRED_LENGTH := -1

	NET_API_STATUS := DllCall("netapi32\NetGroupGetUsers", "WStr",  ServerName
	                                                     , "WStr",  GroupName
	                                                     , "UInt",  GROUP_USERS_INFO_0
	                                                     , "Ptr*",  &Buf := 0
	                                                     , "UInt",  MAX_PREFERRED_LENGTH
	                                                     , "UInt*", &EntriesRead := 0
	                                                     , "UInt*", &TotalEntries := 0
	                                                     , "UPtr*", 0
	                                                     , "UInt")

	if (NET_API_STATUS = NERR_SUCCESS)
	{
		Addr := Buf
		GROUP_USERS_INFO := Array()
		loop EntriesRead
		{
			GROUP_USERS_INFO.Push((Ptr := NumGet(Addr, A_PtrSize * 0, "Ptr")) ? StrGet(Ptr) : "")
			Addr += A_PtrSize
		}

		DllCall("netapi32\NetApiBufferFree", "Ptr", Buf, "UInt")
		return GROUP_USERS_INFO
	}

	DllCall("netapi32\NetApiBufferFree", "Ptr", Buf, "UInt")
	return false
}

; ===========================================================================================================================================================================

for k, v in NetGroupGetUsers("G_GROUP_TEST", "dc.contoso.com")
	output .= k ": " v "`n"
MsgBox output