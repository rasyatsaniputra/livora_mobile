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
