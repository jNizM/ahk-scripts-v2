; =============================================================================================================================================================
; Author ........: jNizM
; Released ......: 2021-12-22
; Modified ......: 2023-01-13
; Tested with....: AutoHotkey v2.0.2 (x64)
; Tested on .....: Windows 11 - 22H2 (x64)
; Function ......: SystemProcessInformation()
;
; Parameter(s)...: [Optional] ProcessID or ProcessName
;
; Return ........: Returns a SYSTEM_PROCESS_INFORMATION structure from the NtQuerySystemInformation function.
; =============================================================================================================================================================

#Requires AutoHotkey v2.0


SystemProcessInformation(Process?)
{
	#DllLoad "ntdll.dll"

	static STATUS_SUCCESS              := 0x00000000
	static STATUS_INFO_LENGTH_MISMATCH := 0xC0000004
	static STATUS_BUFFER_TOO_SMALL     := 0xC0000023
	static SYSTEM_PROCESS_INFORMATION  := 0x00000005

	Buf := Buffer(0x0100)
	NT_STATUS := DllCall("ntdll\NtQuerySystemInformation", "Int", SYSTEM_PROCESS_INFORMATION, "Ptr", Buf.Ptr, "UInt", Buf.Size, "UInt*", &Size := 0, "UInt")

	while (NT_STATUS = STATUS_INFO_LENGTH_MISMATCH) || (NT_STATUS = STATUS_BUFFER_TOO_SMALL)
	{
		Buf := Buffer(Size)
		NT_STATUS := DllCall("ntdll\NtQuerySystemInformation", "Int", SYSTEM_PROCESS_INFORMATION, "Ptr", Buf.Ptr, "UInt", Buf.Size, "UInt*", &Size := 0, "UInt")
	}

	if (NT_STATUS = STATUS_SUCCESS)
	{
		PROCESS_INFORMATION := Map()
		Addr := Buf.Ptr
		while (Addr)
		{
			if (IsSet(Process))
			{
				UniqueProcessId := NumGet(Addr, 0x0050, "Ptr")
				ImageName       := (Ptr := NumGet(Addr, 0x0040, "Ptr")) ? StrGet(Ptr) : ""
				if (UniqueProcessId != Process) && (!InStr(ImageName, Process))
				{
					if !(NumGet(Addr, 0x0000, "UInt"))
						break
					Addr += NumGet(Addr, 0x0000, "UInt")
					continue
				}
			}

			INFORMATION := Map()
			INFORMATION["NumberOfThreads"]              := NumGet(Addr, 0x0004, "UInt")
			INFORMATION["WorkingSetPrivateSize"]        := NumGet(Addr, 0x0008, "Int64")
			INFORMATION["HardFaultCount"]               := NumGet(Addr, 0x0010, "UInt")
			INFORMATION["NumberOfThreadsHighWatermark"] := NumGet(Addr, 0x0014, "UInt")
			INFORMATION["CycleTime"]                    := NumGet(Addr, 0x0018, "UInt64")
			INFORMATION["CreateTime"]                   := NumGet(Addr, 0x0020, "Int64")
			INFORMATION["UserTime"]                     := NumGet(Addr, 0x0028, "Int64")
			INFORMATION["KernelTime"]                   := NumGet(Addr, 0x0030, "Int64")
			INFORMATION["ImageName"]                    := (Ptr := NumGet(Addr, 0x0040, "Ptr")) ? StrGet(Ptr) : ""
			INFORMATION["BasePriority"]                 := NumGet(Addr, 0x0048, "Int")
			INFORMATION["UniqueProcessId"]              := NumGet(Addr, 0x0050, "Ptr")
			INFORMATION["InheritedFromUniqueProcessId"] := NumGet(Addr, 0x0058, "Ptr*")
			INFORMATION["HandleCount"]                  := NumGet(Addr, 0x0060, "UInt")
			INFORMATION["SessionId"]                    := NumGet(Addr, 0x0064, "UInt")
			INFORMATION["UniqueProcessKey"]             := NumGet(Addr, 0x0068, "UPtr")
			INFORMATION["PeakVirtualSize"]              := NumGet(Addr, 0x0070, "UPtr")
			INFORMATION["VirtualSize"]                  := NumGet(Addr, 0x0078, "UPtr")
			INFORMATION["PageFaultCount"]               := NumGet(Addr, 0x0080, "UInt")
			INFORMATION["PeakWorkingSetSize"]           := NumGet(Addr, 0x0088, "UPtr")
			INFORMATION["WorkingSetSize"]               := NumGet(Addr, 0x0090, "UPtr")
			INFORMATION["QuotaPeakPagedPoolUsage"]      := NumGet(Addr, 0x0098, "UPtr")
			INFORMATION["QuotaPagedPoolUsage"]          := NumGet(Addr, 0x00A0, "UPtr")
			INFORMATION["QuotaPeakNonPagedPoolUsage"]   := NumGet(Addr, 0x00A8, "UPtr")
			INFORMATION["QuotaNonPagedPoolUsage"]       := NumGet(Addr, 0x00B0, "UPtr")
			INFORMATION["PagefileUsage"]                := NumGet(Addr, 0x00B8, "UPtr")
			INFORMATION["PeakPagefileUsage"]            := NumGet(Addr, 0x00C0, "UPtr")
			INFORMATION["PrivatePageCount"]             := NumGet(Addr, 0x00C8, "UPtr")
			INFORMATION["ReadOperationCount"]           := NumGet(Addr, 0x00D0, "Int64")
			INFORMATION["WriteOperationCount"]          := NumGet(Addr, 0x00D8, "Int64")
			INFORMATION["OtherOperationCount"]          := NumGet(Addr, 0x00E0, "Int64")
			INFORMATION["ReadTransferCount"]            := NumGet(Addr, 0x00E8, "Int64")
			INFORMATION["WriteTransferCount"]           := NumGet(Addr, 0x00F0, "Int64")
			INFORMATION["OtherTransferCount"]           := NumGet(Addr, 0x00F8, "Int64")
			PROCESS_INFORMATION[A_Index]                := INFORMATION

			if !(NumGet(Addr, 0x0000, "UInt"))
				break
			Addr += NumGet(Addr, 0x0000, "UInt")
		}
		return PROCESS_INFORMATION
	}

	throw OSError()
}


; =============================================================================================================================================================
; Example
; =============================================================================================================================================================

PI := SystemProcessInformation() ; or ("notepad") / (15027)
Main := Gui()
LV := Main.AddListView("xm ym w1366 r40")
for i, in PI
{
	arr := [], index := A_Index
	for k, v in PI[i]
	{
		if (index < 2)
			LV.InsertCol(A_Index,, k)
		arr.Push(v)
	}
	LV.Add("", arr*)
}
loop LV.GetCount("Col")
	LV.ModifyCol(A_Index, "Auto")
Main.OnEvent("Close", (*) => ExitApp)
Main.Show("AutoSize")

/*
Proc := SystemProcessInformation()
for i, v in Proc {
	for k, v in Proc[i]
		MsgBox k ": " v
}
*/