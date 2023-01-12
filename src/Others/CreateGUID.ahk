; =============================================================================================================================================================
; Author ........: jNizM
; Released ......: 2021-10-13
; Modified ......: 2023-01-12
; Tested with....: AutoHotkey v2.0.2 (x64)
; Tested on .....: Windows 11 - 22H2 (x64)
; Function ......: CreateGUID()
;
; Parameter(s)...: No parameters used
;
; Return ........: Creates an Globally Unique IDentifier (GUID).
;                  A GUID provides a unique 128-bit integer used for CLSIDs and interface identifiers.
; =============================================================================================================================================================

#Requires AutoHotkey v2.0


CreateGUID()
{
	static S_OK := 0, GUID := ""

	pGUID := Buffer(16)
	if (DllCall("ole32\CoCreateGuid", "Ptr", pGUID) = S_OK)
	{
		Size := VarSetStrCapacity(&GUID, 38)
		if (DllCall("ole32\StringFromGUID2", "Ptr", pGUID, "Str", GUID, "Int", Size + 1))
		{
			return GUID
		}
	}
	return
}


; =============================================================================================================================================================
; Example
; =============================================================================================================================================================

MsgBox CreateGUID()