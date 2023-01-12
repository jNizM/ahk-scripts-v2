; =============================================================================================================================================================
; Author ........: jNizM
; Released ......: 2021-04-30
; Modified ......: 2023-01-12
; Tested with....: AutoHotkey v2.0.2 (x64)
; Tested on .....: Windows 11 - 22H2 (x64)
; Function ......: ResolveHostname( HostName )
;
; Parameter(s)...: HostName - the hostname to be resolved
;
; Return ........: Gets the IP Address from a Hostname (Resolve Hostname to IP Address) like nslookup.
; =============================================================================================================================================================

#Requires AutoHotkey v2.0


ResolveHostname(HostName)
{
	static WSA_SUCCESS := 0
	static AF_INET     := 2
	static SOCK_STREAM := 1
	static IPPROTO_TCP := 6

	WSADATA := Buffer(394 + (A_PtrSize - 2) + A_PtrSize)
	if (DllCall("ws2_32\WSAStartup", "UShort", 0x0202, "Ptr", WSADATA) != WSA_SUCCESS)
	{
		throw OSError(DllCall("ws2_32\WSAGetLastError"))
	}

	hints := Buffer(16 + 4 * A_PtrSize, 0)
	NumPut("Int", AF_INET,     hints,  4)
	NumPut("Int", SOCK_STREAM, hints,  8)
	NumPut("Int", IPPROTO_TCP, hints, 12)
	if (DllCall("ws2_32\GetAddrInfoW", "Str", HostName, "Ptr", 0, "Ptr", hints, "Ptr*", &result := 0) != WSA_SUCCESS)
	{
		DllCall("ws2_32\WSACleanup")
		throw OSError(DllCall("ws2_32\WSAGetLastError"))
	}

	addrinfo := result
	IPList := Array()
	while (addrinfo)
	{
		ai_addr    := NumGet(addrinfo, 16 + 2 * A_PtrSize, "Ptr")
		ai_addrlen := NumGet(addrinfo, 16, "UInt")
		DllCall("ws2_32\WSAAddressToStringW", "Ptr", ai_addr, "UInt", ai_addrlen, "Ptr", 0, "Ptr", 0, "UInt*", &AddressStringLength := 0)
		AddressString := Buffer(AddressStringLength << 1)
		if (DllCall("ws2_32\WSAAddressToStringW", "Ptr", ai_addr, "UInt", ai_addrlen, "Ptr", 0, "Ptr", AddressString, "UInt*", AddressString.Size) != WSA_SUCCESS)
		{
			DllCall("ws2_32\FreeAddrInfoW", "Ptr", result)
			DllCall("ws2_32\WSACleanup")
			throw OSError(DllCall("ws2_32\WSAGetLastError"))
		}
		IPList.Push(StrGet(AddressString))
		addrinfo := NumGet(addrinfo, 16 + 3 * A_PtrSize, "Ptr")
	}

	DllCall("ws2_32\FreeAddrInfoW", "Ptr", result)
	DllCall("ws2_32\WSACleanup")
	return IPList
}


; =============================================================================================================================================================
; Example
; =============================================================================================================================================================

IPList := ResolveHostname("one.one.one.one")

loop IPList.Length
	MsgBox IPList[A_Index]