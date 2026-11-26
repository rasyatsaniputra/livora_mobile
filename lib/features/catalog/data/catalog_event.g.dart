// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CatalogEvent _$CatalogEventFromJson(Map<String, dynamic> json) =>
    _CatalogEvent(
      id: idFromJson(json['id']),
      name: json['nama_event'] as String,
      venue: json['alamat'] as String? ?? '',
      genre: json['genre'] as String?,
      posterUrl: json['poster_url'] as String?,
      startsAt: dateFromJson(json['tanggal_mulai']),
      minPrice: json['min_price'] == null ? 0 : numFromJson(json['min_price']),
      soldOut: json['is_sold_out'] as bool? ?? false,
    );

Map<String, dynamic> _$CatalogEventToJson(_CatalogEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nama_event': instance.name,
      'alamat': instance.venue,
      'genre': instance.genre,
      'poster_url': instance.posterUrl,
      'tanggal_mulai': instance.startsAt?.toIso8601String(),
      'min_price': instance.minPrice,
      'is_sold_out': instance.soldOut,
    };

_CatalogStats _$CatalogStatsFromJson(Map<String, dynamic> json) =>
    _CatalogStats(
      activeEvents: json['active_events_count'] == null
          ? 0
          : intFromJson(json['active_events_count']),
      ticketsSold: json['tickets_sold_count'] == null
          ? 0
          : intFromJson(json['tickets_sold_count']),
      verifiedOrganizers: json['verified_organizers_count'] == null
          ? 0
          : intFromJson(json['verified_organizers_count']),
      cities: json['cities_count'] == null
          ? 0
          : intFromJson(json['cities_count']),
    );

Map<String, dynamic> _$CatalogStatsToJson(_CatalogStats instance) =>
    <String, dynamic>{
      'active_events_count': instance.activeEvents,
      'tickets_sold_count': instance.ticketsSold,
      'verified_organizers_count': instance.verifiedOrganizers,
      'cities_count': instance.cities,
    };
