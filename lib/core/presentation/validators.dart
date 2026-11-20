/// Validasi email yang dipakai bersama form login dan register (tiket 03–04)
/// agar aturan formatnya tidak berbeda antar layar.
final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

/// Mengembalikan [invalidMessage] bila [value] kosong atau bukan email;
/// pesan spesifik layar tetap ditentukan pemanggil lewat l10n.
String? validateEmail(String? value, String invalidMessage) {
  final email = value?.trim() ?? '';
  if (email.isEmpty || !_emailPattern.hasMatch(email)) {
    return invalidMessage;
  }
  return null;
}

/// Aturan nomor HP mengikuti `PATCH /users/me` (OpenAPI): 9–16 karakter,
/// hanya digit dan `+`. Dipakai bersama oleh validator dan input formatter
/// agar tidak ada dua sumber aturan.
const phoneMinLength = 9;
const phoneMaxLength = 16;
final phoneAllowedCharacters = RegExp(r'[0-9+]');
final _phonePattern = RegExp(r'^[0-9+]+$');

/// Nomor HP opsional: kosong dianggap valid. [invalidMessage] dipakai untuk
/// format yang tidak sesuai kontrak API.
String? validatePhone(String? value, String invalidMessage) {
  final phone = value?.trim() ?? '';
  if (phone.isEmpty) return null;
  if (phone.length < phoneMinLength ||
      phone.length > phoneMaxLength ||
      !_phonePattern.hasMatch(phone)) {
    return invalidMessage;
  }
  return null;
}
