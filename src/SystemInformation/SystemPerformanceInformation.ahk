; ===========================================================================================================================================================================
; Returns a SYSTEM_PERFORMANCE_INFORMATION structure from the NtQuerySystemInformation function.
; Tested with AutoHotkey v2.0-beta.3
; ===========================================================================================================================================================================

SystemPerformanceInformation()
{
	#DllLoad "ntdll.dll"

	static STATUS_SUCCESS                 := 0x00000000
	static SYSTEM_PERFORMANCE_INFORMATION := 0x00000002

	DllCall("ntdll\NtQuerySystemInformation", "Int", SYSTEM_PERFORMANCE_INFORMATION, "Ptr", 0, "UInt", 0, "UInt*", &Size := 0, "UInt")
	Buf := Buffer(Size, 0)
	if (DllCall("ntdll\NtQuerySystemInformation", "Int", SYSTEM_PERFORMANCE_INFORMATION, "Ptr", Buf.Ptr, "UInt", Buf.Size, "UInt*", 0, "UInt") = STATUS_SUCCESS)
	{
		PERFORMANCE_INFORMATION := Map()
		PERFORMANCE_INFORMATION["IdleProcessTime"]           := NumGet(Buf, 0x0000, "Int64")
		PERFORMANCE_INFORMATION["IoReadTransferCount"]       := NumGet(Buf, 0x0008, "Int64")
		PERFORMANCE_INFORMATION["IoWriteTransferCount"]      := NumGet(Buf, 0x0010, "Int64")
		PERFORMANCE_INFORMATION["IoOtherTransferCount"]      := NumGet(Buf, 0x0018, "Int64")
		PERFORMANCE_INFORMATION["IoReadOperationCount"]      := NumGet(Buf, 0x0020, "UInt")
		PERFORMANCE_INFORMATION["IoWriteOperationCount"]     := NumGet(Buf, 0x0024, "UInt")
		PERFORMANCE_INFORMATION["IoOtherOperationCount"]     := NumGet(Buf, 0x0028, "UInt")
		PERFORMANCE_INFORMATION["AvailablePages"]            := NumGet(Buf, 0x002C, "UInt")
		PERFORMANCE_INFORMATION["CommittedPages"]            := NumGet(Buf, 0x0030, "UInt")
		PERFORMANCE_INFORMATION["CommitLimit"]               := NumGet(Buf, 0x0034, "UInt")
		PERFORMANCE_INFORMATION["PeakCommitment"]            := NumGet(Buf, 0x0038, "UInt")
		PERFORMANCE_INFORMATION["PageFaultCount"]            := NumGet(Buf, 0x003C, "UInt")
		PERFORMANCE_INFORMATION["CopyOnWriteCount"]          := NumGet(Buf, 0x0040, "UInt")
		PERFORMANCE_INFORMATION["TransitionCount"]           := NumGet(Buf, 0x0044, "UInt")
		PERFORMANCE_INFORMATION["CacheTransitionCount"]      := NumGet(Buf, 0x0048, "UInt")
		PERFORMANCE_INFORMATION["DemandZeroCount"]           := NumGet(Buf, 0x004C, "UInt")
		PERFORMANCE_INFORMATION["PageReadCount"]             := NumGet(Buf, 0x0050, "UInt")
		PERFORMANCE_INFORMATION["PageReadIoCount"]           := NumGet(Buf, 0x0054, "UInt")
		PERFORMANCE_INFORMATION["CacheReadCount"]            := NumGet(Buf, 0x0058, "UInt")
		PERFORMANCE_INFORMATION["CacheIoCount"]              := NumGet(Buf, 0x005C, "UInt")
		PERFORMANCE_INFORMATION["DirtyPagesWriteCount"]      := NumGet(Buf, 0x0060, "UInt")
		PERFORMANCE_INFORMATION["DirtyWriteIoCount"]         := NumGet(Buf, 0x0064, "UInt")
		PERFORMANCE_INFORMATION["MappedPagesWriteCount"]     := NumGet(Buf, 0x0068, "UInt")
		PERFORMANCE_INFORMATION["MappedWriteIoCount"]        := NumGet(Buf, 0x006C, "UInt")
		PERFORMANCE_INFORMATION["PagedPoolPages"]            := NumGet(Buf, 0x0070, "UInt")
		PERFORMANCE_INFORMATION["NonPagedPoolPages"]         := NumGet(Buf, 0x0074, "UInt")
		PERFORMANCE_INFORMATION["PagedPoolAllocs"]           := NumGet(Buf, 0x0078, "UInt")
		PERFORMANCE_INFORMATION["PagedPoolFrees"]            := NumGet(Buf, 0x007C, "UInt")
		PERFORMANCE_INFORMATION["NonPagedPoolAllocs"]        := NumGet(Buf, 0x0080, "UInt")
		PERFORMANCE_INFORMATION["NonPagedPoolFrees"]         := NumGet(Buf, 0x0084, "UInt")
		PERFORMANCE_INFORMATION["FreeSystemPtes"]            := NumGet(Buf, 0x0088, "UInt")
		PERFORMANCE_INFORMATION["ResidentSystemCodePage"]    := NumGet(Buf, 0x008C, "UInt")
		PERFORMANCE_INFORMATION["TotalSystemDriverPages"]    := NumGet(Buf, 0x0090, "UInt")
		PERFORMANCE_INFORMATION["TotalSystemCodePages"]      := NumGet(Buf, 0x0094, "UInt")
		PERFORMANCE_INFORMATION["NonPagedPoolLookasideHits"] := NumGet(Buf, 0x0098, "UInt")
		PERFORMANCE_INFORMATION["PagedPoolLookasideHits"]    := NumGet(Buf, 0x009C, "UInt")
		PERFORMANCE_INFORMATION["AvailablePagedPoolPages"]   := NumGet(Buf, 0x00A0, "UInt")
		PERFORMANCE_INFORMATION["ResidentSystemCachePage"]   := NumGet(Buf, 0x00A4, "UInt")
		PERFORMANCE_INFORMATION["ResidentPagedPoolPage"]     := NumGet(Buf, 0x00A8, "UInt")
		PERFORMANCE_INFORMATION["ResidentSystemDriverPage"]  := NumGet(Buf, 0x00AC, "UInt")
		PERFORMANCE_INFORMATION["CcFastReadNoWait"]          := NumGet(Buf, 0x00B0, "UInt")
		PERFORMANCE_INFORMATION["CcFastReadWait"]            := NumGet(Buf, 0x00B4, "UInt")
		PERFORMANCE_INFORMATION["CcFastReadResourceMiss"]    := NumGet(Buf, 0x00B8, "UInt")
		PERFORMANCE_INFORMATION["CcFastReadNotPossible"]     := NumGet(Buf, 0x00BC, "UInt")
		PERFORMANCE_INFORMATION["CcFastMdlReadNoWait"]       := NumGet(Buf, 0x00C0, "UInt")
		PERFORMANCE_INFORMATION["CcFastMdlReadWait"]         := NumGet(Buf, 0x00C4, "UInt")
		PERFORMANCE_INFORMATION["CcFastMdlReadResourceMiss"] := NumGet(Buf, 0x00C8, "UInt")
		PERFORMANCE_INFORMATION["CcFastMdlReadNotPossible"]  := NumGet(Buf, 0x00CC, "UInt")
		PERFORMANCE_INFORMATION["CcMapDataNoWait"]           := NumGet(Buf, 0x00D0, "UInt")
		PERFORMANCE_INFORMATION["CcMapDataWait"]             := NumGet(Buf, 0x00D4, "UInt")
		PERFORMANCE_INFORMATION["CcMapDataNoWaitMiss"]       := NumGet(Buf, 0x00D8, "UInt")
		PERFORMANCE_INFORMATION["CcMapDataWaitMiss"]         := NumGet(Buf, 0x00DC, "UInt")
		PERFORMANCE_INFORMATION["CcPinMappedDataCount"]      := NumGet(Buf, 0x00E0, "UInt")
		PERFORMANCE_INFORMATION["CcPinReadNoWait"]           := NumGet(Buf, 0x00E4, "UInt")
		PERFORMANCE_INFORMATION["CcPinReadWait"]             := NumGet(Buf, 0x00E8, "UInt")
		PERFORMANCE_INFORMATION["CcPinReadNoWaitMiss"]       := NumGet(Buf, 0x00EC, "UInt")
		PERFORMANCE_INFORMATION["CcPinReadWaitMiss"]         := NumGet(Buf, 0x00F0, "UInt")
		PERFORMANCE_INFORMATION["CcCopyReadNoWait"]          := NumGet(Buf, 0x00F4, "UInt")
		PERFORMANCE_INFORMATION["CcCopyReadWait"]            := NumGet(Buf, 0x00F8, "UInt")
		PERFORMANCE_INFORMATION["CcCopyReadNoWaitMiss"]      := NumGet(Buf, 0x00FC, "UInt")
		PERFORMANCE_INFORMATION["CcCopyReadWaitMiss"]        := NumGet(Buf, 0x0100, "UInt")
		PERFORMANCE_INFORMATION["CcMdlReadNoWait"]           := NumGet(Buf, 0x0104, "UInt")
		PERFORMANCE_INFORMATION["CcMdlReadWait"]             := NumGet(Buf, 0x0108, "UInt")
		PERFORMANCE_INFORMATION["CcMdlReadNoWaitMiss"]       := NumGet(Buf, 0x010C, "UInt")
		PERFORMANCE_INFORMATION["CcMdlReadWaitMiss"]         := NumGet(Buf, 0x0110, "UInt")
		PERFORMANCE_INFORMATION["CcReadAheadIos"]            := NumGet(Buf, 0x0114, "UInt")
		PERFORMANCE_INFORMATION["CcLazyWriteIos"]            := NumGet(Buf, 0x0118, "UInt")
		PERFORMANCE_INFORMATION["CcLazyWritePages"]          := NumGet(Buf, 0x011C, "UInt")
		PERFORMANCE_INFORMATION["CcDataFlushes"]             := NumGet(Buf, 0x0120, "UInt")
		PERFORMANCE_INFORMATION["CcDataPages"]               := NumGet(Buf, 0x0124, "UInt")
		PERFORMANCE_INFORMATION["ContextSwitches"]           := NumGet(Buf, 0x0128, "UInt")
		PERFORMANCE_INFORMATION["FirstLevelTbFills"]         := NumGet(Buf, 0x012C, "UInt")
		PERFORMANCE_INFORMATION["SecondLevelTbFills"]        := NumGet(Buf, 0x0130, "UInt")
		PERFORMANCE_INFORMATION["SystemCalls"]               := NumGet(Buf, 0x0134, "UInt")
		PERFORMANCE_INFORMATION["CcTotalDirtyPages"]         := NumGet(Buf, 0x0138, "UInt64")
		PERFORMANCE_INFORMATION["CcDirtyPageThreshold"]      := NumGet(Buf, 0x0140, "UInt64")
		PERFORMANCE_INFORMATION["ResidentAvailablePages"]    := NumGet(Buf, 0x0148, "Int64")
		PERFORMANCE_INFORMATION["SharedCommittedPages"]      := NumGet(Buf, 0x0150, "UInt64")
		return PERFORMANCE_INFORMATION
	}
	return false
}

; Example ===================================================================================================================================================================

MsgBox SystemPerformanceInformation()["SystemCalls"]