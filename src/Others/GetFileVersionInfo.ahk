; ===========================================================================================================================================================================
; Retrieves specified version information from the specified version-information resource.
; Tested with AutoHotkey v2.0-a134
; ===========================================================================================================================================================================

GetFileVersionInfo(FileName)
{
	static StringTable := [ "Comments", "CompanyName", "FileDescription", "FileVersion", "InternalName", "LegalCopyright"
						  , "LegalTrademarks", "OriginalFilename", "PrivateBuild", "ProductName", "ProductVersion", "SpecialBuild" ]

	if !(size := DllCall("version\GetFileVersionInfoSize", "str", FileName, "ptr", 0, "uint"))
	{
		MsgBox("GetFileVersionInfoSize failed: " A_LastError)
		return -1
	}

	data := Buffer(size, 0)
	if !(DllCall("version\GetFileVersionInfo", "str", FileName, "uint", 0, "uint", data.size, "ptr", data))
	{
		MsgBox("GetFileVersionInfo failed: " A_LastError)
		return -1
	}

	if !(DllCall("version\VerQueryValue", "ptr", data, "str", "\VarFileInfo\Translation", "ptr*", &buf := 0, "uint*", &len := 0))
	{
		MsgBox("VerQueryValue failed")
		return -1
	}

	LangCP := Format("{:04X}{:04X}", NumGet(buf + 0, "ushort"), NumGet(buf + 2, "ushort"))
	FileInfo := Map()
	for index, value in StringTable
	{
		if (DllCall("version\VerQueryValue", "ptr", data, "str", "\StringFileInfo\" . LangCP . "\" value, "ptr*", &buf, "uint*", &len))
		{
			FileInfo[value] := StrGet(buf, len, "utf-16")
		}
	}

	return FileInfo
}

; ===========================================================================================================================================================================

FileVersionInfo := GetFileVersionInfo("C:\Program Files\AutoHotkey\AutoHotkey.exe")
for key, value in FileVersionInfo
	MsgBox(key ": " value)
