import '../../../core/l10n/generated/app_localizations.dart';
import '../data/catalog_filters.dart';

/// Label urutan katalog — satu titik agar lembar filter dan chip aktif
/// memakai teks yang sama.
String catalogSortLabel(AppLocalizations l10n, CatalogSort sort) =>
    switch (sort) {
      CatalogSort.nearest => l10n.catalogSortNearest,
      CatalogSort.newest => l10n.catalogSortNewest,
      CatalogSort.cheapest => l10n.catalogSortCheapest,
    };
