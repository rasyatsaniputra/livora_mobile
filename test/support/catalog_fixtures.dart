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
  bool bookmarked = false,
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
  'is_bookmarked': bookmarked,
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

/// Kategori tiket pada detail event (`GET /events/:id` → `categories[]`).
Map<String, Object?> ticketCategoryJson({
  Object? id = 1,
  String name = 'VIP Front Row',
  Object? price = 1500000,
  int quotaTotal = 500,
  int quotaSold = 20,
  int quotaAvailable = 480,
  int maxPerTransaction = 2,
}) => {
  'id': id,
  'event_id': 1,
  'nama_kategori': name,
  'harga': price,
  'kuota_total': quotaTotal,
  'kuota_hold': 0,
  'kuota_terjual': quotaSold,
  'kuota_komplimen': 0,
  'kuota_tersedia': quotaAvailable,
  'max_per_transaksi': maxPerTransaction,
  'created_at': '2026-01-05T10:00:00.000Z',
};

/// Detail event (`GET /events/:id`): field katalog + deskripsi, kategori,
/// dan agregat kuota yang dihitung backend.
Map<String, Object?> eventDetailJson({
  Object? id = 1,
  String name = 'Soundtix Fest 2026: The Grand Stage',
  String description = 'Konser musik akbar persembahan siswa UKK Kelas 12.',
  String artist = 'Sheila on 7, Tulus, Hindia',
  String venue = 'Gelora Bung Karno Stadium, Jakarta',
  String? city = 'Jakarta',
  String? genre = 'Electronic',
  String? posterUrl = '/uploads/fest.png',
  String startsAt = '2026-12-30T19:00:00.000Z',
  String endsAt = '2026-12-31T01:30:00.000Z',
  Object? organizerId = 1,
  String? organizationName = 'Soundtix Live',
  int totalQuota = 1500,
  int soldQuota = 35,
  int availableQuota = 1465,
  bool soldOut = false,
  bool bookmarked = false,
  List<Map<String, Object?>>? categories,
}) => {
  ...catalogEventJson(
    id: id,
    name: name,
    venue: venue,
    city: city,
    genre: genre,
    posterUrl: posterUrl,
    startsAt: startsAt,
    bookmarked: bookmarked,
  ),
  'deskripsi': description,
  'artis': artist,
  'tanggal_selesai': endsAt,
  'organizer_id': organizerId,
  'organization_name': organizationName,
  'total_quota': totalQuota,
  'sold_quota': soldQuota,
  'available_quota': availableQuota,
  'is_sold_out': soldOut,
  'occupancy_percent': 2,
  'is_bookmarked': bookmarked,
  'lineup': ['Sheila on 7', 'Tulus', 'Hindia'],
  'rundown': [
    {'waktu': '19:00', 'acara': 'Open gate'},
  ],
  'facilities': ['Parkir', 'Toilet'],
  'rules': ['Dilarang membawa makanan dari luar'],
  'categories':
      categories ??
      [
        ticketCategoryJson(),
        ticketCategoryJson(
          id: 2,
          name: 'Regular',
          price: '350000',
          quotaTotal: 1000,
          quotaSold: 15,
          quotaAvailable: 985,
          maxPerTransaction: 4,
        ),
      ],
};

Map<String, Object?> eventDetailResponse([Map<String, Object?>? detail]) => {
  'success': true,
  'message': 'Detail event berhasil diambil',
  'data': detail ?? eventDetailJson(),
};

/// Profil publik promotor (`GET /organizers/:id`).
Map<String, Object?> organizerJson({
  Object? id = 1,
  String name = 'Soundtix Live Official',
  String verificationStatus = 'verified',
}) => {
  'id': id,
  'organization_name': name,
  'verification_status': verificationStatus,
  'created_at': '2025-06-01T08:00:00.000Z',
};

Map<String, Object?> organizerResponse([Map<String, Object?>? organizer]) => {
  'success': true,
  'message': 'Profil publik promotor berhasil diambil',
  'data': organizer ?? organizerJson(),
};

/// Satu event pada daftar bookmark (`GET /users/bookmarks`). Bentuknya
/// ringkasan event + `bookmarked_at`; tidak memuat genre/kota/status habis
/// seperti katalog.
Map<String, Object?> bookmarkEventJson({
  Object? id = 1,
  String name = 'Soundtix Fest 2026: The Grand Stage',
  String venue = 'Gelora Bung Karno Stadium, Jakarta',
  String? posterUrl = '/uploads/fest.png',
  String startsAt = '2026-12-30T19:00:00.000Z',
  String endsAt = '2026-12-31T01:30:00.000Z',
  Object? minPrice = 350000,
  String bookmarkedAt = '2026-11-01T10:00:00.000Z',
}) => {
  'id': id,
  'nama_event': name,
  'poster_url': posterUrl,
  'tanggal_mulai': startsAt,
  'tanggal_selesai': endsAt,
  'alamat': venue,
  'lat': -6.2186,
  'lng': 106.8026,
  'artis': 'Sheila on 7, Tulus, Hindia',
  'status': 'published',
  'bookmarked_at': bookmarkedAt,
  'min_price': minPrice,
  'is_bookmarked': true,
};

Map<String, Object?> bookmarksResponse(List<Map<String, Object?>> events) => {
  'success': true,
  'message': 'Daftar konser tersimpan (wishlist) berhasil diambil',
  'data': events,
};

/// Respons `POST /events/:id/bookmark` — data berisi status hasil toggle.
Map<String, Object?> bookmarkToggleResponse(bool bookmarked) => {
  'success': true,
  'message': bookmarked
      ? 'Event disimpan ke bookmark'
      : 'Event dihapus dari bookmark',
  'data': {'bookmarked': bookmarked},
};
