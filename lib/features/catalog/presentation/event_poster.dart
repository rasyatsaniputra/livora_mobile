import 'package:flutter/material.dart';

import '../../../core/config/app_config.dart';

/// Poster event dengan placeholder gradien saat URL kosong/gagal dimuat.
/// Dipakai kartu katalog (tiket 06) dan halaman detail (tiket 07).
class EventPoster extends StatelessWidget {
  const EventPoster({required this.posterUrl, this.iconSize = 36, super.key});

  final String? posterUrl;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final placeholder = _PosterPlaceholder(iconSize: iconSize);
    final url = posterUrl?.trim();
    if (url == null || url.isEmpty) return placeholder;

    return Image.network(
      AppConfig.mediaUrl(url),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => placeholder,
      loadingBuilder: (context, child, progress) =>
          progress == null ? child : placeholder,
    );
  }
}

class _PosterPlaceholder extends StatelessWidget {
  const _PosterPlaceholder({required this.iconSize});

  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.secondaryContainer,
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.music_note,
          size: iconSize,
          color: theme.colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}
