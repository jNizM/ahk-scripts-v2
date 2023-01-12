; =============================================================================================================================================================
; Author ........: jNizM
; Released ......: 2022-02-08
; Modified ......: 2023-01-12
; Tested with....: AutoHotkey v2.0.2 (x64)
; Tested on .....: Windows 11 - 22H2 (x64)
; Function ......: GetFileOwner( FileName )
;
; Parameter(s)...: FileName - path to the file
;
; Return ........: Finding the Owner of a File or Folder
; =============================================================================================================================================================

#Requires AutoHotkey v2.0


GetFileOwner(FileName)
{
	static GENERIC_READ               := 0x80000000
	static FILE_SHARE_READ            := 0x00000001
	static FILE_SHARE_WRITE           := 0x00000002
	static FILE_SHARE_DELETE          := 0x00000004
	static OPEN_EXISTING              := 3
	static FILE_FLAG_BACKUP_SEMANTICS := 0x02000000
	static SE_FILE_OBJECT             := 1
	static OWNER_SECURITY_INFORMATION := 0x00000001
	static ERROR_SUCCESS              := 0
	static SidTypeUnknown             := 8

	if !(hFile := DllCall("CreateFile", "Str",  FileName
	                                  , "UInt", GENERIC_READ
	                                  , "UInt", FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE
	                                  , "Ptr",  0
	                                  , "UInt", OPEN_EXISTING
	                                  , "UInt", 0
	                                  , "Ptr",  0
	                                  , "Ptr"))
	&& !(hFile := DllCall("CreateFile", "Str",  FileName
	                                  , "UInt", GENERIC_READ
	                                  , "UInt", FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE
	                                  , "Ptr",  0
	                                  , "UInt", OPEN_EXISTING
	                                  , "UInt", FILE_FLAG_BACKUP_SEMANTICS
	                                  , "Ptr",  0
	                                  , "Ptr"))
		return

	rCode := DllCall("advapi32\GetSecurityInfo", "Ptr",  hFile
	                                           , "Int",  SE_FILE_OBJECT
	                                           , "UInt", OWNER_SECURITY_INFORMATION
	                                           , "Ptr*", &pSidOwner := 0
	                                           , "Ptr",  0
	                                           , "Ptr",  0
	                                           , "Ptr",  0
	                                           , "Ptr*", &pSD := 0
	                                           , "UInt")
	if (rCode != ERROR_SUCCESS)
	{
		DllCall("CloseHandle", "Ptr", hFile)
		return
	}

	DllCall("advapi32\LookupAccountSid", "Ptr",   0
	                                   , "Ptr",   pSidOwner
	                                   , "Ptr",   0
	                                   , "UInt*", &sN := 0
	                                   , "Ptr",   0
	                                   , "UInt*", &sD := 0
	                                   , "UInt*", SidTypeUnknown)

	VarSetStrCapacity(&Name, sN)
	VarSetStrCapacity(&DomainName, sD)
	DllCall("advapi32\LookupAccountSid", "Ptr",   0
	                                   , "Ptr",   pSidOwner
	                                   , "Str",   Name
	                                   , "UInt*", sN
	                                   , "Str",   DomainName
	                                   , "UInt*", sD
	                                   , "UInt*", SidTypeUnknown)

	DllCall("LocalFree", "Ptr", pSD)
	DllCall("CloseHandle", "Ptr", hFile)

	return (DomainName) ? DomainName "\" Name : (Name) ? Name : ""
}


; =============================================================================================================================================================
; Example
; =============================================================================================================================================================

MsgBox GetFileOwner("C:\Program Files\AutoHotkey\AutoHotkeyU64.exe")