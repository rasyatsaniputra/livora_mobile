import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../data/auth_repository.dart';

/// Status alur register (form → OTP terkirim).
sealed class RegisterState {
  const RegisterState();
}

final class RegisterIdle extends RegisterState {
  const RegisterIdle();
}

final class RegisterSubmitting extends RegisterState {
  const RegisterSubmitting();
}

/// OTP pendaftaran terkirim — layar menavigasi ke verifikasi OTP.
final class RegisterSubmitted extends RegisterState {
  const RegisterSubmitted();
}

final class RegisterFailed extends RegisterState {
  const RegisterFailed(this.failure);

  final RegisterFailure failure;
}

/// Penyebab kegagalan register; diterjemahkan ke pesan l10n di layar.
sealed class RegisterFailure {
  const RegisterFailure();
}

/// Email sudah terdaftar di backend (409).
final class RegisterEmailTaken extends RegisterFailure {
  const RegisterEmailTaken();
}

/// Kesalahan lain — pesan generik per [ApiExceptionKind].
final class RegisterApiFailure extends RegisterFailure {
  const RegisterApiFailure(this.kind);

  final ApiExceptionKind kind;
}

class RegisterController extends Notifier<RegisterState> {
  @override
  RegisterState build() => const RegisterIdle();

  /// Membersihkan status percobaan sebelumnya; dipanggil saat layar register
  /// dibuat agar error basi tidak menempel di kunjungan berikutnya.
  void reset() => state = const RegisterIdle();

  /// Mengirim permintaan pendaftaran: backend membuat akun baru dan
  /// mengirimkan OTP ke email.
  Future<void> submit(RegisterDraft draft) async {
    state = const RegisterSubmitting();
    try {
      await ref.read(authRepositoryProvider).requestRegistrationOtp(draft);
      state = const RegisterSubmitted();
    } on ApiException catch (e) {
      // Backend tidak mendokumentasikan status khusus "email terdaftar";
      // 409 Conflict dipakai sebagai konvensi pesan tersebut (kriteria
      // tiket 03: email sudah terdaftar → pesan jelas).
      state = RegisterFailed(
        e.statusCode == 409
            ? const RegisterEmailTaken()
            : RegisterApiFailure(e.kind),
      );
    }
  }
}

final registerControllerProvider =
    NotifierProvider<RegisterController, RegisterState>(
  RegisterController.new,
);
