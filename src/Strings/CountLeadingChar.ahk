﻿; =============================================================================================================================================================
; Author ........: jNizM
; Released ......: 2021-12-03
; Modified ......: 2023-01-13
; Tested with....: AutoHotkey v2.0.2 (x64)
; Tested on .....: Windows 11 - 22H2 (x64)
; Function ......: GetModuleBaseAddr()
;
; Parameter(s)...: String
;                  Char (Leading Char)
;
; Return ........: Count how often a certain character occurs at the beginning of a string.
; =============================================================================================================================================================

#Requires AutoHotkey v2.0


CountLeadingChar(String, Char)
{
	Match := 0
	loop StrLen(String)
	{
		if !(InStr(SubStr(String, 1 + Match, 1), Char))
			break
		Match++
	}
	return Match
}


; =============================================================================================================================================================
; Example
; =============================================================================================================================================================

MsgBox CountLeadingChar("000000013370", "0")    ; -> 7