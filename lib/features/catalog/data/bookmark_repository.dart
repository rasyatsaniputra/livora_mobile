import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_envelope.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/providers.dart';
import 'catalog_event.dart';

/// Kontrak data bookmark (tiket 08):
/// `GET /users/bookmarks` untuk daftar event tersimpan dan
/// `POST /events/:id/bookmark` untuk toggle simpan/hapus.
///
/// Daftar bookmark memakai bentuk ringkasan event yang sama dengan katalog
/// (backend tidak mengirim genre/kota/status habis), sehingga [CatalogEvent]
/// dipakai ulang untuk kartu dan navigasi ke detail.
class BookmarkRepository {
  BookmarkRepository({required this.client});

  final ApiClient client;

  Future<List<CatalogEvent>> fetchBookmarks() async {
    final response = await client.get<Object?>('/users/bookmarks');
    final data = envelopeData(response);
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

  /// Toggle simpan/hapus dan kembalikan status terbaru dari server.
  Future<bool> toggleBookmark(String eventId) async {
    final response = await client.post<Object?>('/events/$eventId/bookmark');
    final data = envelopeDataMap(response);
    final bookmarked = data['bookmarked'];
    if (bookmarked is! bool) throw ApiException(ApiExceptionKind.server);
    return bookmarked;
  }
}

final bookmarkRepositoryProvider = Provider<BookmarkRepository>(
  (ref) => BookmarkRepository(client: ref.watch(apiClientProvider)),
);
