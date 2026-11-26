import 'package:freezed_annotation/freezed_annotation.dart';

import 'json_parsing.dart';

part 'event_detail.freezed.dart';
part 'event_detail.g.dart';

/// Detail event lengkap dari `GET /events/:id` (tiket 07).
///
/// Backend menghitung agregat kuota dan menyertakan `categories` pada
/// respons yang sama, jadi layar detail tidak perlu memanggil endpoint
/// kategori terpisah.
@freezed
abstract class EventDetail with _$EventDetail {
  const factory EventDetail({
    @JsonKey(fromJson: idFromJson) String? id,
    @JsonKey(name: 'nama_event') @Default('') String name,
    @JsonKey(name: 'deskripsi') @Default('') String description,
    @JsonKey(name: 'artis') @Default('') String artist,

    /// Alamat venue — backend menyebutnya `alamat`.
    @JsonKey(name: 'alamat') @Default('') String venue,
    @JsonKey(name: 'kota') String? city,
    String? genre,
    @JsonKey(name: 'poster_url') String? posterUrl,
    @JsonKey(name: 'tanggal_mulai', fromJson: dateFromJson) DateTime? startsAt,
    @JsonKey(name: 'tanggal_selesai', fromJson: dateFromJson) DateTime? endsAt,
    @JsonKey(name: 'kapasitas_venue', fromJson: intFromJson)
    @Default(0)
    int capacity,
    @JsonKey(name: 'organizer_id', fromJson: idFromJson) String? organizerId,
    @JsonKey(name: 'organization_name') String? organizationName,
    @JsonKey(name: 'total_quota', fromJson: intFromJson)
    @Default(0)
    int totalQuota,
    @JsonKey(name: 'sold_quota', fromJson: intFromJson)
    @Default(0)
    int soldQuota,
    @JsonKey(name: 'available_quota', fromJson: intFromJson)
    @Default(0)
    int availableQuota,
    @JsonKey(name: 'is_sold_out') @Default(false) bool soldOut,
    @JsonKey(name: 'occupancy_percent', fromJson: intFromJson)
    @Default(0)
    int occupancyPercent,
    @JsonKey(name: 'is_bookmarked') @Default(false) bool bookmarked,
    @Default(<TicketCategory>[]) List<TicketCategory> categories,
  }) = _EventDetail;

  factory EventDetail.fromJson(Map<String, Object?> json) =>
      _$EventDetailFromJson(json);
}

/// Satu kategori tiket pada detail event — read-only untuk ticket 07.
/// Kuota tersedia dihitung backend (`kuota_total - hold - terjual - komplimen`).
@freezed
abstract class TicketCategory with _$TicketCategory {
  const factory TicketCategory({
    @JsonKey(fromJson: idFromJson) String? id,
    @JsonKey(name: 'nama_kategori') @Default('') String name,
    @JsonKey(name: 'harga', fromJson: numFromJson) @Default(0) num price,
    @JsonKey(name: 'kuota_total', fromJson: intFromJson)
    @Default(0)
    int quotaTotal,
    @JsonKey(name: 'kuota_terjual', fromJson: intFromJson)
    @Default(0)
    int quotaSold,
    @JsonKey(name: 'kuota_tersedia', fromJson: intFromJson)
    @Default(0)
    int quotaAvailable,
    @JsonKey(name: 'max_per_transaksi', fromJson: intFromJson)
    @Default(0)
    int maxPerTransaction,
  }) = _TicketCategory;

  factory TicketCategory.fromJson(Map<String, Object?> json) =>
      _$TicketCategoryFromJson(json);
}

/// Profil publik penyelenggara dari `GET /organizers/:id`.
@freezed
abstract class OrganizerProfile with _$OrganizerProfile {
  const factory OrganizerProfile({
    @JsonKey(fromJson: idFromJson) String? id,
    @JsonKey(name: 'organization_name') @Default('') String name,
    @JsonKey(name: 'verification_status') String? verificationStatus,
    @JsonKey(name: 'created_at', fromJson: dateFromJson) DateTime? createdAt,
  }) = _OrganizerProfile;

  factory OrganizerProfile.fromJson(Map<String, Object?> json) =>
      _$OrganizerProfileFromJson(json);
}
