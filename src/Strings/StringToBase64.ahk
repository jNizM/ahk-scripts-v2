; =============================================================================================================================================================
; Author ........: jNizM
; Released ......: 2016-10-21
; Modified ......: 2023-01-13
; Tested with....: AutoHotkey v2.0.2 (x64)
; Tested on .....: Windows 11 - 22H2 (x64)
; Function ......: StringToBase64()
;
; Parameter(s)...: String
;                  Encoding (default = UTF-8)
;
; Return ........: Converts a readable string to a base64 string.
; =============================================================================================================================================================

#Requires AutoHotkey v2.0


StringToBase64(String, Encoding := "UTF-8")
{
	static CRYPT_STRING_BASE64 := 0x00000001
	static CRYPT_STRING_NOCRLF := 0x40000000

	Binary := Buffer(StrPut(String, Encoding))
	StrPut(String, Binary, Encoding)
	if !(DllCall("crypt32\CryptBinaryToStringW", "Ptr", Binary, "UInt", Binary.Size - 1, "UInt", (CRYPT_STRING_BASE64 | CRYPT_STRING_NOCRLF), "Ptr", 0, "UInt*", &Size := 0))
		throw OSError()

	Base64 := Buffer(Size << 1, 0)
	if !(DllCall("crypt32\CryptBinaryToStringW", "Ptr", Binary, "UInt", Binary.Size - 1, "UInt", (CRYPT_STRING_BASE64 | CRYPT_STRING_NOCRLF), "Ptr", Base64, "UInt*", Size))
		throw OSError()

	return StrGet(Base64)
}


; =============================================================================================================================================================
; Example
; =============================================================================================================================================================

MsgBox StringToBase64("The quick brown fox jumps over the lazy dog")   ; => VGhlIHF1aWNrIGJyb3duIGZveCBqdW1wcyBvdmVyIHRoZSBsYXp5IGRvZw==
