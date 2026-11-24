import 'package:flutter/foundation.dart';

/// Urutan katalog yang didukung Soundtix (`GET /events?sort=`).
enum CatalogSort {
  nearest('terdekat'),
  newest('terbaru'),
  cheapest('termurah');

  const CatalogSort(this.apiValue);

  /// Nilai yang dikirim ke API (kontrak backend berbahasa Indonesia).
  final String apiValue;
}

/// Kata kunci + filter aktif katalog. Immutable supaya controller dapat
/// membandingkan permintaan lama/baru dan UI aman membacanya saat loading.
@immutable
class CatalogFilters {
  const CatalogFilters({
    this.query = '',
    this.city = '',
    this.genre = '',
    this.sort = CatalogSort.nearest,
  });

  final String query;
  final String city;
  final String genre;
  final CatalogSort sort;

  /// Ada filter selain urutan bawaan yang layak ditampilkan sebagai chip.
  bool get hasNarrowingFilter =>
      city.trim().isNotEmpty ||
      genre.trim().isNotEmpty ||
      sort != CatalogSort.nearest;

  CatalogFilters copyWith({
    String? query,
    String? city,
    String? genre,
    CatalogSort? sort,
  }) => CatalogFilters(
    query: query ?? this.query,
    city: city ?? this.city,
    genre: genre ?? this.genre,
    sort: sort ?? this.sort,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CatalogFilters &&
          other.query == query &&
          other.city == city &&
          other.genre == genre &&
          other.sort == sort;

  @override
  int get hashCode => Object.hash(query, city, genre, sort);
}
