import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/providers.dart';
import 'catalog_event.dart';
import 'catalog_filters.dart';

/// Kontrak data katalog (tiket 06) sesuai Soundtix:
/// `GET /events` untuk daftar event dan `GET /events/stats` untuk statistik
/// publik. Semua respons berbentuk envelope `{success, message, data}`.
///
/// Semua request lewat [ApiClient] — test cukup menukar adapter HTTP
/// (seam tunggal, lihat spec Testing Decisions).
class CatalogRepository {
  CatalogRepository({required this.client});

  final ApiClient client;

  /// Daftar event publik (hanya `published`/`ongoing` dari sisi backend).
  ///
  /// [query], [city], dan [genre] kosong tidak dikirim supaya pencarian
  /// "semua" tidak dibatasi parameter kosong.
  Future<List<CatalogEvent>> fetchEvents({
    String query = '',
    String city = '',
    String genre = '',
    CatalogSort sort = CatalogSort.nearest,
    int limit = 50,
    int offset = 0,
  }) async {
    final response = await client.get<Object?>(
      '/events',
      query: _eventQuery(
        query: query,
        city: city,
        genre: genre,
        sort: sort,
        limit: limit,
        offset: offset,
      ),
    );
    final data = _dataOf(response);
    if (data is! List) throw ApiException(ApiExceptionKind.server);
    try {
      return [
        for (final item in data)
          CatalogEvent.fromJson(item as Map<String, Object?>),
      ];
    } on TypeError {
      throw ApiException(ApiExceptionKind.server);
    }
  }

  /// Statistik agregat untuk hero katalog (event aktif, tiket terjual,
  /// promotor terverifikasi, dan jumlah kota).
  Future<CatalogStats> fetchStats() async {
    final response = await client.get<Object?>('/events/stats');
    final data = _dataOf(response);
    if (data is! Map<String, Object?>) {
      throw ApiException(ApiExceptionKind.server);
    }
    try {
      return CatalogStats.fromJson(data);
    } on TypeError {
      throw ApiException(ApiExceptionKind.server);
    }
  }

  Map<String, dynamic> _eventQuery({
    required String query,
    required String city,
    required String genre,
    required CatalogSort sort,
    required int limit,
    required int offset,
  }) {
    final params = <String, dynamic>{'sort': sort.apiValue, 'limit': limit};
    final keyword = query.trim();
    if (keyword.isNotEmpty) params['q'] = keyword;
    final cityFilter = city.trim();
    if (cityFilter.isNotEmpty) params['city'] = cityFilter;
    final genreFilter = genre.trim();
    if (genreFilter.isNotEmpty) params['genre'] = genreFilter;
    if (offset > 0) params['offset'] = offset;
    return params;
  }

  /// Isi `data` dari envelope; bentuk menyimpang dilaporkan sebagai
  /// kesalahan server, bukan crash parse.
  Object? _dataOf(Object? response) {
    if (response is! Map<String, Object?>) {
      throw ApiException(ApiExceptionKind.server);
    }
    return response['data'];
  }
}

/// Satu repository katalog untuk seluruh aplikasi; test meng-override
/// [apiClientProvider] seperti modul sebelumnya.
final catalogRepositoryProvider = Provider<CatalogRepository>(
  (ref) => CatalogRepository(client: ref.watch(apiClientProvider)),
);
