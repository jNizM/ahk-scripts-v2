; =============================================================================================================================================================
; Author ........: jNizM
; Released ......: 2021-04-23
; Modified ......: 2023-01-12
; Tested with....: AutoHotkey v2.0.2 (x64)
; Tested on .....: Windows 11 - 22H2 (x64)
; Function ......: FileFindString( FileName, Search )
;
; Parameter(s)...: FileName - path to the file
;                  Search   - the word or string to search for
;
; Return ........: Finds a specific word / string in a text file.
; =============================================================================================================================================================

#Requires AutoHotkey v2.0


FileFindString(FileName, Search)
{
	try
		File := FileOpen(FileName, "r-d")
	catch as Err
	{
		MsgBox "Can't open '" FileName "`n`n" Type(Err) ": " Err.Message
		return
	}

	Found := Map()
	while !(File.AtEOF)
	{
		if (InStr(GetLine := File.ReadLine(), Search))
		{
			Found[A_Index] := GetLine
		}
	}
	File.Close()

	return Found
}


; =============================================================================================================================================================
; Example
; =============================================================================================================================================================

for Index, Value in FileFindString("C:\Windows\Logs\CBS\CBS.log", "CBS_E_INVALID_PACKAGE")
	MsgBox "Line: " Index "`n`n" Value