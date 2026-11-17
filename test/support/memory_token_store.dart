import 'package:livora_mobile/core/auth/token_store.dart';

/// TokenStore palsu di memori — dipakai test lewat override provider
/// (pola "override provider + adapter palsu", tiket 02).
class MemoryTokenStore implements TokenStore {
  MemoryTokenStore({this.accessToken, this.refreshToken});

  String? accessToken;
  String? refreshToken;

  @override
  Future<String?> readAccessToken() async => accessToken;

  @override
  Future<String?> readRefreshToken() async => refreshToken;

  @override
  Future<void> save({
    required String accessToken,
    required String refreshToken,
  }) async {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
  }

  @override
  Future<void> clear() async {
    accessToken = null;
    refreshToken = null;
  }
}
