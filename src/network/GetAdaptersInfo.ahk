; ===============================================================================================================================
; Gets network adapter information for the local computer.
; Tested with AutoHotkey v2.0-a132
; ===============================================================================================================================

GetAdaptersInfo()
{
	static ERROR_SUCCESS                  := 0
	static ERROR_BUFFER_OVERFLOW          := 111
	static MAX_ADAPTER_NAME_LENGTH        := 256
	static MAX_ADAPTER_DESCRIPTION_LENGTH := 128
	static MAX_ADAPTER_ADDRESS_LENGTH     := 8
	static IF_TYPE := Map( 1, "OTHER", 6, "ETHERNET", 9, "ISO88025_TOKENRING", 23, "PPP", 24, "LOOPBACK", 28, "SLIP", 71, "IEEE80211" )

	if (DllCall("iphlpapi\GetAdaptersInfo", "ptr", 0, "uint*", &size := 0) = ERROR_BUFFER_OVERFLOW)
	{
		buf := BufferAlloc(size, 0)
		if (DllCall("iphlpapi\GetAdaptersInfo", "ptr", buf, "uint*", size) = ERROR_SUCCESS)
		{
			ADAPTER_INFO := Map()
			addr := buf.ptr
			while (addr)
			{
				offset := A_PtrSize, Address := ""

				ADAPTER := Map()
				ADAPTER["ComboIndex"]          := NumGet(addr + offset, "uint"), offset += 4
				ADAPTER["AdapterName"]         := StrGet(addr + offset, MAX_ADAPTER_NAME_LENGTH + 4, "cp0"), offset += MAX_ADAPTER_NAME_LENGTH + 4
				ADAPTER["Description"]         := StrGet(addr + offset, MAX_ADAPTER_DESCRIPTION_LENGTH + 4, "cp0"), offset += MAX_ADAPTER_DESCRIPTION_LENGTH + 4
				ADAPTER["AddressLength"]       := NumGet(addr + offset, "uint"), offset += 4
				loop ADAPTER["AddressLength"]
					Address .= Format("{:02x}",   NumGet(addr + offset, A_Index - 1, "uchar")) ":"
				ADAPTER["Address"]             := SubStr(Address, 1, -1), offset += MAX_ADAPTER_ADDRESS_LENGTH
				ADAPTER["Index"]               := NumGet(addr + offset, "uint"), offset += 4
				ADAPTER["Type"]                := IF_TYPE[NumGet(addr + offset, "uint")], offset += 4
				ADAPTER["DhcpEnabled"]         := NumGet(addr + offset, "uint"), offset += A_PtrSize
				PIP_ADDR_STRING                := NumGet(addr + offset + A_PtrSize, "uptr"), offset += A_PtrSize
				ADAPTER["IpAddressList"]       := StrGet(addr + offset + A_PtrSize, "cp0")
				ADAPTER["IpMaskList"]          := StrGet(addr + offset + A_PtrSize + 16, "cp0"), offset += A_PtrSize + 32 + A_PtrSize
				ADAPTER["GatewayList"]         := StrGet(addr + offset + A_PtrSize, "cp0"), offset += A_PtrSize + 32 + A_PtrSize
				ADAPTER["DhcpServer"]          := StrGet(addr + offset + A_PtrSize, "cp0"), offset += A_PtrSize + 32 + A_PtrSize
				ADAPTER["HaveWins"]            := NumGet(addr + offset, "int"), offset += A_PtrSize
				ADAPTER["PrimaryWinsServer"]   := StrGet(addr + offset + A_PtrSize, "cp0"), offset += A_PtrSize + 32 + A_PtrSize
				ADAPTER["SecondaryWinsServer"] := StrGet(addr + offset + A_PtrSize, "cp0"), offset += A_PtrSize + 32 + A_PtrSize
				ADAPTER["LeaseObtained"]       := ConvertUnixTime(NumGet(addr + offset, "int")), offset += A_PtrSize
				ADAPTER["LeaseExpires"]        := ConvertUnixTime(NumGet(addr + offset, "int"))

				ADAPTER_INFO[A_Index] := ADAPTER
				addr := NumGet(addr, "uptr")
			}
			return ADAPTER_INFO
		}
	}
	return ""
}


ConvertUnixTime(value)
{
	unix := 19700101
	unix := DateAdd(unix, value, "seconds")
	return FormatTime(unix, "yyyy-MM-dd HH:mm:ss")
}

; ===============================================================================================================================

Adapters := GetAdaptersInfo()
for i, v in Adapters {
	output := ""
	for k, v in Adapters[i]
		output .= k ": " v "`n"
	MsgBox(output)
}
