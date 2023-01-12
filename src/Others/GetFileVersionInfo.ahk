; =============================================================================================================================================================
; Author ........: jNizM (Original by Lexikos)
; Released ......: 2021-05-10
; Modified ......: 2023-01-12
; Tested with....: AutoHotkey v2.0.2 (x64)
; Tested on .....: Windows 11 - 22H2 (x64)
; Function ......: GetFileVersionInfo( FileName )
;
; Parameter(s)...: FileName - path to the file
;
; Return ........: Retrieves specified version information from the specified version-information resource.
; =============================================================================================================================================================

#Requires AutoHotkey v2.0


GetFileVersionInfo(FileName)
{
	static StringTable := [ "Comments", "CompanyName", "FileDescription", "FileVersion", "InternalName", "LegalCopyright"
	                      , "LegalTrademarks", "OriginalFilename", "PrivateBuild", "ProductName", "ProductVersion", "SpecialBuild" ]

	if (Size := DllCall("version\GetFileVersionInfoSizeW", "Str", FileName, "Ptr", 0, "UInt"))
	{
		Data := Buffer(Size)
		if (DllCall("version\GetFileVersionInfoW", "Str", FileName, "UInt", 0, "UInt", Data.Size, "Ptr", Data))
		{
			if (DllCall("version\VerQueryValueW", "Ptr", Data, "Str", "\VarFileInfo\Translation", "Ptr*", &Buf := 0, "UInt*", &Len := 0))
			{
				LangCP := Format("{:04X}{:04X}", NumGet(Buf + 0, "UShort"), NumGet(Buf + 2, "UShort"))
				FileInfo := Map()
				for index, value in StringTable
				{
					if (DllCall("version\VerQueryValueW", "Ptr", Data, "Str", "\StringFileInfo\" . LangCP . "\" value, "Ptr*", &Buf, "UInt*", &Len))
					{
						FileInfo[value] := StrGet(Buf, Len, "UTF-16")
					}
				}
				return FileInfo
			}
		}
	}
	throw OSError()
}


; =============================================================================================================================================================
; Example
; =============================================================================================================================================================

FileVersionInfo := GetFileVersionInfo("C:\Program Files\AutoHotkey\AutoHotkey.exe")
for key, value in FileVersionInfo
	output .= key ": " value "`n"
MsgBox output