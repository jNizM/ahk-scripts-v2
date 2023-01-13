; =============================================================================================================================================================
; Author ........: jNizM
; Released ......: 2017-03-03
; Modified ......: 2023-01-13
; Tested with....: AutoHotkey v2.0.2 (x64)
; Tested on .....: Windows 11 - 22H2 (x64)
; Function ......: WM_DEVICECHANGE
;
; Parameter(s)...: 
;
; Return ........: Notifies an application of a change to the hardware configuration of a device or the computer.
; =============================================================================================================================================================

#Requires AutoHotkey v2.0

OnMessage 0x0219, WM_DEVICECHANGE
Persistent


WM_DEVICECHANGE(wParam, lParam, *)
{
	static DBT_DEVICEARRIVAL        := 0x8000
	static DBT_DEVICEREMOVECOMPLETE := 0x8004
	static DBT_DEVTYP_VOLUME        := 0x00000002

	if (wParam = DBT_DEVICEARRIVAL) || (wParam = DBT_DEVICEREMOVECOMPLETE)
	{
		if (NumGet(lParam, 4, "UInt") = DBT_DEVTYP_VOLUME)
		{
			Device := FirstDriveFromMask(NumGet(lParam, 12, "UInt"))
			DeviceChangeInfo(Device, wParam)
		}
	}
}


FirstDriveFromMask(unitmask)
{
	i := 0
	while (unitmask > 1) && (++i < 0x1A)
		unitmask >>= 1
	return 0x41 + i
}


DeviceChangeInfo(Device, ChangeInfo)
{
	TrayTip Chr(Device) ":\ " ((ChangeInfo = 0x8000) ? "plugged in" : "is removed"), "DeviceChange"
	SetTimer () => TrayTip(), -3000
}

; =============================================================================================================================================================