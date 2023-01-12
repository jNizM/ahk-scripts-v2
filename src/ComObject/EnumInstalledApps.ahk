; =============================================================================================================================================================
; Author ........: jNizM, just me
; Released ......: 2021-04-23
; Modified ......: 2023-01-12
; Tested with....: AutoHotkey v2.0.2 (x64)
; Tested on .....: Windows 11 - 22H2 (x64)
; Function ......: EnumInstalledApps()
;
; Parameter(s)...: No parameters used
;
; Return ........: Gets general information about an application (from the Add/Remove Programs Application).
; =============================================================================================================================================================

#Requires AutoHotkey v2.0


EnumInstalledApps()
{
	static CLSID_EnumInstalledApps := "{0B124F8F-91F0-11D1-B8B5-006008059382}"
	static IID_IEnumInstalledApps  := "{1BC752E1-9046-11D1-B8B3-006008059382}"
	static InfoData := [ "DisplayName", "Version", "Publisher", "ProductID", "RegisteredOwner", "RegisteredCompany", "Language"
						, "SupportUrl", "SupportTelephone", "HelpLink", "InstallLocation", "InstallSource", "InstallDate"
						, "Contact", "Comments", "Image", "ReadmeUrl", "UpdateInfoUrl" ]

	InstalledApps := Map()
	EnumInstalledApps := ComObject(CLSID_EnumInstalledApps, IID_IEnumInstalledApps)
	while !(ComCall(3, EnumInstalledApps, "Ptr*", &IShellApp := 0, "UInt"))
	{
		AppInfoData := Buffer(8 + (A_PtrSize * 18), 0)
		NumPut("UInt", AppInfoData.Size, AppInfoData, 0)
		NumPut("UInt", 0x0EDFFF, AppInfoData, 4)
		if !(ComCall(3, IShellApp, "Ptr", AppInfoData))
		{
			InstalledApp := Map()
			Offset := 8 - A_PtrSize
			for each, Info in InfoData
				InstalledApp[Info] := (Addr := NumGet(AppInfoData, Offset += A_PtrSize, "UPtr")) ? StrGet(Addr, "UTF-16") : ""
			InstalledApps[A_Index] := InstalledApp
		}
		ObjRelease(IShellApp)
	}
	return InstalledApps
}


; =============================================================================================================================================================
; Example
; =============================================================================================================================================================

Apps := EnumInstalledApps()
for i, v in Apps {
	output := ""
	for k, v in Apps[i]
		output .= k ": " v "`n"
	MsgBox output
}
