; ===========================================================================================================================================================================
; Gets the Hostname by the IP Adresse (Reverse Lookup) like nslookup.
; Tested with AutoHotkey v2.0-a133
; ===========================================================================================================================================================================

ReverseLookup(IPAddr)
{
	static WSA_SUCCESS    := 0
	static INADDR_ANY     := 0x00000000
	static INADDR_NONE    := 0xffffffff
	static NI_MAXHOST     := 1025

	WSADATA := Buffer(394 + (A_PtrSize - 2) + A_PtrSize, 0)
	if (DllCall("ws2_32\WSAStartup", "ushort", 0x0202, "ptr", WSADATA) != WSA_SUCCESS)
	{
		MsgBox("WSAStartup failed: " DllCall("ws2_32\WSAGetLastError"))
		return -1
	}

	inaddr := DllCall("ws2_32\inet_addr", "astr", IPAddr, "uint")
	if (inaddr = INADDR_ANY) || (inaddr = INADDR_NONE)
	{
		MsgBox("inet_addr failed")
		DllCall("ws2_32\WSACleanup")
		return -1
	}

	Sockaddr := Buffer(16, 0)
	NumPut("short", AF_INET := 2, Sockaddr, 0)
	NumPut("ptr",   inaddr,       Sockaddr, 4)
	HostName := Buffer(NI_MAXHOST << 1, 0)
	if (DllCall("ws2_32\GetNameInfoW", "ptr", Sockaddr, "uint", Sockaddr.Size, "ptr", HostName, "uint", NI_MAXHOST, "ptr", 0, "uint", 0, "int", 0) != WSA_SUCCESS)
	{
		MsgBox("GetNameInfoW failed with error: " DllCall("ws2_32\WSAGetLastError"))
		DllCall("ws2_32\WSACleanup")
		return -1
	}

	DllCall("ws2_32\WSACleanup")
	return StrGet(HostName)
}

; ===========================================================================================================================================================================

MsgBox(ReverseLookup("1.1.1.1"))
