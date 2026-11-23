import 'package:flutter/material.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../data/catalog_filters.dart';
import 'catalog_sort_label.dart';

/// Lembar filter katalog: kota, genre, dan urutan. Mengembalikan
/// [CatalogFilters] baru lewat `Navigator.pop`; layar yang menerapkannya.
class CatalogFilterSheet extends StatefulWidget {
  const CatalogFilterSheet({required this.filters, super.key});

  final CatalogFilters filters;

  @override
  State<CatalogFilterSheet> createState() => _CatalogFilterSheetState();
}

class _CatalogFilterSheetState extends State<CatalogFilterSheet> {
  late final TextEditingController _city;
  late final TextEditingController _genre;
  late CatalogSort _sort;

  @override
  void initState() {
    super.initState();
    _city = TextEditingController(text: widget.filters.city);
    _genre = TextEditingController(text: widget.filters.genre);
    _sort = widget.filters.sort;
  }

  @override
  void dispose() {
    _city.dispose();
    _genre.dispose();
    super.dispose();
  }

  void _apply() {
    Navigator.of(context).pop(
      widget.filters.copyWith(
        city: _city.text.trim(),
        genre: _genre.text.trim(),
        sort: _sort,
      ),
    );
  }

  void _reset() {
    _city.clear();
    _genre.clear();
    setState(() => _sort = CatalogSort.nearest);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.catalogFilterTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('catalogCityField'),
              controller: _city,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: l10n.catalogFilterCity,
                hintText: l10n.catalogFilterCityHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('catalogGenreField'),
              controller: _genre,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _apply(),
              decoration: InputDecoration(
                labelText: l10n.catalogFilterGenre,
                hintText: l10n.catalogFilterGenreHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<CatalogSort>(
              key: const Key('catalogSortField'),
              initialValue: _sort,
              decoration: InputDecoration(
                labelText: l10n.catalogSort,
                border: const OutlineInputBorder(),
              ),
              items: [
                for (final sort in CatalogSort.values)
                  DropdownMenuItem(
                    value: sort,
                    child: Text(catalogSortLabel(l10n, sort)),
                  ),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _sort = value);
              },
            ),
            const SizedBox(height: 24),
            FilledButton(
              key: const Key('catalogApplyFiltersButton'),
              onPressed: _apply,
              child: Text(l10n.catalogApplyFilters),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _reset,
              child: Text(l10n.catalogResetFilters),
            ),
          ],
        ),
      ),
    );
  }
}
