; =============================================================================================================================================================
; Author ........: jNizM
; Released ......: 2021-04-23
; Modified ......: 2023-01-12
; Tested with....: AutoHotkey v2.0.2 (x64)
; Tested on .....: Windows 11 - 22H2 (x64)
; Function ......: GetAdaptersInfo()
;
; Parameter(s)...: No parameters used
;
; Return ........: Gets network adapter information for the local computer.
; =============================================================================================================================================================

#Requires AutoHotkey v2.0


GetAdaptersInfo()
{
	static ERROR_SUCCESS                  := 0
	static ERROR_BUFFER_OVERFLOW          := 111
	static MAX_ADAPTER_NAME_LENGTH        := 256
	static MAX_ADAPTER_DESCRIPTION_LENGTH := 128
	static MAX_ADAPTER_ADDRESS_LENGTH     := 8
	static IF_TYPE := Map(1, "OTHER", 6, "ETHERNET", 9, "TOKENRING", 23, "PPP", 24, "LOOPBACK", 28, "SLIP", 71, "IEEE80211")

	if (DllCall("iphlpapi\GetAdaptersInfo", "Ptr", 0, "UInt*", &Size := 0, "UInt") = ERROR_BUFFER_OVERFLOW)
	{
		Buf := Buffer(Size)
		if (DllCall("iphlpapi\GetAdaptersInfo", "Ptr", Buf, "UInt*", Size, "UInt") = ERROR_SUCCESS)
		{
			ADAPTER_INFO := Map()
			Addr := Buf.Ptr
			while (Addr)
			{
				Offset := A_PtrSize, Address := ""

				ADAPTER := Map()
				ADAPTER["ComboIndex"]          := NumGet(Addr + Offset, "UInt"),                                    Offset += 4
				ADAPTER["AdapterName"]         := StrGet(Addr + Offset, MAX_ADAPTER_NAME_LENGTH + 4, "CP0"),        Offset += MAX_ADAPTER_NAME_LENGTH + 4
				ADAPTER["Description"]         := StrGet(Addr + Offset, MAX_ADAPTER_DESCRIPTION_LENGTH + 4, "CP0"), Offset += MAX_ADAPTER_DESCRIPTION_LENGTH + 4
				AddressLength                  := NumGet(Addr + Offset, "UInt"),                                    Offset += 4
				loop AddressLength
					Address .= Format("{:02x}",   NumGet(Addr + Offset + A_Index - 1, "UChar")) ":"
				ADAPTER["Address"]             := SubStr(Address, 1, -1),                                           Offset += MAX_ADAPTER_ADDRESS_LENGTH
				ADAPTER["Index"]               := NumGet(Addr + Offset, "UInt"),                                    Offset += 4
				ADAPTER["Type"]                := IF_TYPE[NumGet(Addr + Offset, "UInt")],                           Offset += 4
				ADAPTER["DhcpEnabled"]         := NumGet(Addr + Offset, "UInt"),                                    Offset += A_PtrSize
				CurrentIpAddress               := NumGet(Addr + Offset + A_PtrSize, "Ptr"),                         Offset += A_PtrSize
				ADAPTER["IpAddressList"]       := StrGet(Addr + Offset + A_PtrSize, "CP0")
				ADAPTER["IpMaskList"]          := StrGet(Addr + Offset + A_PtrSize + 16, "CP0"),                    Offset += A_PtrSize + 32 + A_PtrSize
				ADAPTER["GatewayList"]         := StrGet(Addr + Offset + A_PtrSize, "CP0"),                         Offset += A_PtrSize + 32 + A_PtrSize
				ADAPTER["DhcpServer"]          := StrGet(Addr + Offset + A_PtrSize, "CP0"),                         Offset += A_PtrSize + 32 + A_PtrSize
				ADAPTER["HaveWins"]            := NumGet(Addr + Offset, "Int"),                                     Offset += A_PtrSize
				ADAPTER["PrimaryWinsServer"]   := StrGet(Addr + Offset + A_PtrSize, "CP0"),                         Offset += A_PtrSize + 32 + A_PtrSize
				ADAPTER["SecondaryWinsServer"] := StrGet(Addr + Offset + A_PtrSize, "CP0"),                         Offset += A_PtrSize + 32 + A_PtrSize
				ADAPTER["LeaseObtained"]       := ConvertUnixTime(NumGet(Addr + Offset, "Int")),                    Offset += A_PtrSize
				ADAPTER["LeaseExpires"]        := ConvertUnixTime(NumGet(Addr + Offset, "Int"))
				ADAPTER_INFO[A_Index] := ADAPTER

				Addr := NumGet(Addr, "Ptr")
			}
			return ADAPTER_INFO
		}
	}
	return
}


ConvertUnixTime(value)
{
	unix := 19700101
	unix := DateAdd(unix, value, "seconds")
	return FormatTime(unix, "yyyy-MM-dd HH:mm:ss")
}


; =============================================================================================================================================================
; Example
; =============================================================================================================================================================

Adapters := GetAdaptersInfo()
for i, v in Adapters {
	output := ""
	for k, v in Adapters[i]
		output .= k ": " v "`n"
	MsgBox output
}