import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/l10n/locale_provider.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/presentation/error_message.dart';
import '../../../core/router/app_routes.dart';
import '../data/catalog_event.dart';
import '../data/catalog_filters.dart';
import 'catalog_controller.dart';
import 'catalog_event_card.dart';
import 'catalog_filter_sheet.dart';
import 'catalog_sort_label.dart';
import 'catalog_stats_card.dart';

/// Tab Katalog (tiket 06): daftar konser berposter dari Soundtix beserta
/// statistik platform, pencarian kata kunci, dan filter kota/genre/urutan.
/// State loading, error, dan kosong ditampilkan eksplisit (story 40–41).
class CatalogScreen extends ConsumerStatefulWidget {
  const CatalogScreen({super.key});

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  final _search = TextEditingController();
  Timer? _searchDebounce;
  var _hasSearchText = false;

  @override
  void initState() {
    super.initState();
    // Muat saat layar dibuat (pembukaan aplikasi / sesudah login). State
    // provider dipertahankan saat berpindah tab supaya hasil & filter tidak
    // hilang, tetapi sesi baru selalu memulai katalog yang segar.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(catalogControllerProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() => _hasSearchText = value.isNotEmpty);
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      ref.read(catalogControllerProvider.notifier).search(value);
    });
  }

  void _submitSearch(String value) {
    _searchDebounce?.cancel();
    ref.read(catalogControllerProvider.notifier).search(value);
  }

  void _clearSearch() {
    _searchDebounce?.cancel();
    _search.clear();
    setState(() => _hasSearchText = false);
    ref.read(catalogControllerProvider.notifier).search('');
  }

  Future<void> _openFilters() async {
    // Jangan batalkan debounce pencarian: bila lembar filter ditutup tanpa
    // menerapkan apa pun, kata kunci yang baru diketik tetap dijalankan.
    final current = ref
        .read(catalogControllerProvider)
        .filters
        .copyWith(query: _search.text);
    final result = await showModalBottomSheet<CatalogFilters>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => CatalogFilterSheet(filters: current),
    );
    if (result == null || !mounted) return;
    await ref
        .read(catalogControllerProvider.notifier)
        .setFilters(
          query: result.query,
          city: result.city,
          genre: result.genre,
          sort: result.sort,
        );
  }

  Future<void> _resetAll() async {
    _searchDebounce?.cancel();
    _search.clear();
    setState(() => _hasSearchText = false);
    await ref.read(catalogControllerProvider.notifier).resetAll();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(catalogControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navCatalog),
        actions: [
          IconButton(
            key: const Key('catalogBookmarksButton'),
            tooltip: l10n.bookmarksTitle,
            icon: const Icon(Icons.bookmark_border),
            onPressed: () => context.push(AppRoutes.bookmarks),
          ),
          const _LanguageToggle(),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              key: const Key('catalogSearchField'),
              controller: _search,
              textInputAction: TextInputAction.search,
              onChanged: _onSearchChanged,
              onSubmitted: _submitSearch,
              decoration: InputDecoration(
                hintText: l10n.catalogSearchHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _hasSearchText
                    ? IconButton(
                        tooltip: l10n.catalogClearSearch,
                        icon: const Icon(Icons.close),
                        onPressed: _clearSearch,
                      )
                    : null,
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
          _FilterBar(
            filters: state.filters,
            onOpenFilters: _openFilters,
            onFiltersChanged: (filters) => ref
                .read(catalogControllerProvider.notifier)
                .setFilters(
                  query: filters.query,
                  city: filters.city,
                  genre: filters.genre,
                  sort: filters.sort,
                ),
            onResetFilters: () =>
                ref.read(catalogControllerProvider.notifier).resetFilters(),
          ),
          Expanded(
            child: switch (state) {
              CatalogIdle() || CatalogLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
              CatalogFailed(:final kind) => _CatalogErrorView(
                kind: kind,
                onRetry: () =>
                    ref.read(catalogControllerProvider.notifier).retry(),
              ),
              CatalogReady(:final events, :final stats) =>
                events.isEmpty
                    ? _CatalogEmptyView(
                        stats: stats,
                        filters: state.filters,
                        onReset: _resetAll,
                      )
                    : _CatalogList(events: events, stats: stats),
            },
          ),
        ],
      ),
    );
  }
}

