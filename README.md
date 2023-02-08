# A collection of useful AutoHotkey v2 scripts and functions
( [AHK forum](https://www.autohotkey.com/boards/viewtopic.php?f=83&t=89720) - Tested with AutoHotkey v2.0.2 64-bit )


## Functions & Script Examples

- ### ComObject
	- [EnumInstalledApps](src/ComObject/EnumInstalledApps.ahk) (Gets general information about an application.)


- ### FileObject
	- [FileCountLines](src/FileObject/FileCountLines.ahk) (Count the number of lines in a text file.)
	- [FileFindString](src/FileObject/FileFindString.ahk) (Finds a specific word / string in a text file.)
	- [FileReadLastLines](src/FileObject/FileReadLastLines.ahk) (Read last x lines of a text file.)
	- [GetFilePEHeader](src/FileObject/GetFilePEHeader.ahk) (Get the PE File Header information - Machine Type.)


- ### Gui
	- [CreateGradient](src/Gui/CreateGradient.ahk) (Creates a gradient bitmap for picture controls.)
	- [DisableCloseButton](src/Gui/DisableCloseButton.ahk) (Disables the GUI Close Button.)
	- [DisableMove](src/Gui/DisableMove.ahk) (Disables the GUI Move function.)
	- [TaskBarProgress](src/Gui/TaskBarProgress.ahk) (Displays or updates a progress bar hosted in a taskbar button.)


- ### Message
	- [WM_DEVICECHANGE](src/Message/WM_DEVICECHANGE.ahk) (Detecting Media Insertion or Removal.)


- ### Network
	- [DnsServerList](src/Network/DnsServerList.ahk) (Gets a list of DNS servers for the local computer.)
	- [DNSQuery](src/Network/DNSQuery.ahk) (Retrieves the Resource Record (RR) depends on DNS Record Type.)
	- [GetAdaptersInfo](src/Network/GetAdaptersInfo.ahk) (Gets network adapter information for the local computer.)
	- [GetDnsServerList](src/Network/GetDnsServerList.ahk) (Gets a list of DNS servers for the local computer.)
	- [GetNetworkConnectivityHint](src/Network/GetNetworkConnectivityHint.ahk) (Retrieves the level and cost of network connectivity.)
	- [ResolveHostname](src/Network/ResolveHostname.ahk) (Gets the IP Address from a Hostname.)
	- [ReverseLookup](src/Network/ReverseLookup.ahk) (Gets the Hostname by the IP Adresse.)


- ### NetworkManagement
	- [NetGetJoinInformation](src/NetworkManagement/NetGetJoinInformation.ahk) (Retrieves join status information for the specified computer.)
	- [NetGroupEnum](src/NetworkManagement/NetGroupEnum.ahk) (Retrieves information about each global group.)
	- [NetGroupGetInfo](src/NetworkManagement/NetGroupGetInfo.ahk) (Retrieves information about a particular global group.)
	- [NetGroupGetUsers](src/NetworkManagement/NetGroupGetUsers.ahk) (Retrieves a list of the members in a particular global group.)
	- [NetLocalGroupEnum](src/NetworkManagement/NetLocalGroupEnum.ahk) (Returns information about each local group account on the specified server.)
	- [NetLocalGroupGetInfo](src/NetworkManagement/NetLocalGroupGetInfo.ahk) (Retrieves information about a particular local group account on a server.)
	- [NetLocalGroupGetMembers](src/NetworkManagement/NetLocalGroupGetMembers.ahk) (Retrieves a list of the members of a particular local group.)


- ### Others
	- [CreateGUID](src/Others/CreateGUID.ahk) (Creates an Globally Unique IDentifier)
	- [CreateUUID](src/Others/CreateUUID.ahk) (Creates an Universally Unique IDentifier)
	- [GetFileOwner](src/Others/GetFileOwner.ahk) (Finding the Owner of a File or Folder)
	- [GetFileVersionInfo](src/Others/GetFileVersionInfo.ahk) (Retrieves specified version information from the specified version-information resource.)
	- [IsRemoteSession](src/Others/IsRemoteSession.ahk) (Returns TRUE that the current session is a remote session, and FALSE that the current session is a local session.)


- ### Processes / Threads / Modules
	- [GetModuleBaseAddr](src/ProcessThreadModule/GetModuleBaseAddr.ahk) (Retrieves the base address and size of the module in the context of the owning process.)
	- [GetProcessHandles](src/ProcessThreadModule/GetProcessHandles.ahk) (Retrieves all Handles in the context of the owning process.)
	- [GetProcessThreads](src/ProcessThreadModule/GetProcessThreads.ahk) (Retrieves a list of all threads in a process.)
	- [GetThreadStartAddr](src/ProcessThreadModule/GetThreadStartAddr.ahk) (Retrieves the start address of a thread.)
	- [IsProcessElevated](src/ProcessThreadModule/IsProcessElevated.ahk) (Retrieves whether a token has elevated privileges.)


- ### Strings
	- [Base64ToString](src/Strings/Base64ToString.ahk) (Converts a base64 string to a readable string.)
	- [CountLeadingChar](src/Strings/CountLeadingChar.ahk) (Count how often a certain character occurs at the beginning of a string.)
	- [GetCurrencyFormat](src/Strings/GetCurrencyFormat.ahk) (Formats a number string as a currency string for a locale specified by identifier.)
	- [GetCurrencyFormatEx](src/Strings/GetCurrencyFormatEx.ahk) (Formats a number string as a currency string for a locale specified by name.)
	- [GetDurationFormat](src/Strings/GetDurationFormat.ahk) (Formats a duration of time as a time string for a locale specified by identifier.)
	- [GetDurationFormatEx](src/Strings/GetDurationFormatEx.ahk) (Formats a duration of time as a time string for a locale specified by name.)
	- [GetNumberFormat](src/Strings/GetNumberFormat.ahk) (Formats a number string as a number string customized for a locale specified by identifier.)
	- [GetNumberFormatEx](src/Strings/GetNumberFormatEx.ahk) (Formats a number string as a number string customized for a locale specified by name.)
	- [StringToBase64](src/Strings/StringToBase64.ahk) (Converts a readable string to a base64 string.)


- ### SystemInformation (NtQuerySystemInformation)
	- [SystemDeviceInformation](src/SystemInformation/SystemDeviceInformation.ahk) (SYSTEM_DEVICE_INFORMATION)
	- [SystemHandleInformation](src/SystemInformation/SystemHandleInformation.ahk) (SYSTEM_HANDLE_INFORMATION)
	- [SystemPerformanceInformation](src/SystemInformation/SystemPerformanceInformation.ahk) (SYSTEM_PERFORMANCE_INFORMATION)
	- [SystemProcessInformation](src/SystemInformation/SystemProcessInformation.ahk) (SYSTEM_PROCESS_INFORMATION)
	- [SystemProcessorInformation](src/SystemInformation/SystemProcessorInformation.ahk) (SYSTEM_PROCESSOR_INFORMATION)
	- [SystemProcessorPerformanceInformation](src/SystemInformation/SystemProcessorPerformanceInformation.ahk) (SYSTEM_PROCESSOR_PERFORMANCE_INFORMATION)
	- [SystemProcessorPowerInformation](src/SystemInformation/SystemProcessorPowerInformation.ahk) (SYSTEM_PROCESSOR_POWER_INFORMATION)
	- [SystemSecureBootInformation](src/SystemInformation/SystemSecureBootInformation.ahk) (SYSTEM_SECUREBOOT_INFORMATION)


## Copyright and License
[MIT License](LICENSE)


## Donations (PayPal)
[Donations are appreciated if I could help you](https://www.paypal.me/smithz)