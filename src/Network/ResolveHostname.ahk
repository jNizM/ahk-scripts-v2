; ===========================================================================================================================================================================
; Gets the IP Address from a Hostname (Resolve Hostname to IP Address) like nslookup.
; Tested with AutoHotkey v2.0-a133
; ===========================================================================================================================================================================

ResolveHostname(HostName)
{
	static WSA_SUCCESS := 0

	WSADATA := Buffer(394 + (A_PtrSize - 2) + A_PtrSize, 0)
	if (DllCall("ws2_32\WSAStartup", "ushort", 0x0202, "ptr", WSADATA) != WSA_SUCCESS)
	{
		MsgBox("WSAStartup failed: " DllCall("ws2_32\WSAGetLastError"))
		return -1
	}

	hints := Buffer(16 + 4 * A_PtrSize, 0)
	NumPut("int", AF_INET     := 2, hints,  4)
	NumPut("int", SOCK_STREAM := 1, hints,  8)
	NumPut("int", IPPROTO_TCP := 6, hints, 12)
	if (DllCall("ws2_32\GetAddrInfoW", "wstr", HostName, "ptr", 0, "ptr", hints, "ptr*", &result := 0) != WSA_SUCCESS)
	{
		MsgBox("GetAddrInfoW failed with error: " DllCall("ws2_32\WSAGetLastError"))
		DllCall("ws2_32\WSACleanup")
		return -1
	}

	addrinfo := result
	IPList := Array()
	while (addrinfo)
	{
		ai_addr    := NumGet(addrinfo, 16 + 2 * A_PtrSize, "ptr")
		ai_addrlen := NumGet(addrinfo, 16, "uint")
		DllCall("ws2_32\WSAAddressToStringW", "ptr", ai_addr, "uint", ai_addrlen, "ptr", 0, "ptr", 0, "uint*", &AddressStringLength := 0)
		AddressString := Buffer(AddressStringLength << 1, 0)
		if (DllCall("ws2_32\WSAAddressToStringW", "ptr", ai_addr, "uint", ai_addrlen, "ptr", 0, "ptr", AddressString, "uint*", AddressString.Size) != WSA_SUCCESS)
		{
			MsgBox("WSAAddressToStringW failed with error: " DllCall("ws2_32\WSAGetLastError"))
			DllCall("ws2_32\FreeAddrInfoW", "ptr", result)
			DllCall("ws2_32\WSACleanup")
			return -1
		}
		IPList.Push(StrGet(AddressString))
		addrinfo := NumGet(addrinfo, 16 + 3 * A_PtrSize, "ptr")
	}

	DllCall("ws2_32\FreeAddrInfoW", "ptr", result)
	DllCall("ws2_32\WSACleanup")
	return IPList
}

; ===========================================================================================================================================================================

IPList := ResolveHostname("one.one.one.one")

loop IPList.Length
	MsgBox(IPList[A_Index])
