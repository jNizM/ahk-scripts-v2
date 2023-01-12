; =============================================================================================================================================================
; Author ........: jNizM
; Released ......: 2021-05-11
; Modified ......: 2023-01-12
; Tested with....: AutoHotkey v2.0.2 (x64)
; Tested on .....: Windows 11 - 22H2 (x64)
; Function ......: GetFilePEHeader( FileName )
;
; Parameter(s)...: FileName  - path to the file
;
; Return ........: Get the PE File Header information (Machine Type).
; =============================================================================================================================================================

#Requires AutoHotkey v2.0


GetFilePEHeader(FileName)
{
	static IMAGE_DOS_SIGNATURE := 0x5A4D
	static IMAGE_NT_SIGNATURE  := 0x4550
	static MachineType := Map(0x0000, "UNKNOWN", 0x014c, "I386", 0x0200, "IA64", 0x8664, "AMD64")

	SplitPath FileName,,, &ext
	if !(ext ~= "exe|dll|sys|drv|scr|cpl|ocx|ax|efi")
	{
		MsgBox "This File is not a Portable Executable (PE) file."
		return
	}

	try
		File := FileOpen(FileName, "r-d")
	catch as Err
	{
		MsgBox "Can't open '" FileName "`n`n" Type(Err) ": " Err.Message
		return
	}

	if (File.ReadUShort() = IMAGE_DOS_SIGNATURE)
	{
		File.Seek(60)
		File.Seek(e_lfanew := File.ReadInt())
		if (File.ReadUInt() = IMAGE_NT_SIGNATURE)
		{
			File.Seek(e_lfanew + 4)
			PEHeader := MachineType[File.ReadUShort()]
		}
	}
	File.Close()

	return PEHeader
}


; =============================================================================================================================================================
; Example
; =============================================================================================================================================================

MsgBox GetFilePEHeader("C:\Windows\System32\kernel32.dll")
MsgBox GetFilePEHeader("C:\Program Files\AutoHotkey\AutoHotkey.exe")