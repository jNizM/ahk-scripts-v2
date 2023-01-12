; =============================================================================================================================================================
; Author ........: jNizM
; Released ......: 2021-04-23
; Modified ......: 2023-01-12
; Tested with....: AutoHotkey v2.0.2 (x64)
; Tested on .....: Windows 11 - 22H2 (x64)
; Function ......: FileCountLines( FileName )
;
; Parameter(s)...: FileName - path to the file
;
; Return ........: Count the number of lines in a file.
; =============================================================================================================================================================

#Requires AutoHotkey v2.0


FileCountLines(FileName)
{
	try
		File := FileOpen(FileName, "r-d")
	catch as Err
	{
		MsgBox "Can't open '" FileName "`n`n" Type(Err) ": " Err.Message
		return
	}

	CountLines := 0
	while !(File.AtEOF)
	{
		File.ReadLine()
		CountLines++
	}
	File.Close()

	return CountLines
}


; =============================================================================================================================================================
; Example
; =============================================================================================================================================================

MsgBox FileCountLines("C:\Windows\Logs\CBS\CBS.log")