import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/providers.dart';

/// Status sesi aplikasi: `true` bila ada token tersimpan (login), `false`
/// bila belum login. Nilai awal dibaca dari [tokenStoreProvider] — secure
/// storage — sehingga membuka ulang aplikasi tetap dalam kondisi login.
///
/// Berada di `core/auth` karena dipakai lintas fitur: splash memilih tujuan
/// pembuka, layar OTP menandai login, dan modul berikutnya (logout/profil).
class SessionController extends AsyncNotifier<bool> {
  /// Pembacaan awal storage; dipegang agar [markSignedIn] bisa menunggu
  /// restore selesai sebelum menimpa hasilnya.
  Future<bool>? _restoring;

  @override
  Future<bool> build() {
    final restoring = _restoring = _readSession();
    return restoring;
  }

  Future<bool> _readSession() async {
    try {
      final accessToken =
          await ref.watch(tokenStoreProvider).readAccessToken();
      return accessToken != null;
    } on Object {
      // Secure storage gagal dibaca: perlakukan sebagai belum login agar
      // aplikasi tidak tertahan di splash (story 40).
      return false;
    }
  }

  /// Dipanggil setelah verifikasi OTP sukses menyimpan token. Menunggu
  /// restore awal selesai supaya hasil baca lama tidak menimpa status login.
  Future<void> markSignedIn() async {
    final restoring = _restoring;
    if (restoring != null) {
      try {
        await restoring;
      } on Object {
        // Restore gagal tidak menghalangi login yang baru berhasil.
      }
    }
    if (!ref.mounted) return;
    state = const AsyncData(true);
  }

  /// Dipanggil setelah logout: token sudah dihapus, aplikasi kembali ke
  /// kondisi belum login (splash berikutnya membuka layar login).
  Future<void> markSignedOut() async {
    if (!ref.mounted) return;
    state = const AsyncData(false);
  }
}

final sessionControllerProvider =
    AsyncNotifierProvider<SessionController, bool>(SessionController.new);
