import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/session_controller.dart';
import '../../../core/network/api_exception.dart';
import '../data/bookmark_repository.dart';
import '../data/catalog_event.dart';
import 'bookmark_store.dart';

/// Status halaman daftar bookmark (tiket 08).
sealed class BookmarkListState {
  const BookmarkListState();
}

final class BookmarkListLoading extends BookmarkListState {
  const BookmarkListLoading();
}

final class BookmarkListReady extends BookmarkListState {
  const BookmarkListReady(this.events);

  final List<CatalogEvent> events;
}

/// Gagal memuat daftar — layar menampilkan pesan per [ApiExceptionKind]
/// beserta tombol coba lagi.
final class BookmarkListFailed extends BookmarkListState {
  const BookmarkListFailed(this.kind);

  final ApiExceptionKind kind;
}

/// Daftar event tersimpan. Status simpan/hapus tidak disimpan di sini,
/// melainkan di [bookmarkStoreProvider] yang sama dengan halaman detail,
/// sehingga perubahan dari layar mana pun langsung terlihat di layar lain.
class BookmarkListController extends Notifier<BookmarkListState> {
  var _requestId = 0;

  @override
  BookmarkListState build() {
    // Sesi berakhir: kosongkan daftar agar event pengguna sebelumnya tidak
    // tampil sebelum muat ulang pengguna berikutnya.
    ref.listen<AsyncValue<bool>>(sessionControllerProvider, (_, session) {
      if (session.value == false && state is BookmarkListReady) {
        state = const BookmarkListLoading();
      }
    });
    // Status dari detail bisa menghapus baris (toggle off) atau menambah
    // event baru (toggle on) saat daftar sudah tampil.
    ref.listen<Map<String, bool>>(bookmarkStoreProvider, (_, statuses) {
      _reconcile(statuses);
    });
    return const BookmarkListLoading();
  }

  /// Muat ulang daftar dari server — pembukaan layar dan tombol coba lagi.
  Future<void> load() async {
    final requestId = ++_requestId;
    state = const BookmarkListLoading();
    try {
      final events = await ref
          .read(bookmarkRepositoryProvider)
          .fetchBookmarks();
      if (!ref.mounted || requestId != _requestId) return;

      // Server adalah sumber kebenaran saat daftar dimuat.
      final store = ref.read(bookmarkStoreProvider.notifier);
      for (final event in events) {
        final id = event.id;
        if (id != null) store.seed(id, true);
      }

      if (!ref.mounted || requestId != _requestId) return;
      state = BookmarkListReady(events);
    } on ApiException catch (e) {
      if (!ref.mounted || requestId != _requestId) return;
      state = BookmarkListFailed(e.kind);
    } on Exception {
      // Bentuk respons tak terduga: tetap beri pesan agar layar tidak
      // menggantung di spinner.
      if (!ref.mounted || requestId != _requestId) return;
      state = const BookmarkListFailed(ApiExceptionKind.request);
    }
  }

  /// Hapus bookmark lewat `POST /events/:id/bookmark` (endpoint toggle).
  /// Status bersama diperbarui oleh [BookmarkStore] sehingga baris hilang
  /// dari daftar tanpa perlu memuat ulang.
  Future<ApiExceptionKind?> remove(String eventId) async {
    try {
      final store = ref.read(bookmarkStoreProvider.notifier);
      final bookmarked = await store.toggle(eventId);
      // Baris tampil tetapi server ternyata sudah tidak menyimpannya (mis.
      // diubah dari perangkat lain): toggle sekali lagi agar aksi hapus
      // benar-benar berakhir pada status tidak tersimpan.
      if (bookmarked) await store.toggle(eventId);
      return null;
    } on ApiException catch (e) {
      return e.kind;
    } on Exception {
      return ApiExceptionKind.request;
    }
  }

  /// Selaraskan daftar yang sedang tampil dengan status bersama.
  void _reconcile(Map<String, bool> statuses) {
    final current = state;
    if (current is! BookmarkListReady) return;

    final remaining = [
      for (final event in current.events)
        if (event.id == null || statuses[event.id] != false) event,
    ];
    if (remaining.length != current.events.length) {
      state = BookmarkListReady(remaining);
      return;
    }

    // Bookmark baru dari detail: ambil ulang supaya data event lengkap.
    final known = current.events.map((event) => event.id).nonNulls.toSet();
    final hasNew = statuses.entries.any(
      (entry) => entry.value && !known.contains(entry.key),
    );
    if (hasNew) load();
  }
}

final bookmarkListControllerProvider =
    NotifierProvider<BookmarkListController, BookmarkListState>(
      BookmarkListController.new,
    );
