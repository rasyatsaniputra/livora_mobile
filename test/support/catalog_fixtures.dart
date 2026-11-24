/// Contoh respons Soundtix untuk katalog event (bentuk mengikuti backend:
/// envelope `{success, message, data}` — lihat `docs/soundtix-api-*.json`
/// dan `Backend-Ukk12/src/repositories/eventRepositories.ts`).
Map<String, Object?> catalogEventJson({
  Object? id = 1,
  String name = 'Soundtix Fest 2026: The Grand Stage',
  String venue = 'Gelora Bung Karno Stadium, Jakarta',
  String? city = 'Jakarta',
  String? genre = 'Electronic',
  String? posterUrl = '/uploads/fest.png',
  String startsAt = '2026-12-30T19:00:00.000Z',
  Object? minPrice = 350000,
  int soldQuota = 35,
  bool soldOut = false,
}) => {
  'id': id,
  'nama_event': name,
  'deskripsi': 'Konser musik akbar persembahan siswa UKK Kelas 12.',
  'artis': 'Sheila on 7, Tulus, Hindia',
  'alamat': venue,
  'lat': -6.2186,
  'lng': 106.8026,
  'poster_url': posterUrl,
  'kapasitas_venue': 5000,
  'tanggal_mulai': startsAt,
  'tanggal_selesai': '2026-12-31T01:30:00.000Z',
  'status': 'published',
  'is_paused': false,
  'genre': genre,
  'kota': city,
  'organizer_id': 1,
  'organization_name': 'Soundtix Live',
  'min_price': minPrice,
  'total_quota': 5000,
  'sold_quota': soldQuota,
  'available_quota': 5000 - soldQuota,
  'is_sold_out': soldOut,
  'is_bookmarked': false,
  'occupancy_percent': 1,
};

Map<String, Object?> catalogEventsResponse(List<Map<String, Object?>> events) =>
    {
      'success': true,
      'message': 'Katalog event berhasil diambil',
      'data': events,
    };

Map<String, Object?> catalogStatsJson({
  int activeEvents = 12,
  int ticketsSold = 3450,
  int verifiedOrganizers = 4,
  int cities = 7,
}) => {
  'active_events_count': activeEvents,
  'tickets_sold_count': ticketsSold,
  'verified_organizers_count': verifiedOrganizers,
  'cities_count': cities,
};

Map<String, Object?> catalogStatsResponse([Map<String, Object?>? stats]) => {
  'success': true,
  'message': 'Statistik publik platform berhasil diambil',
  'data': stats ?? catalogStatsJson(),
};
