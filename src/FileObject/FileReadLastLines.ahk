; ===============================================================================================================================
; Read last x lines of a text file.
; Tested with AutoHotkey v2.0-a132
; ===============================================================================================================================

FileReadLastLines(FileName, LastLines := 5)
{
	try
		File := FileOpen(FileName, "r-d")
	catch as Err
	{
		MsgBox("Can't open '" FileName "`n`n" Type(Err) ": " Err.Message)
		return
	}

	CountLines := 0, LinesCount := 0, GetLine := "", GetLines := Map()
	while !(File.AtEOF)
	{
		File.ReadLine()
		CountLines++
	}
	File.Seek(0)
	while !(File.AtEOF)
	{
		GetLine := File.ReadLine()
		if (LinesCount >= CountLines - LastLines)
		{
			GetLines[A_Index] := GetLine
		}
		LinesCount++
	}
	File.Close()

	return GetLines
}

; ===============================================================================================================================

for Index, Value in FileReadLastLines("C:\Windows\Logs\CBS\CBS.log", 10)
	MsgBox("Line: " Index "`n`n" Value)
