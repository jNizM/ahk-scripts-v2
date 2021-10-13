; ===========================================================================================================================================================================
; GetDurationFormatEx
; Formats a duration of time as a time string for a locale specified by name. (Duration * 10000 = in ms | Duration * 10000000 = in sec)
; ===========================================================================================================================================================================

GetDurationFormatEx(Duration, Format := "", LocaleName := "!x-sys-default-locale")
{
	if (Size := DllCall("GetDurationFormatEx", "Str", LocaleName, "UInt", 0, "Ptr", 0, "Int64", Duration * 10000, "Ptr", (Format ? StrPtr(Format) : 0), "Ptr", 0, "Int", 0))
	{
		Size := VarSetStrCapacity(&DurationStr, Size)
		if (Size := DllCall("GetDurationFormatEx", "Str", LocaleName, "UInt", 0, "Ptr", 0, "Int64", Duration * 10000, "Ptr", (Format ? StrPtr(Format) : 0), "Str", DurationStr, "Int", Size))
		{
			return DurationStr
		}
	}
	return ""
}

; ===========================================================================================================================================================================

MsgBox GetDurationFormatEx(817000)                                    ; 13:37
MsgBox GetDurationFormatEx(421337, "hh:mm:ss.fff")                    ; 00:07:01.337
MsgBox GetDurationFormatEx(2520000, "mm' Minutes")                    ; 42 Minutes
MsgBox GetDurationFormatEx(43140000, "hh' Hours and 'mm' Minutes")    ; 11 Hours and 59 Minutes
