; ===============================================================================================================================
; Gets a list of DNS servers for the local computer.
; Tested with AutoHotkey v2.0-a132
; ===============================================================================================================================

GetDnsServerList()
{
	static ERROR_SUCCESS := 0
	static ERROR_BUFFER_OVERFLOW := 111

	if (DllCall("iphlpapi\GetNetworkParams", "ptr", 0, "uint*", &len := 0) = ERROR_BUFFER_OVERFLOW)
	{
		buf := BufferAlloc(len, 0)
		if (DllCall("iphlpapi\GetNetworkParams", "ptr", buf, "uint*", len) = ERROR_SUCCESS)
		{
			DNS_SERVERS := Array()
			DNS_SERVERS.Push(StrGet(buf.ptr + 264 + (A_PtrSize * 2), "cp0"))
			pIPAddr := NumGet(buf.ptr + 264 + A_PtrSize, "uptr")
			while (pIPAddr)
			{
				DNS_SERVERS.Push(StrGet(pIPAddr + A_PtrSize, "cp0"))
				pIPAddr := NumGet(pIPAddr, "uptr")
			}
			return DNS_SERVERS
		}
	}
	return
}

; ===============================================================================================================================

DNS := GetDnsServerList()
loop DNS.Length
	MsgBox(DNS[A_Index])
