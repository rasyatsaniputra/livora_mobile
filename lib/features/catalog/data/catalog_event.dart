import 'package:freezed_annotation/freezed_annotation.dart';

import 'json_parsing.dart';

part 'catalog_event.freezed.dart';
part 'catalog_event.g.dart';

/// Satu event pada katalog Soundtix (`GET /events`).
///
/// Hanya field ringkasan yang dipakai kartu katalog dan daftar bookmark yang
/// dipetakan; detail event dan kuota per kategori punya model sendiri.
@freezed
abstract class CatalogEvent with _$CatalogEvent {
  const factory CatalogEvent({
    @JsonKey(fromJson: idFromJson) String? id,
    @JsonKey(name: 'nama_event') required String name,

    /// Alamat venue — disebut `alamat` oleh backend.
    @JsonKey(name: 'alamat') @Default('') String venue,
    String? genre,
    @JsonKey(name: 'poster_url') String? posterUrl,
    @JsonKey(name: 'tanggal_mulai', fromJson: dateFromJson) DateTime? startsAt,
    @JsonKey(name: 'min_price', fromJson: numFromJson) @Default(0) num minPrice,
    @JsonKey(name: 'is_sold_out') @Default(false) bool soldOut,
  }) = _CatalogEvent;

  factory CatalogEvent.fromJson(Map<String, Object?> json) =>
      _$CatalogEventFromJson(json);
}

/// Metrik agregat platform (`GET /events/stats`).
@freezed
abstract class CatalogStats with _$CatalogStats {
  const factory CatalogStats({
    @JsonKey(name: 'active_events_count', fromJson: intFromJson)
    @Default(0)
    int activeEvents,
    @JsonKey(name: 'tickets_sold_count', fromJson: intFromJson)
    @Default(0)
    int ticketsSold,
    @JsonKey(name: 'verified_organizers_count', fromJson: intFromJson)
    @Default(0)
    int verifiedOrganizers,
    @JsonKey(name: 'cities_count', fromJson: intFromJson)
    @Default(0)
    int cities,
  }) = _CatalogStats;

  factory CatalogStats.fromJson(Map<String, Object?> json) =>
      _$CatalogStatsFromJson(json);
}
