import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../data/auth_repository.dart';

/// Status layar verifikasi OTP.
sealed class OtpState {
  const OtpState();
}

final class OtpIdle extends OtpState {
  const OtpIdle();
}

final class OtpVerifying extends OtpState {
  const OtpVerifying();
}

final class OtpResending extends OtpState {
  const OtpResending();
}

/// Kode OTP baru terkirim (kirim ulang berhasil).
final class OtpResent extends OtpState {
  const OtpResent();
}

/// Verifikasi sukses — token sesi sudah tersimpan (terdaftar & terverifikasi).
final class OtpVerified extends OtpState {
  const OtpVerified();
}

final class OtpFailed extends OtpState {
  const OtpFailed(this.failure);

  final OtpFailure failure;
}

/// Penyebab kegagalan; diterjemahkan ke pesan l10n di layar.
sealed class OtpFailure {
  const OtpFailure();
}

/// Kode OTP salah atau kedaluwarsa.
final class OtpWrongCode extends OtpFailure {
  const OtpWrongCode();
}

/// Batas percobaan verifikasi tercapai (OpenAPI: maksimal 5 percobaan).
final class OtpTooManyAttempts extends OtpFailure {
  const OtpTooManyAttempts();
}

/// Kesalahan lain — pesan generik per [ApiExceptionKind].
final class OtpApiFailure extends OtpFailure {
  const OtpApiFailure(this.kind);

  final ApiExceptionKind kind;
}

class OtpVerificationController extends Notifier<OtpState> {
  @override
  OtpState build() => const OtpIdle();

  /// Membersihkan status percobaan sebelumnya; dipanggil saat layar
  /// verifikasi dibuat agar error basi tidak menempel di kunjungan berikutnya.
  void reset() => state = const OtpIdle();

  /// Memverifikasi kode OTP; sukses menyimpan token sesi lewat repository
  /// sehingga user berada dalam kondisi terdaftar & terverifikasi.
  Future<void> verify({
    required RegisterDraft draft,
    required String otp,
  }) async {
    state = const OtpVerifying();
    try {
      await ref
          .read(authRepositoryProvider)
          .verifyRegistration(draft, otp: otp);
      state = const OtpVerified();
    } on ApiException catch (e) {
      state = OtpFailed(_verifyFailureFor(e));
    } on Exception {
      // Bukan error HTTP — mis. secure storage gagal menyimpan token.
      // Tetap beri pesan agar layar tidak menggantung "Memverifikasi…"
      // (story 40).
      state = OtpFailed(const OtpApiFailure(ApiExceptionKind.request));
    }
  }

  /// Meminta ulang kode OTP ke email yang sama (story 5) — endpoint sama
  /// dengan permintaan awal di form register.
  Future<void> resend({required RegisterDraft draft}) async {
    state = const OtpResending();
    try {
      await ref.read(authRepositoryProvider).requestRegistrationOtp(draft);
      state = const OtpResent();
    } on ApiException catch (e) {
      // Tidak ada kode yang dinilai di sini — jangan pernah memakai pesan
      // "kode salah"; hanya batas percobaan yang punya pesan khusus.
      state = OtpFailed(
        e.statusCode == 429
            ? const OtpTooManyAttempts()
            : OtpApiFailure(e.kind),
      );
    } on Exception {
      state = OtpFailed(const OtpApiFailure(ApiExceptionKind.request));
    }
  }

  /// Backend tidak mendokumentasikan status untuk OTP salah/kedaluwarsa;
  /// 400/401/422 adalah konvensi penolakan kode, 429 batas percobaan,
  /// sisanya mengikuti [ApiExceptionKind]. Semua jadi pesan l10n yang jelas.
  OtpFailure _verifyFailureFor(ApiException e) {
    final status = e.statusCode;
    if (status == 429) return const OtpTooManyAttempts();
    const rejectedStatuses = {400, 401, 422};
    return status != null && rejectedStatuses.contains(status)
        ? const OtpWrongCode()
        : OtpApiFailure(e.kind);
  }
}

final otpVerificationControllerProvider =
    NotifierProvider<OtpVerificationController, OtpState>(
  OtpVerificationController.new,
);
