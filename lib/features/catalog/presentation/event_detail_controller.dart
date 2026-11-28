import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../data/event_detail.dart';
import '../data/event_detail_repository.dart';
import 'bookmark_store.dart';

/// Status halaman detail event (tiket 07).
sealed class EventDetailState {
  const EventDetailState();
}

final class EventDetailLoading extends EventDetailState {
  const EventDetailLoading();
}

/// Detail event siap tampil. Organizer bersifat pelengkap: bila profil
/// publiknya gagal dimuat, detail tetap tampil memakai nama organisasi yang
/// ikut pada respons event.
final class EventDetailReady extends EventDetailState {
  const EventDetailReady({required this.detail, this.organizer});

  final EventDetail detail;
  final OrganizerProfile? organizer;
}

/// Gagal memuat detail — layar menampilkan pesan per [ApiExceptionKind]
/// beserta tombol coba lagi.
final class EventDetailFailed extends EventDetailState {
  const EventDetailFailed(this.kind);

  final ApiExceptionKind kind;
}

class EventDetailController extends Notifier<EventDetailState> {
  EventDetailController(this.eventId);

  final String eventId;

  @override
  EventDetailState build() => const EventDetailLoading();

  /// Muat detail + organizer; dipanggil saat layar dibuka dan oleh tombol
  /// coba lagi.
  Future<void> load() async {
    state = const EventDetailLoading();
    await _fetch();
  }

  Future<void> retry() => load();

  /// Id event yang dipakai untuk status bookmark — mengikuti id dari respons
  /// detail bila ada, dengan id path sebagai cadangan.
  String get bookmarkEventId {
    final current = state;
    return current is EventDetailReady
        ? (current.detail.id ?? eventId)
        : eventId;
  }

  /// Toggle simpan/hapus bookmark (tiket 08). Status bersama diperbarui oleh
  /// [BookmarkStore] sehingga daftar bookmark ikut konsisten. Mengembalikan
  /// jenis error bila gagal, atau null bila berhasil.
  Future<ApiExceptionKind?> toggleBookmark() async {
    final current = state;
    if (current is! EventDetailReady) return null;
    try {
      await ref.read(bookmarkStoreProvider.notifier).toggle(bookmarkEventId);
      return null;
    } on ApiException catch (e) {
      return e.kind;
    } on Exception {
      return ApiExceptionKind.request;
    }
  }

  Future<void> _fetch() async {
    try {
      final detail = await ref
          .read(eventDetailRepositoryProvider)
          .fetchEventDetail(eventId);
      if (!ref.mounted) return;
      // Status dari server menjadi titik awal bersama untuk layar detail dan
      // daftar bookmark.
      ref
          .read(bookmarkStoreProvider.notifier)
          .seed(detail.id ?? eventId, detail.bookmarked);
      final organizer = await _fetchOrganizerOrNull(detail.organizerId);
      if (!ref.mounted) return;
      state = EventDetailReady(detail: detail, organizer: organizer);
    } on ApiException catch (e) {
      if (!ref.mounted) return;
      state = EventDetailFailed(e.kind);
    } on Exception {
      // Bentuk respons tak terduga: tetap beri pesan agar layar tidak
      // menggantung di spinner.
      if (!ref.mounted) return;
      state = const EventDetailFailed(ApiExceptionKind.request);
    }
  }

  /// Profil organizer pelengkap: kegagalannya tidak membatalkan detail event
  /// yang sudah berhasil dimuat.
  Future<OrganizerProfile?> _fetchOrganizerOrNull(String? organizerId) async {
    if (organizerId == null || organizerId.isEmpty) return null;
    try {
      return await ref
          .read(eventDetailRepositoryProvider)
          .fetchOrganizer(organizerId);
    } on Object {
      return null;
    }
  }
}

final eventDetailControllerProvider =
    NotifierProvider.family<EventDetailController, EventDetailState, String>(
      EventDetailController.new,
    );
