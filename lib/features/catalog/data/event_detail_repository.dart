import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_envelope.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/providers.dart';
import 'event_detail.dart';

/// Kontrak data halaman detail event (tiket 07):
/// `GET /events/:id` untuk detail + kategori tiket, dan `GET /organizers/:id`
/// untuk profil publik penyelenggara. Semua respons berbentuk envelope
/// `{success, message, data}` dan lewat [ApiClient] (seam HTTP tunggal).
class EventDetailRepository {
  EventDetailRepository({required this.client});

  final ApiClient client;

  Future<EventDetail> fetchEventDetail(String id) async {
    final response = await client.get<Object?>('/events/$id');
    return _mapData(response, EventDetail.fromJson);
  }

  Future<OrganizerProfile> fetchOrganizer(String id) async {
    final response = await client.get<Object?>('/organizers/$id');
    return _mapData(response, OrganizerProfile.fromJson);
  }

  /// Isi `data` dari envelope lalu parse; bentuk menyimpang dilaporkan
  /// sebagai kesalahan server, bukan crash parse.
  T _mapData<T>(Object? response, T Function(Map<String, Object?> json) parse) {
    final data = envelopeDataMap(response);
    try {
      return parse(data);
    } on TypeError {
      throw ApiException(ApiExceptionKind.server);
    }
  }
}

final eventDetailRepositoryProvider = Provider<EventDetailRepository>(
  (ref) => EventDetailRepository(client: ref.watch(apiClientProvider)),
);
