import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_client.dart';

/// Satu ApiClient untuk seluruh aplikasi; test meng-override provider ini
/// dengan ApiClient ber-adapter palsu (seam HTTP, lihat spec Testing Decisions).
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());
