; =============================================================================================================================================================
; Author ........: jNizM
; Released ......: 2021-10-13
; Modified ......: 2023-01-12
; Tested with....: AutoHotkey v2.0.2 (x64)
; Tested on .....: Windows 11 - 22H2 (x64)
; Function ......: CreateUUID()
;
; Parameter(s)...: No parameters used
;
; Return ........: Creates an Universally Unique IDentifier (UUID).
;                  A UUID provides a unique designation of an object such as an interface, a manager entry-point vector, or a client object.
; =============================================================================================================================================================

#Requires AutoHotkey v2.0


CreateUUID()
{
	static RPC_S_OK := 0, UUID := ""

	pUUID := Buffer(16)
	if (DllCall("rpcrt4\UuidCreate", "Ptr", pUUID) = RPC_S_OK)
	{
		if (DllCall("rpcrt4\UuidToStringW", "Ptr", pUUID, "Ptr*", &StringUuid := 0) = RPC_S_OK)
		{
			UUID := StrGet(StringUuid)
			DllCall("rpcrt4\RpcStringFreeW", "Ptr*", StringUuid)
		}
	}
	return UUID
}


; =============================================================================================================================================================
; Example
; =============================================================================================================================================================

MsgBox CreateUUID()