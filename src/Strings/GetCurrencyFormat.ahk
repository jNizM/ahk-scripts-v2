; ===========================================================================================================================================================================
; GetCurrencyFormat
; Formats a number string as a currency string for a locale specified by identifier.
; ===========================================================================================================================================================================

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
	return ""
}

; ===========================================================================================================================================================================

MsgBox GetCurrencyFormat(1149.99)				; 1.149,99 €		( LANG_USER_DEFAULT | SUBLANG_DEFAULT    )		(GERMAN HERE)
MsgBox GetCurrencyFormat(1149.99, 0x0409)		; $1,149.99			( LANG_ENGLISH      | SUBLANG_ENGLISH_US )
MsgBox GetCurrencyFormat(1149.99, 0x0809)		; £1,149.99			( LANG_ENGLISH      | SUBLANG_ENGLISH_UK )
MsgBox GetCurrencyFormat(1149.99, 0x0407)		; 1.149,99 €		( LANG_GERMAN       | SUBLANG_GERMAN     )
