; ===========================================================================================================================================================================
; Returns a SYSTEM_PROCESS_INFORMATION structure from the NtQuerySystemInformation function.
; Tested with AutoHotkey v2.0-beta.3
; ===========================================================================================================================================================================

SystemProcessInformation()
{
	#DllLoad "ntdll.dll"

	static STATUS_SUCCESS             := 0x00000000
	static SYSTEM_PROCESS_INFORMATION := 0x00000005

	DllCall("ntdll\NtQuerySystemInformation", "Int", SYSTEM_PROCESS_INFORMATION, "Ptr", 0, "UInt", 0, "UInt*", &Size := 0, "UInt")
	Buf := Buffer(Size, 0)
	if (DllCall("ntdll\NtQuerySystemInformation", "Int", SYSTEM_PROCESS_INFORMATION, "Ptr", Buf.Ptr, "UInt", Buf.Size, "UInt*", 0, "UInt") = STATUS_SUCCESS)
	{
		PROCESS_INFORMATION := Map()
		Addr := Buf.Ptr
		while (Addr)
		{
			PROCESS := Map()
			PROCESS["NumberOfThreads"]              := NumGet(Addr, 0x0004, "UInt")
			PROCESS["WorkingSetPrivateSize"]        := NumGet(Addr, 0x0008, "Int64")
			PROCESS["HardFaultCount"]               := NumGet(Addr, 0x0010, "UInt")
			PROCESS["NumberOfThreadsHighWatermark"] := NumGet(Addr, 0x0014, "UInt")
			PROCESS["CycleTime"]                    := NumGet(Addr, 0x0018, "UInt64")
			PROCESS["CreateTime"]                   := NumGet(Addr, 0x0020, "Int64")
			PROCESS["UserTime"]                     := NumGet(Addr, 0x0028, "Int64")
			PROCESS["KernelTime"]                   := NumGet(Addr, 0x0030, "Int64")
			PROCESS["ImageName"]                    := (Ptr := NumGet(Addr, 0x0040, "Ptr")) ? StrGet(Ptr) : ""
			PROCESS["BasePriority"]                 := NumGet(Addr, 0x0048, "Int")
			PROCESS["UniqueProcessId"]              := NumGet(Addr, 0x0050, "Ptr")
			PROCESS["InheritedFromUniqueProcessId"] := NumGet(Addr, 0x0058, "Ptr*")
			PROCESS["HandleCount"]                  := NumGet(Addr, 0x0060, "UInt")
			PROCESS["SessionId"]                    := NumGet(Addr, 0x0064, "UInt")
			PROCESS["UniqueProcessKey"]             := NumGet(Addr, 0x0068, "UPtr")
			PROCESS["PeakVirtualSize"]              := NumGet(Addr, 0x0070, "UPtr")
			PROCESS["VirtualSize"]                  := NumGet(Addr, 0x0078, "UPtr")
			PROCESS["PageFaultCount"]               := NumGet(Addr, 0x0080, "UInt")
			PROCESS["PeakWorkingSetSize"]           := NumGet(Addr, 0x0088, "UPtr")
			PROCESS["WorkingSetSize"]               := NumGet(Addr, 0x0090, "UPtr")
			PROCESS["QuotaPeakPagedPoolUsage"]      := NumGet(Addr, 0x0098, "UPtr")
			PROCESS["QuotaPagedPoolUsage"]          := NumGet(Addr, 0x00A0, "UPtr")
			PROCESS["QuotaPeakNonPagedPoolUsage"]   := NumGet(Addr, 0x00A8, "UPtr")
			PROCESS["QuotaNonPagedPoolUsage"]       := NumGet(Addr, 0x00B0, "UPtr")
			PROCESS["PagefileUsage"]                := NumGet(Addr, 0x00B8, "UPtr")
			PROCESS["PeakPagefileUsage"]            := NumGet(Addr, 0x00C0, "UPtr")
			PROCESS["PrivatePageCount"]             := NumGet(Addr, 0x00C8, "UPtr")
			PROCESS["ReadOperationCount"]           := NumGet(Addr, 0x00D0, "Int64")
			PROCESS["WriteOperationCount"]          := NumGet(Addr, 0x00D8, "Int64")
			PROCESS["OtherOperationCount"]          := NumGet(Addr, 0x00E0, "Int64")
			PROCESS["ReadTransferCount"]            := NumGet(Addr, 0x00E8, "Int64")
			PROCESS["WriteTransferCount"]           := NumGet(Addr, 0x00F0, "Int64")
			PROCESS["OtherTransferCount"]           := NumGet(Addr, 0x00F8, "Int64")
			PROCESS_INFORMATION[A_Index]            := PROCESS

			if !(NumGet(Addr, 0x0000, "UInt"))
				break
			Addr += NumGet(Addr, 0x0000, "UInt")
		}
		return PROCESS_INFORMATION
	}
	return false
}

; Example ===================================================================================================================================================================

Proc := SystemProcessInformation()
for i, v in Proc {
	for k, v in Proc[i]
		MsgBox k ": " v
}