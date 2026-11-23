import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../data/catalog_event.dart';
import '../data/catalog_filters.dart';
import '../data/catalog_repository.dart';

/// Status tab katalog (tiket 06). Filter selalu ikut dibawa supaya UI tetap
/// menampilkan pilihan user saat loading maupun gagal.
sealed class CatalogState {
  const CatalogState({this.filters = const CatalogFilters(), this.stats});

  final CatalogFilters filters;

  /// Statistik platform; null bila belum pernah berhasil dimuat. Statistik
  /// bersifat pelengkap — kegagalannya tidak menggagalkan daftar event.
  final CatalogStats? stats;
}

/// Belum ada permintaan — layar memicu [CatalogController.load] saat dibuka.
final class CatalogIdle extends CatalogState {
  const CatalogIdle({super.filters, super.stats});
}

final class CatalogLoading extends CatalogState {
  const CatalogLoading({super.filters, super.stats});
}

final class CatalogReady extends CatalogState {
  const CatalogReady({required this.events, super.filters, super.stats});

  final List<CatalogEvent> events;
}

/// Gagal memuat daftar event — layar menampilkan pesan per [ApiExceptionKind]
/// beserta tombol coba lagi (story 40–41).
final class CatalogFailed extends CatalogState {
  const CatalogFailed(this.kind, {super.filters, super.stats});

  final ApiExceptionKind kind;
}

class CatalogController extends Notifier<CatalogState> {
  /// Nomor permintaan terakhir — respons lama (mis. pencarian sebelumnya)
  /// tidak boleh menimpa hasil yang lebih baru.
  var _requestId = 0;

  @override
  CatalogState build() => const CatalogIdle();

  /// Muat daftar + statistik (pembukaan layar, sesudah login, atau coba lagi).
  Future<void> load() => _fetch(includeStats: true);

  /// Coba lagi setelah gagal tanpa membuang filter yang sudah dipilih.
  Future<void> retry() => _fetch(includeStats: state.stats == null);

  /// Kata kunci berubah — statistik tidak perlu diambil ulang.
  Future<void> search(String query) {
    final filters = state.filters.copyWith(query: query);
    if (filters == state.filters) return Future.value();
    return _fetch(filters: filters, includeStats: false);
  }

  /// Terapkan filter kota/genre/urutan dari lembar filter.
  Future<void> setFilters({
    String? query,
    String? city,
    String? genre,
    CatalogSort? sort,
  }) {
    final filters = state.filters.copyWith(
      query: query,
      city: city,
      genre: genre,
      sort: sort,
    );
    if (filters == state.filters) return Future.value();
    return _fetch(filters: filters, includeStats: false);
  }

  /// Hapus filter kota/genre/urutan, pertahankan kata kunci pencarian.
  Future<void> resetFilters() {
    final filters = CatalogFilters(query: state.filters.query);
    if (filters == state.filters) return Future.value();
    return _fetch(filters: filters, includeStats: false);
  }

  /// Kosongkan pencarian sekaligus filter (tombol pada empty state).
  Future<void> resetAll() {
    if (state.filters == const CatalogFilters()) return Future.value();
    return _fetch(filters: const CatalogFilters(), includeStats: false);
  }

  Future<void> _fetch({
    CatalogFilters? filters,
    required bool includeStats,
  }) async {
    final effectiveFilters = filters ?? state.filters;
    final previousStats = state.stats;
    final requestId = ++_requestId;

    state = CatalogLoading(filters: effectiveFilters, stats: previousStats);

    try {
      final events = await ref
          .read(catalogRepositoryProvider)
          .fetchEvents(
            query: effectiveFilters.query,
            city: effectiveFilters.city,
            genre: effectiveFilters.genre,
            sort: effectiveFilters.sort,
          );

      var stats = previousStats;
      if (includeStats) {
        stats = await _fetchStatsOrKeep(previousStats);
      }

      if (!ref.mounted || requestId != _requestId) return;
      state = CatalogReady(
        events: events,
        filters: effectiveFilters,
        stats: stats,
      );
    } on ApiException catch (e) {
      if (!ref.mounted || requestId != _requestId) return;
      state = CatalogFailed(
        e.kind,
        filters: effectiveFilters,
        stats: previousStats,
      );
    } on Exception {
      // Bentuk respons tak terduga: tetap beri pesan agar layar tidak
      // menggantung di spinner (story 40).
      if (!ref.mounted || requestId != _requestId) return;
      state = CatalogFailed(
        ApiExceptionKind.request,
        filters: effectiveFilters,
        stats: previousStats,
      );
    }
  }

  /// Statistik pelengkap: bila gagal, pertahankan nilai lama (bila ada)
  /// dan jangan gagalkan daftar event yang sudah berhasil dimuat.
  Future<CatalogStats?> _fetchStatsOrKeep(CatalogStats? previous) async {
    try {
      return await ref.read(catalogRepositoryProvider).fetchStats();
    } on Object {
      return previous;
    }
  }
}

final catalogControllerProvider =
    NotifierProvider<CatalogController, CatalogState>(CatalogController.new);
