; ===========================================================================================================================================================================
; Author ........: jNizM
; Released ......: 2022-01-17
; Modified ......:
; Tested with....: AutoHotkey v2.0-beta.3 (x64)
; Tested on .....: Windows 11 - 21H2 (x64)
; Function ......: NetLocalGroupGetMembers( GroupName, [ServerName] )
;
; Parameter(s)...: GroupName  - the name of the local group whose members are to be listed
;                  ServerName - DNS or NetBIOS name of the remote server on which the function is to execute
;
; Return ........: Retrieves a list of the members of a particular local group in the security database, which is the security accounts manager (SAM) database or,
;                  in the case of domain controllers, the Active Directory.
; ===========================================================================================================================================================================

NetLocalGroupGetMembers(GroupName, ServerName := "127.0.0.1")
{
	#DllLoad "netapi32.dll"

	static NERR_SUCCESS              := 0
	static LOCALGROUP_MEMBERS_INFO_1 := 1
	static LOCALGROUP_MEMBERS_INFO_2 := 2
	static MAX_PREFERRED_LENGTH      := -1
	static SID_NAME_USE              := Map(1, "User", 2, "Group", 16, "WellKnownGroup", 32, "DeletedAccount", 128, "Unknown")

	NET_API_STATUS := DllCall("netapi32\NetLocalGroupGetMembers", "WStr",  ServerName
	                                                            , "WStr",  GroupName
	                                                            , "UInt",  ((ServerName = "127.0.0.1") ? LOCALGROUP_MEMBERS_INFO_1 : LOCALGROUP_MEMBERS_INFO_2)
	                                                            , "Ptr*",  &Buf := 0
	                                                            , "UInt",  MAX_PREFERRED_LENGTH
	                                                            , "UInt*", &EntriesRead := 0
	                                                            , "UInt*", &TotalEntries := 0
	                                                            , "UPtr*", 0
	                                                            , "UInt")

	if (NET_API_STATUS = NERR_SUCCESS)
	{
		Addr := Buf
		LOCALGROUP_MEMBERS_INFO := Map()
		loop EntriesRead
		{
			MEMBERS_INFO := Map()
			MEMBERS_INFO["sid"]              := ConvertSidToStringSid(NumGet(Addr, A_PtrSize * 0, "Ptr"))
			MEMBERS_INFO["sidusage"]         := SID_NAME_USE[NumGet(Addr, A_PtrSize * 1, "Int")]
			MEMBERS_INFO["domainandname"]    := (Ptr := NumGet(Addr, A_PtrSize * 2, "Ptr")) ? StrGet(Ptr) : ""
			LOCALGROUP_MEMBERS_INFO[A_Index] := MEMBERS_INFO

			Addr += A_PtrSize * 3
		}

		DllCall("netapi32\NetApiBufferFree", "Ptr", Buf, "UInt")
		return LOCALGROUP_MEMBERS_INFO
	}

	DllCall("netapi32\NetApiBufferFree", "Ptr", Buf, "UInt")
	return false
}


ConvertSidToStringSid(PSID)
{
	#DllLoad "advapi32.dll"

	if (DllCall("advapi32\ConvertSidToStringSidW", "Ptr", PSID, "Ptr*", &StringSid := 0))
	{
		StringLength := DllCall("lstrlenW", "Ptr", StringSid)
		VarSetStrCapacity(&SID, StringLength)
		DllCall("lstrcpyW", "Str", SID, "Ptr", StringSid)
		DllCall("LocalFree", "Ptr", StringSid)
		return SID
	}
	return false
}


; ===========================================================================================================================================================================
; Example
; ===========================================================================================================================================================================

LocalGroupMembers := NetLocalGroupGetMembers("L_GROUP_TEST", "dc.contoso.com")
for i, v in LocalGroupMembers {
	for k, v in LocalGroupMembers[i]
		output .= k ": " v "`n"
	MsgBox output
	output := ""
}