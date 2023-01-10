; ===========================================================================================================================================================================
; StringToBase64
; Converts a readable string to a base64 string.
; ===========================================================================================================================================================================

StringToBase64(String, Encoding := "UTF-8")
{
	static CRYPT_STRING_BASE64 := 0x00000001
	static CRYPT_STRING_NOCRLF := 0x40000000

	Binary := Buffer(StrPut(String, Encoding))
	StrPut(String, Binary, Encoding)
	if !(DllCall("crypt32\CryptBinaryToStringW", "Ptr", Binary, "UInt", Binary.Size - 1, "UInt", (CRYPT_STRING_BASE64 | CRYPT_STRING_NOCRLF), "Ptr", 0, "UInt*", &Size := 0))
		throw Error("CryptBinaryToStringW failed", -1)

	Base64 := Buffer(Size << 1, 0)
	if !(DllCall("crypt32\CryptBinaryToStringW", "Ptr", Binary, "UInt", Binary.Size - 1, "UInt", (CRYPT_STRING_BASE64 | CRYPT_STRING_NOCRLF), "Ptr", Base64, "UInt*", Size))
		throw Error("CryptBinaryToStringW failed", -1)

	return StrGet(Base64)
}

; ===========================================================================================================================================================================

MsgBox StringToBase64("The quick brown fox jumps over the lazy dog")    ; VGhlIHF1aWNrIGJyb3duIGZveCBqdW1wcyBvdmVyIHRoZSBsYXp5IGRvZwA=
