; =============================================================================================================================================================
; Author ........: jNizM
; Released ......: 2023-01-17
; Modified ......: 2023-01-17
; Tested with....: AutoHotkey v2.0.2 (x64)
; Tested on .....: Windows 11 - 22H2 (x64)
; Function ......: DnsServerList()
;
; Parameter(s)...: No parameters used
;
; Return ........: Gets a list of DNS servers for the local computer.
; =============================================================================================================================================================

#Requires AutoHotkey v2.0


DnsServerList()
{
    static STATUS_SUCCESS         := 0
    static DnsConfigDnsServerList := 6

    DllCall("dnsapi\DnsQueryConfig", "Int", DnsConfigDnsServerList, "UInt", 0, "Ptr", 0, "Ptr", 0, "Ptr", 0, "UInt*", &Size := 0)
    Buf := Buffer(Size)
    DNS_STATUS := DllCall("dnsapi\DnsQueryConfig", "Int", DnsConfigDnsServerList, "UInt", 0, "Ptr", 0, "Ptr", 0, "Ptr", Buf, "UInt*", Buf.Size)

    if (DNS_STATUS = STATUS_SUCCESS)
    {
        DNS_SERVER := Array()
        loop NumGet(Buf, 0, "UInt")
        {
            DNS_SERVER.Push(DllCall("ws2_32\inet_ntoa", "UInt", NumGet(Buf, 4 * A_Index, "UInt"), "AStr"))
        }
        return DNS_SERVER
    }

    throw OSError()
}


; =============================================================================================================================================================
; Example
; =============================================================================================================================================================

DNS := DnsServerList()
loop DNS.Length
    MsgBox DNS[A_Index]