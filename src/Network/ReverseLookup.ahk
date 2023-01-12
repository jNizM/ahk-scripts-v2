; =============================================================================================================================================================
; Author ........: jNizM
; Released ......: 2021-04-30
; Modified ......: 2023-01-12
; Tested with....: AutoHotkey v2.0.2 (x64)
; Tested on .....: Windows 11 - 22H2 (x64)
; Function ......: ReverseLookup( HostName )
;
; Parameter(s)...: IPAddr - the IP Address to be resolved
;
; Return ........: Gets the Hostname by the IP Adresse (Reverse Lookup) like nslookup.
; =============================================================================================================================================================

#Requires AutoHotkey v2.0


ReverseLookup(IPAddr)
{
	static WSA_SUCCESS    := 0
	static INADDR_ANY     := 0x00000000
	static INADDR_NONE    := 0xffffffff
	static NI_MAXHOST     := 1025
	static AF_INET        := 2

	WSADATA := Buffer(394 + (A_PtrSize - 2) + A_PtrSize)
	if (DllCall("ws2_32\WSAStartup", "UShort", 0x0202, "Ptr", WSADATA) != WSA_SUCCESS)
	{
		throw OSError(DllCall("ws2_32\WSAGetLastError"))
	}

	inaddr := DllCall("ws2_32\inet_addr", "AStr", IPAddr, "UInt")
	if (inaddr = INADDR_ANY) || (inaddr = INADDR_NONE)
	{
		DllCall("ws2_32\WSACleanup")
		throw OSError(DllCall("ws2_32\WSAGetLastError"))
	}

	Sockaddr := Buffer(16)
	NumPut("Short", AF_INET, Sockaddr, 0)
	NumPut("Ptr", inaddr, Sockaddr, 4)
	HostName := Buffer(NI_MAXHOST << 1, 0)
	if (DllCall("ws2_32\GetNameInfoW", "Ptr", Sockaddr, "UInt", Sockaddr.Size, "Ptr", HostName, "UInt", NI_MAXHOST, "Ptr", 0, "UInt", 0, "Int", 0) != WSA_SUCCESS)
	{
		DllCall("ws2_32\WSACleanup")
		throw OSError(DllCall("ws2_32\WSAGetLastError"))
	}

	DllCall("ws2_32\WSACleanup")
	return StrGet(HostName)
}


; =============================================================================================================================================================
; Example
; =============================================================================================================================================================

MsgBox ReverseLookup("1.1.1.1")