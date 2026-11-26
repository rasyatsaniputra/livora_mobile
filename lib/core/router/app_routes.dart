/// Path route terpusat — dipakai router dan layar agar literal path tidak
/// tersebar dan mudah dilacak.
abstract final class AppRoutes {
  static const splash = '/';
  static const catalog = '/catalog';
  static const tickets = '/tickets';
  static const history = '/history';
  static const profile = '/profile';

  /// Alur auth (tiket 03–04), di luar shell bottom-nav.
  static const login = '/login';
  static const loginVerify = '/login/verify';
  static const register = '/register';
  static const registerVerify = '/register/verify';

  /// Pemesanan (tiket 09) — tujuan tombol "lanjut" di detail event.
  static const checkout = '/checkout/:id';

  /// Detail event (tiket 07) — anak dari tab katalog.
  static String eventDetailPath(String id) =>
      '/catalog/event/${Uri.encodeComponent(id)}';

  static String checkoutPath(String id) =>
      '/checkout/${Uri.encodeComponent(id)}';
}
