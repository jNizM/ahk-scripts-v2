; ===========================================================================================================================================================================
; GetNumberFormat
; Formats a number string as a number string customized for a locale specified by identifier.
; ===========================================================================================================================================================================

GetNumberFormat(Value, Locale := 0x0400)
{
	if (Size := DllCall("GetNumberFormatW", "UInt", Locale, "UInt", 0, "Str", Value, "Ptr", 0, "Ptr", 0, "Int", 0))
	{
		Size := VarSetStrCapacity(&NumberStr, Size)
		if (Size := DllCall("GetNumberFormatW", "UInt", Locale, "UInt", 0, "Str", Value, "Ptr", 0, "Str", NumberStr, "Int", Size))
		{
			return NumberStr
		}
	}
	return ""
}

; ===========================================================================================================================================================================

MsgBox GetNumberFormat(1149.99)				; 1.149,99			( LANG_USER_DEFAULT | SUBLANG_DEFAULT    )		(GERMAN HERE)
MsgBox GetNumberFormat(1149.99, 0x0409)		; 1,149.99			( LANG_ENGLISH      | SUBLANG_ENGLISH_US )
MsgBox GetNumberFormat(1149.99, 0x0809)		; 1,149.99			( LANG_ENGLISH      | SUBLANG_ENGLISH_UK )
MsgBox GetNumberFormat(1149.99, 0x0407)		; 1.149,99			( LANG_GERMAN       | SUBLANG_GERMAN     )
