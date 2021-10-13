; ===========================================================================================================================================================================
; Creates an Universally Unique IDentifier (UUID)
; A UUID provides a unique designation of an object such as an interface, a manager entry-point vector, or a client object.
; ===========================================================================================================================================================================

CreateUUID()
{
	static RPC_S_OK := 0, UUID := ""

	PUUID := Buffer(16, 0)
	if (DllCall("rpcrt4\UuidCreate", "Ptr", PUUID) = RPC_S_OK)
	{
		if (DllCall("rpcrt4\UuidToStringW", "Ptr", PUUID, "Ptr*", &StringUuid := 0) = RPC_S_OK)
		{
			UUID := StrGet(StringUuid)
			DllCall("rpcrt4\RpcStringFreeW", "Ptr*", StringUuid)
		}
	}
	return UUID
}

; ===========================================================================================================================================================================

MsgBox CreateUUID()
