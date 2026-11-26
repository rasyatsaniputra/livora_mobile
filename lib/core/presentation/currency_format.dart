import 'package:intl/intl.dart';

/// Format harga rupiah untuk katalog dan detail event.
///
/// Harga dari backend selalu dalam rupiah, jadi locale pemformatan dikunci
/// `id` (pemisah ribuan titik) apa pun bahasa UI yang dipilih pengguna.
final _rupiah = NumberFormat.currency(
  locale: 'id',
  symbol: 'Rp ',
  decimalDigits: 0,
);

String formatRupiah(num amount) => _rupiah.format(amount);
