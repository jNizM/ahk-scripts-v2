; ===========================================================================================================================================================================
; GetNumberFormatEx
; Formats a number string as a number string customized for a locale specified by name.
; ===========================================================================================================================================================================

GetNumberFormatEx(Value, LocaleName := "!x-sys-default-locale")
{
	if (Size := DllCall("GetNumberFormatEx", "Str", LocaleName, "UInt", 0, "Str", Value, "Ptr", 0, "Ptr", 0, "Int", 0))
	{
		Size := VarSetStrCapacity(&NumberStr, Size)
		if (Size := DllCall("GetNumberFormatEx", "Str", LocaleName, "UInt", 0, "Str", Value, "Ptr", 0, "Str", NumberStr, "Int", Size))
		{
			return NumberStr
		}
	}
	return ""
}

; ===========================================================================================================================================================================

MsgBox GetNumberFormatEx(1149.99)				; 1.149,99			( LANG_USER_DEFAULT | SUBLANG_DEFAULT    )		(GERMAN HERE)
MsgBox GetNumberFormatEx(1149.99, "en-US")		; 1,149.99			( LANG_ENGLISH      | SUBLANG_ENGLISH_US )
MsgBox GetNumberFormatEx(1149.99, "en-GB")		; 1,149.99			( LANG_ENGLISH      | SUBLANG_ENGLISH_UK )
MsgBox GetNumberFormatEx(1149.99, "de-DE")		; 1.149,99			( LANG_GERMAN       | SUBLANG_GERMAN     )
