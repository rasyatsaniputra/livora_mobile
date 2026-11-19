import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../data/auth_repository.dart';

/// Status permintaan OTP login (form email → layar verifikasi).
sealed class LoginState {
  const LoginState();
}

final class LoginIdle extends LoginState {
  const LoginIdle();
}

final class LoginSubmitting extends LoginState {
  const LoginSubmitting();
}

/// OTP login terkirim — layar menavigasi ke verifikasi OTP.
final class LoginSubmitted extends LoginState {
  const LoginSubmitted(this.challenge);

  final LoginOtpChallenge challenge;
}

final class LoginFailed extends LoginState {
  const LoginFailed(this.kind);

  final ApiExceptionKind kind;
}

class LoginController extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginIdle();

  /// Membersihkan status percobaan sebelumnya; dipanggil saat layar login
  /// dibuat agar error basi tidak menempel di kunjungan berikutnya.
  void reset() => state = const LoginIdle();

  /// Meminta OTP login untuk email terdaftar. API Soundtix passwordless:
  /// tidak ada password yang dikirim (lihat [LoginOtpChallenge]).
  Future<void> submit(String email) async {
    state = const LoginSubmitting();
    final challenge = LoginOtpChallenge(email: email);
    try {
      await ref.read(authRepositoryProvider).requestOtp(challenge);
      state = LoginSubmitted(challenge);
    } on ApiException catch (e) {
      state = LoginFailed(e.kind);
    }
  }
}

final loginControllerProvider =
    NotifierProvider<LoginController, LoginState>(LoginController.new);
