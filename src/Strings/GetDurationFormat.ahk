; ===========================================================================================================================================================================
; GetDurationFormat
; Formats a duration of time as a time string for a locale specified by identifier. (Duration * 10000 = in ms | Duration * 10000000 = in sec)
; ===========================================================================================================================================================================

GetDurationFormat(Duration, Format := "", Locale := 0x0400)
{
	if (Size := DllCall("GetDurationFormat", "UInt", Locale, "UInt", 0, "Ptr", 0, "Int64", Duration * 10000, "Ptr", (Format ? StrPtr(Format) : 0), "Ptr", 0, "Int", 0))
	{
		Size := VarSetStrCapacity(&DurationStr, Size)
		if (Size := DllCall("GetDurationFormat", "UInt", Locale, "UInt", 0, "Ptr", 0, "Int64", Duration * 10000, "Ptr", (Format ? StrPtr(Format) : 0), "Str", DurationStr, "Int", Size))
		{
			return DurationStr
		}
	}
	return ""
}

; ===========================================================================================================================================================================

MsgBox GetDurationFormat(817000)									; 13:37
MsgBox GetDurationFormat(421337, "hh:mm:ss.fff")					; 00:07:01.337
MsgBox GetDurationFormat(2520000, "mm' Minutes")					; 42 Minutes
MsgBox GetDurationFormat(43140000, "hh' Hours and 'mm' Minutes")	; 11 Hours and 59 Minutes
