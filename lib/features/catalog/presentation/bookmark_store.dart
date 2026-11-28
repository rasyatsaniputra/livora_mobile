import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/session_controller.dart';
import '../data/bookmark_repository.dart';

/// Sumber status bookmark bersama untuk halaman detail dan daftar bookmark
/// (tiket 08).
///
/// Nilai `true`/`false` adalah status terakhir yang diketahui untuk satu
/// event; id yang belum pernah disentuh tidak ada di map. Detail menyinkronkan
/// status dari server saat dimuat, lalu toggle/penghapusan memperbarui map
/// yang sama sehingga kedua layar tidak pernah menampilkan status berbeda.
class BookmarkStore extends Notifier<Map<String, bool>> {
  @override
  Map<String, bool> build() {
    // Status milik satu akun: saat sesi berakhir, jangan biarkan status
    // pengguna sebelumnya terbawa ke pengguna berikutnya.
    ref.listen<AsyncValue<bool>>(sessionControllerProvider, (_, session) {
      if (session.value == false && state.isNotEmpty) state = const {};
    });
    return const {};
  }

  /// Catat status tanpa memanggil server (mis. hasil `is_bookmarked` pada
  /// respons detail/daftar).
  void seed(String eventId, bool bookmarked) {
    if (state[eventId] == bookmarked) return;
    state = {...state, eventId: bookmarked};
  }

  /// Toggle simpan/hapus ke server lalu catat status hasilnya.
  ///
  /// Error HTTP dibiarkan naik sebagai [ApiException] agar pemanggil bisa
  /// menampilkan pesan per jenis kegagalan tanpa mengubah status lama.
  Future<bool> toggle(String eventId) async {
    final bookmarked = await ref
        .read(bookmarkRepositoryProvider)
        .toggleBookmark(eventId);
    if (ref.mounted) seed(eventId, bookmarked);
    return bookmarked;
  }
}

final bookmarkStoreProvider =
    NotifierProvider<BookmarkStore, Map<String, bool>>(BookmarkStore.new);
