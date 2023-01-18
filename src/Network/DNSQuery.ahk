; =============================================================================================================================================================
; Author(s) .....: jNizM, just me
; Released ......: 2013-11-02
; Modified ......: 2023-01-18
; Tested with....: AutoHotkey v2.0.2 (x64)
; Tested on .....: Windows 11 - 22H2 (x64)
; Function ......: DNSQuery()
;
; Parameter(s)...: [in]      Name   - String that represents the DNS name to query
;                  [in]      Type   - DNS Record Type   (https://learn.microsoft.com/en-us/windows/win32/dns/dns-constants#dns-record-types)
;                  [in, opt] Option - DNS Query Options (https://learn.microsoft.com/en-us/windows/win32/dns/dns-constants#dns-query-options)
;
; Return ........: Retrieves the Resource Record (RR) depends on DNS Record Type.
; =============================================================================================================================================================

#Requires AutoHotkey v2.0

#DllLoad "dnsapi.dll"
#DllLoad "ntdll.dll"


DNSQuery(Name, Type, Options := 0)
{
    static STATUS_SUCCESS     := 0
    static DnsFreeRecordList  := 1
    static RECORD_DATA        := (A_PtrSize * 2) + 16
    static DNS_TYPE := Map("A", 0x0001, "NS", 0x0002, "CNAME", 0x0005, "SOA", 0x0006, "PTR", 0x000c, "MX", 0x000f, "TEXT", 0x0010, "AAAA", 0x001c)

    if !(DNS_TYPE.Has(Type))
        throw Error()

    DNS_STATUS := DllCall("dnsapi\DnsQuery_W", "Str", Name, "Short", DNS_TYPE[Type], "UInt", Options, "Ptr", 0, "Ptr*", &DNS_RECORD := 0, "Ptr", 0)

    if (DNS_STATUS = STATUS_SUCCESS)
    {
        Addr := DNS_RECORD
        DNS_RECORD_LIST := Map()
        while (Addr)
        {
            LIST := Map()
            RECORD_TYPE  := NumGet(Addr, A_PtrSize * 2, "UShort")
            switch RECORD_TYPE
            {
                case DNS_TYPE["A"]:
                {
                    LIST["IpAddress"] := RtlIpv4AddressToStringW(NumGet(Addr, RECORD_DATA, "UInt"))
                }
                case DNS_TYPE["NS"], DNS_TYPE["CNAME"], DNS_TYPE["PTR"]:
                {
                    LIST["NameHost"] := StrGet(NumGet(Addr, RECORD_DATA, "Ptr"))
                }
                case DNS_TYPE["SOA"]:
                {
                    LIST["NamePrimaryServer"] := StrGet(NumGet(Addr, RECORD_DATA, "Ptr"))
                    LIST["NameAdministrator"] := StrGet(NumGet(Addr + 8, RECORD_DATA, "Ptr"))
                    LIST["SerialNo"]          := NumGet(Addr + 16, RECORD_DATA, "UInt")
                    LIST["Refresh"]           := NumGet(Addr + 20, RECORD_DATA, "UInt")
                    LIST["Retry"]             := NumGet(Addr + 24, RECORD_DATA, "UInt")
                    LIST["Expire"]            := NumGet(Addr + 28, RECORD_DATA, "UInt")
                    LIST["DefaultTtl"]        := NumGet(Addr + 32, RECORD_DATA, "UInt")
                }
                case DNS_TYPE["MX"]:
                {
                    LIST["NameExchange"] := StrGet(NumGet(Addr, RECORD_DATA, "Ptr"))
                    LIST["Preference"]   := NumGet(Addr + 8, RECORD_DATA, "UChar")
                }
                case DNS_TYPE["TEXT"]:
                {
                    LIST["StringArray"] := StrGet(NumGet(Addr + 8, RECORD_DATA, "Ptr"))
                }
                case DNS_TYPE["AAAA"]:
                {
                    LIST["Ip6Address"] := RtlIpv6AddressToStringW(NumGet(Addr, RECORD_DATA, "UInt"))
                }
            }
            DNS_RECORD_LIST[A_Index] := LIST
            try Addr := NumGet(Addr, "Ptr")
        }
        DllCall("dnsapi\DnsRecordListFree", "Ptr", DNS_RECORD, "Int", DnsFreeRecordList)
        return DNS_RECORD_LIST
    }

    throw OSError()
}


RtlIpv4AddressToStringW(IN_ADDR)
{
    Size := VarSetStrCapacity(&StringAddr, 32)
    if (DllCall("ntdll\RtlIpv4AddressToStringW", "Ptr*", IN_ADDR, "Str", StringAddr))
        return StringAddr
    return False
}

RtlIpv6AddressToStringW(IN6_ADDR)
{
    Size := VarSetStrCapacity(&StringAddr, 92)
    if (DllCall("ntdll\RtlIpv6AddressToStringW", "Ptr*", IN6_ADDR, "Str", StringAddr))
        return StringAddr
    return False
}


; =============================================================================================================================================================
; Example(s)
; =============================================================================================================================================================

for i, v in DNS := DNSQuery("www.google.com", "A")
    for k, v in DNS[i]
        MsgBox k ": " v

for i, v in DNS := DNSQuery("www.google.com", "AAAA")
    for k, v in DNS[i]
        MsgBox k ": " v

for i, v in DNS := DNSQuery("learn.microsoft.com", "CNAME")
    for k, v in DNS[i]
        MsgBox k ": " v

for i, v in DNS := DNSQuery("8.8.8.8.IN-ADDR.ARPA", "PTR")
    for k, v in DNS[i]
        MsgBox k ": " v

for i, v in DNS := DNSQuery("google.com", "MX")
    for k, v in DNS[i]
        MsgBox k ": " v

for i, v in DNS := DNSQuery("google.com", "TEXT")
    for k, v in DNS[i]
        MsgBox k ": " v

for i, v in DNS := DNSQuery("google.com", "MX")
    for k, v in DNS[i]
        MsgBox k ": " v

for i, v in DNS := DNSQuery("google.com", "SOA")
    for k, v in DNS[i]
        MsgBox k ": " v
