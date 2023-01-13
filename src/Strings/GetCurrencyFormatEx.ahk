; =============================================================================================================================================================
; Author ........: jNizM
; Released ......: 2015-11-02
; Modified ......: 2023-01-13
; Tested with....: AutoHotkey v2.0.2 (x64)
; Tested on .....: Windows 11 - 22H2 (x64)
; Function ......: GetCurrencyFormatEx()
;
; Parameter(s)...: Value
;                  Locale Name (<language>-<REGION> - see https://learn.microsoft.com/en-us/windows/win32/intl/locale-names)
;
; Return ........: Formats a number string as a currency string for a locale specified by name.
; =============================================================================================================================================================

#Requires AutoHotkey v2.0


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
	return
}


; =============================================================================================================================================================
; Example
; =============================================================================================================================================================

MsgBox GetCurrencyFormatEx(1149.99)             ; 1.149,99 €    ( LANG_USER_DEFAULT | SUBLANG_DEFAULT    )    (for me it is german)
MsgBox GetCurrencyFormatEx(1149.99, "en-US")    ; $1,149.99     ( LANG_ENGLISH      | SUBLANG_ENGLISH_US )
MsgBox GetCurrencyFormatEx(1149.99, "en-GB")    ; £1,149.99     ( LANG_ENGLISH      | SUBLANG_ENGLISH_UK )
MsgBox GetCurrencyFormatEx(1149.99, "de-DE")    ; 1.149,99 €    ( LANG_GERMAN       | SUBLANG_GERMAN     )