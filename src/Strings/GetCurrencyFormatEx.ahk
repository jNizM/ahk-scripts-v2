; ===========================================================================================================================================================================
; GetDurationFormatEx
; Formats a number string as a currency string for a locale specified by name.
; ===========================================================================================================================================================================

GetCurrencyFormatEx(Value, LocaleName := "!x-sys-default-locale")
{
	if (Size := DllCall("GetCurrencyFormatEx", "Str", LocaleName, "UInt", 0, "Str", Value, "Ptr", 0, "Ptr", 0, "Int", 0))
	{
		Size := VarSetStrCapacity(&CurrencyStr, Size)
		if (Size := DllCall("GetCurrencyFormatEx", "Str", LocaleName, "UInt", 0, "Str", Value, "Ptr", 0, "Str", CurrencyStr, "Int", Size))
		{
			return CurrencyStr
		}
	}
	return ""
}

; ===========================================================================================================================================================================

MsgBox GetCurrencyFormatEx(1149.99)					; 1.149,99 €		( LANG_USER_DEFAULT | SUBLANG_DEFAULT    )		(GERMAN HERE)
MsgBox GetCurrencyFormatEx(1149.99, "en-US")		; $1,149.99			( LANG_ENGLISH      | SUBLANG_ENGLISH_US )
MsgBox GetCurrencyFormatEx(1149.99, "en-GB")		; £1,149.99			( LANG_ENGLISH      | SUBLANG_ENGLISH_UK )
MsgBox GetCurrencyFormatEx(1149.99, "de-DE")		; 1.149,99 €		( LANG_GERMAN       | SUBLANG_GERMAN     )
