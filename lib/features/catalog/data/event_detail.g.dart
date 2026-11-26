// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EventDetail _$EventDetailFromJson(Map<String, dynamic> json) => _EventDetail(
  id: idFromJson(json['id']),
  name: json['nama_event'] as String? ?? '',
  description: json['deskripsi'] as String? ?? '',
  artist: json['artis'] as String? ?? '',
  venue: json['alamat'] as String? ?? '',
  city: json['kota'] as String?,
  genre: json['genre'] as String?,
  posterUrl: json['poster_url'] as String?,
  startsAt: dateFromJson(json['tanggal_mulai']),
  endsAt: dateFromJson(json['tanggal_selesai']),
  capacity: json['kapasitas_venue'] == null
      ? 0
      : intFromJson(json['kapasitas_venue']),
  organizerId: idFromJson(json['organizer_id']),
  organizationName: json['organization_name'] as String?,
  totalQuota: json['total_quota'] == null
      ? 0
      : intFromJson(json['total_quota']),
  soldQuota: json['sold_quota'] == null ? 0 : intFromJson(json['sold_quota']),
  availableQuota: json['available_quota'] == null
      ? 0
      : intFromJson(json['available_quota']),
  soldOut: json['is_sold_out'] as bool? ?? false,
  occupancyPercent: json['occupancy_percent'] == null
      ? 0
      : intFromJson(json['occupancy_percent']),
  bookmarked: json['is_bookmarked'] as bool? ?? false,
  categories:
      (json['categories'] as List<dynamic>?)
          ?.map((e) => TicketCategory.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <TicketCategory>[],
);

Map<String, dynamic> _$EventDetailToJson(_EventDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nama_event': instance.name,
      'deskripsi': instance.description,
      'artis': instance.artist,
      'alamat': instance.venue,
      'kota': instance.city,
      'genre': instance.genre,
      'poster_url': instance.posterUrl,
      'tanggal_mulai': instance.startsAt?.toIso8601String(),
      'tanggal_selesai': instance.endsAt?.toIso8601String(),
      'kapasitas_venue': instance.capacity,
      'organizer_id': instance.organizerId,
      'organization_name': instance.organizationName,
      'total_quota': instance.totalQuota,
      'sold_quota': instance.soldQuota,
      'available_quota': instance.availableQuota,
      'is_sold_out': instance.soldOut,
      'occupancy_percent': instance.occupancyPercent,
      'is_bookmarked': instance.bookmarked,
      'categories': instance.categories,
    };

_TicketCategory _$TicketCategoryFromJson(Map<String, dynamic> json) =>
    _TicketCategory(
      id: idFromJson(json['id']),
      name: json['nama_kategori'] as String? ?? '',
      price: json['harga'] == null ? 0 : numFromJson(json['harga']),
      quotaTotal: json['kuota_total'] == null
          ? 0
          : intFromJson(json['kuota_total']),
      quotaSold: json['kuota_terjual'] == null
          ? 0
          : intFromJson(json['kuota_terjual']),
      quotaAvailable: json['kuota_tersedia'] == null
          ? 0
          : intFromJson(json['kuota_tersedia']),
      maxPerTransaction: json['max_per_transaksi'] == null
          ? 0
          : intFromJson(json['max_per_transaksi']),
    );

Map<String, dynamic> _$TicketCategoryToJson(_TicketCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nama_kategori': instance.name,
      'harga': instance.price,
      'kuota_total': instance.quotaTotal,
      'kuota_terjual': instance.quotaSold,
      'kuota_tersedia': instance.quotaAvailable,
      'max_per_transaksi': instance.maxPerTransaction,
    };

_OrganizerProfile _$OrganizerProfileFromJson(Map<String, dynamic> json) =>
    _OrganizerProfile(
      id: idFromJson(json['id']),
      name: json['organization_name'] as String? ?? '',
      verificationStatus: json['verification_status'] as String?,
      createdAt: dateFromJson(json['created_at']),
    );

Map<String, dynamic> _$OrganizerProfileToJson(_OrganizerProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organization_name': instance.name,
      'verification_status': instance.verificationStatus,
      'created_at': instance.createdAt?.toIso8601String(),
    };
