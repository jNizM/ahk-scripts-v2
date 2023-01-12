; =============================================================================================================================================================
; Author ........: jNizM
; Released ......: 2022-10-14
; Modified ......: 2023-01-12
; Tested with....: AutoHotkey v2.0.2 (x64)
; Tested on .....: Windows 11 - 22H2 (x64)
; Function ......: GetNetworkConnectivityHint()
;
; Parameter(s)...: No parameters used
;
; Return ........: Retrieves the aggregate level and cost of network connectivity that an application or service is likely to experience.
; =============================================================================================================================================================

#Requires AutoHotkey v2.0


GetNetworkConnectivityHint()
{
	static NO_ERROR   := 0 ; User-Mode: NO_ERROR on success, error code on failure.
	static LEVEL_HINT := Map(0, "Unknown", 1, "None", 2, "LocalAccess", 3, "InternetAccess", 4, "ConstrainedInternetAccess", 5, "Hidden")
	static COST_HINT  := Map(0, "Unknown", 1, "Unrestricted", 2, "Fixed", 3, "Variable")

	if (VerCompare(A_OSVersion, "10.0.19041") < 0)
		throw Error("Minimum supported client: Windows 10, version 2004 (Build 19041)", -1)

	Buf := Buffer(20)
	NETIOAPI_SUCCESS := DllCall("iphlpapi\GetNetworkConnectivityHint", "Ptr", Buf, "UInt")
	if (NETIOAPI_SUCCESS = NO_ERROR)
	{
		NETWORK_CONNECTIVITY_HINT := Map()
		NETWORK_CONNECTIVITY_HINT["ConnectivityLevel"]    := LEVEL_HINT[NumGet(Buf, 0, "Int")]
		NETWORK_CONNECTIVITY_HINT["ConnectivityCost"]     := COST_HINT[NumGet(Buf, 4, "Int")]
		NETWORK_CONNECTIVITY_HINT["ApproachingDataLimit"] := NumGet(Buf,  8, "Int")
		NETWORK_CONNECTIVITY_HINT["OverDataLimit"]        := NumGet(Buf, 12, "Int")
		NETWORK_CONNECTIVITY_HINT["Roaming"]              := NumGet(Buf, 16, "Int")
		return NETWORK_CONNECTIVITY_HINT
	}
	throw OSError()
}


; =============================================================================================================================================================
; Example
; =============================================================================================================================================================

for k, v in GetNetworkConnectivityHint()
	output .= k ": " v "`n"
MsgBox output