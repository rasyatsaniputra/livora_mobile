import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/providers.dart';

/// State smoke test fondasi: apakah backend Soundtix terjangkau dari emulator
/// (story 40 & 41 — pesan error jelas + indikator loading).
sealed class HealthCheckState {
  const HealthCheckState();
}

final class HealthIdle extends HealthCheckState {
  const HealthIdle();
}

final class HealthLoading extends HealthCheckState {
  const HealthLoading();
}

final class HealthSuccess extends HealthCheckState {
  const HealthSuccess();
}

final class HealthFailure extends HealthCheckState {
  const HealthFailure(this.kind);

  final ApiExceptionKind kind;
}

class HealthCheckController extends Notifier<HealthCheckState> {
  @override
  HealthCheckState build() => const HealthIdle();

  /// Memanggil endpoint liveness `/health/` Soundtix.
  Future<void> check() async {
    state = const HealthLoading();
    try {
      // Body /health/ tidak dipakai — cukup status 200 berarti terjangkau.
      await ref.read(apiClientProvider).get<Map<String, dynamic>>('/health/');
      state = const HealthSuccess();
    } on ApiException catch (e) {
      state = HealthFailure(e.kind);
    }
  }
}

final healthCheckControllerProvider =
    NotifierProvider<HealthCheckController, HealthCheckState>(
  HealthCheckController.new,
);
