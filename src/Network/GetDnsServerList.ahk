; =============================================================================================================================================================
; Author ........: jNizM
; Released ......: 2021-04-22
; Modified ......: 2023-01-12
; Tested with....: AutoHotkey v2.0.2 (x64)
; Tested on .....: Windows 11 - 22H2 (x64)
; Function ......: GetDnsServerList()
;
; Parameter(s)...: No parameters used
;
; Return ........: Gets a list of DNS servers for the local computer.
; =============================================================================================================================================================

#Requires AutoHotkey v2.0


GetDnsServerList()
{
	static ERROR_SUCCESS := 0
	static ERROR_BUFFER_OVERFLOW := 111

	if (DllCall("iphlpapi\GetNetworkParams", "Ptr", 0, "UInt*", &Size := 0, "UInt") = ERROR_BUFFER_OVERFLOW)
	{
		Buf := Buffer(Size)
		if (DllCall("iphlpapi\GetNetworkParams", "Ptr", Buf, "UInt*", Size, "UInt") = ERROR_SUCCESS)
		{
			DNS_SERVERS := Array()
			DNS_SERVERS.Push(StrGet(Buf.Ptr + 264 + (A_PtrSize * 2), "CP0"))
			IPAddr := NumGet(Buf.Ptr + 264 + A_PtrSize, "UPtr")
			while (IPAddr)
			{
				DNS_SERVERS.Push(StrGet(IPAddr + A_PtrSize, "CP0"))
				IPAddr := NumGet(IPAddr, "UPtr")
			}
			return DNS_SERVERS
		}
	}
	return
}


; =============================================================================================================================================================
; Example
; =============================================================================================================================================================

DNS := GetDnsServerList()
loop DNS.Length
	MsgBox DNS[A_Index]