/// Pemetaan nilai JSON yang toleran dipakai model katalog (tiket 06–07).
///
/// Backend Soundtix mengirim beberapa angka Postgres sebagai string
/// (`numeric`) dan ID sebagai angka maupun UUID; UI selalu butuh tipe Dart
/// yang konsisten.
String? idFromJson(Object? value) => value?.toString();

DateTime? dateFromJson(Object? value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}

num numFromJson(Object? value) {
  if (value is num) return value;
  return num.tryParse(value?.toString() ?? '') ?? 0;
}

int intFromJson(Object? value) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
