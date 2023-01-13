; =============================================================================================================================================================
; Author ........: jNizM
; Released ......: 2015-11-02
; Modified ......: 2023-01-13
; Tested with....: AutoHotkey v2.0.2 (x64)
; Tested on .....: Windows 11 - 22H2 (x64)
; Function ......: GetCurrencyFormat()
;
; Parameter(s)...: Value
;                  Locale Identifier (32-bit value - see https://learn.microsoft.com/en-us/windows/win32/intl/locale-identifiers)
;
; Return ........: Formats a number string as a currency string for a locale specified by name.
; =============================================================================================================================================================

#Requires AutoHotkey v2.0


GetCurrencyFormat(Value, Locale := 0x0400)
{
	if (Size := DllCall("GetCurrencyFormatW", "UInt", Locale, "UInt", 0, "Str", Value, "Ptr", 0, "Ptr", 0, "Int", 0))
	{
		Size := VarSetStrCapacity(&CurrencyStr, Size)
		if (Size := DllCall("GetCurrencyFormatW", "UInt", Locale, "UInt", 0, "Str", Value, "Ptr", 0, "Str", CurrencyStr, "Int", Size))
		{
			return CurrencyStr
		}
	}
	return
}


; =============================================================================================================================================================
; Example
; =============================================================================================================================================================

MsgBox GetCurrencyFormat(1149.99)            ; 1.149,99 €    ( LANG_USER_DEFAULT | SUBLANG_DEFAULT    )    (for me it is german)
MsgBox GetCurrencyFormat(1149.99, 0x0409)    ; $1,149.99     ( LANG_ENGLISH      | SUBLANG_ENGLISH_US )
MsgBox GetCurrencyFormat(1149.99, 0x0809)    ; £1,149.99     ( LANG_ENGLISH      | SUBLANG_ENGLISH_UK )
MsgBox GetCurrencyFormat(1149.99, 0x0407)    ; 1.149,99 €    ( LANG_GERMAN       | SUBLANG_GERMAN     )