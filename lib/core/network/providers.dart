import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../auth/secure_token_store.dart';
import '../auth/token_store.dart';
import 'api_client.dart';

/// Penyimpanan token (secure storage) di satu titik. Test modul mana pun
/// dapat menggantinya dengan penyimpanan di memori lewat override:
///
/// ```dart
/// tokenStoreProvider.overrideWithValue(MemoryTokenStore(...))
/// ```
final tokenStoreProvider = Provider<TokenStore>(
  (ref) => SecureTokenStore(const FlutterSecureStorage()),
);

/// Satu ApiClient untuk seluruh aplikasi; test meng-override provider ini
/// dengan ApiClient ber-adapter palsu (seam HTTP, lihat spec Testing Decisions).
///
/// Interseptor Bearer + auto-refresh terpasang otomatis karena
/// [tokenStoreProvider] selalu tersedia (lihat tiket 02).
final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(tokenStore: ref.watch(tokenStoreProvider)),
);
