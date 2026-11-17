import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'token_store.dart';

/// Implementasi [TokenStore] dengan flutter_secure_storage — access dan
/// refresh token tersimpan terenkripsi di penyimpanan aman platform
/// (keputusan rancangan bagian 1: bukan shared_preferences).
class SecureTokenStore implements TokenStore {
  SecureTokenStore(this._storage);

  final FlutterSecureStorage _storage;

  static const _accessKey = 'soundtix_access_token';
  static const _refreshKey = 'soundtix_refresh_token';

  @override
  Future<String?> readAccessToken() => _storage.read(key: _accessKey);

  @override
  Future<String?> readRefreshToken() => _storage.read(key: _refreshKey);

  @override
  Future<void> save({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _accessKey, value: accessToken);
    await _storage.write(key: _refreshKey, value: refreshToken);
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
  }
}
