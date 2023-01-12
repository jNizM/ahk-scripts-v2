; =============================================================================================================================================================
; Author ........: jNizM
; Released ......: 2021-04-23
; Modified ......: 2023-01-12
; Tested with....: AutoHotkey v2.0.2 (x64)
; Tested on .....: Windows 11 - 22H2 (x64)
; Function ......: FileReadLastLines( FileName, [ LastLines ] )
;
; Parameter(s)...: FileName  - path to the file
;                  LastLines - the number of last lines to be displayed
;
; Return ........: Read last x lines of a text file.
; =============================================================================================================================================================

#Requires AutoHotkey v2.0


FileReadLastLines(FileName, LastLines := 5)
{
	try
		File := FileOpen(FileName, "r-d")
	catch as Err
	{
		MsgBox "Can't open '" FileName "`n`n" Type(Err) ": " Err.Message
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


; =============================================================================================================================================================
; Example
; =============================================================================================================================================================

for Index, Value in FileReadLastLines("C:\Windows\Logs\CBS\CBS.log", 10)
	MsgBox "Line: " Index "`n`n" Value