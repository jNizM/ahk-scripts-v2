; ===============================================================================================================================
; Finds a specific word / string in a text file.
; Tested with AutoHotkey v2.0-a132
; ===============================================================================================================================

FileFindString(FileName, Search)
{
	try
		File := FileOpen(FileName, "r-d")
	catch as Err
	{
		MsgBox("Can't open '" FileName "`n`n" Type(Err) ": " Err.Message)
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

; ===============================================================================================================================

for Index, Value in FileFindString("C:\Windows\Logs\CBS\CBS.log", "CBS_E_INVALID_PACKAGE")
	MsgBox("Line: " Index "`n`n" Value)