class _CatalogList extends StatelessWidget {
  const _CatalogList({required this.events, required this.stats});

  final List<CatalogEvent> events;
  final CatalogStats? stats;

  @override
  Widget build(BuildContext context) {
    final hasStats = stats != null;
    final headerCount = hasStats ? 1 : 0;

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: events.length + headerCount,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (hasStats && index == 0) {
          return CatalogStatsCard(stats: stats!);
        }
        return CatalogEventCard(event: events[index - headerCount]);
      },
    );
  }
}

class _CatalogEmptyView extends StatelessWidget {
  const _CatalogEmptyView({
    required this.stats,
    required this.filters,
    required this.onReset,
  });

  final CatalogStats? stats;
  final CatalogFilters filters;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final canReset = filters != const CatalogFilters();

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        if (stats != null) ...[
          CatalogStatsCard(stats: stats!),
          const SizedBox(height: 24),
        ],
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Column(
            children: [
              Icon(
                Icons.event_busy_outlined,
                size: 48,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.catalogEmptyTitle,
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                l10n.catalogEmptyBody,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              if (canReset) ...[
                const SizedBox(height: 16),
                OutlinedButton(
                  key: const Key('catalogEmptyResetButton'),
                  onPressed: onReset,
                  child: Text(l10n.catalogEmptyAction),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _CatalogErrorView extends StatelessWidget {
  const _CatalogErrorView({required this.kind, required this.onRetry});

  final ApiExceptionKind kind;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 48,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 12),
            ErrorMessage(apiErrorText(kind, l10n)),
            const SizedBox(height: 16),
            FilledButton(
              key: const Key('catalogRetryButton'),
              onPressed: onRetry,
              child: Text(l10n.catalogRetry),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.filters,
    required this.onOpenFilters,
    required this.onFiltersChanged,
    required this.onResetFilters,
  });

  final CatalogFilters filters;
  final VoidCallback onOpenFilters;
  final ValueChanged<CatalogFilters> onFiltersChanged;
  final VoidCallback onResetFilters;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final city = filters.city.trim();
    final genre = filters.genre.trim();

    return SizedBox(
      height: 56,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          OutlinedButton.icon(
            key: const Key('catalogFilterButton'),
            onPressed: onOpenFilters,
            icon: const Icon(Icons.tune, size: 18),
            label: Text(l10n.catalogFilter),
          ),
          if (city.isNotEmpty) ...[
            const SizedBox(width: 8),
            InputChip(
              label: Text(city),
              visualDensity: VisualDensity.compact,
              onDeleted: () => onFiltersChanged(filters.copyWith(city: '')),
            ),
          ],
          if (genre.isNotEmpty) ...[
            const SizedBox(width: 8),
            InputChip(
              label: Text(genre),
              visualDensity: VisualDensity.compact,
              onDeleted: () => onFiltersChanged(filters.copyWith(genre: '')),
            ),
          ],
          if (filters.sort != CatalogSort.nearest) ...[
            const SizedBox(width: 8),
            InputChip(
              label: Text(catalogSortLabel(l10n, filters.sort)),
              visualDensity: VisualDensity.compact,
              onDeleted: () =>
                  onFiltersChanged(filters.copyWith(sort: CatalogSort.nearest)),
            ),
          ],
          if (filters.hasNarrowingFilter) ...[
            const SizedBox(width: 4),
            TextButton(
              onPressed: onResetFilters,
              child: Text(l10n.catalogResetFilters),
            ),
          ],
        ],
      ),
    );
  }
}

/// Toggle bahasa manual: Indonesia default, English opsional (R3 bagian 01).
class _LanguageToggle extends ConsumerWidget {
  const _LanguageToggle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(localeControllerProvider);

    return PopupMenuButton<String>(
      tooltip: l10n.changeLanguage,
      icon: const Icon(Icons.language),
      initialValue: locale.languageCode,
      onSelected: (code) =>
          ref.read(localeControllerProvider.notifier).setLocale(Locale(code)),
      itemBuilder: (context) => [
        PopupMenuItem(value: 'id', child: Text(l10n.languageIndonesian)),
        PopupMenuItem(value: 'en', child: Text(l10n.languageEnglish)),
      ],
    );
  }
}
