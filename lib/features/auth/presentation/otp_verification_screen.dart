import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/presentation/error_message.dart';
import '../../../core/router/app_routes.dart';
import '../data/auth_repository.dart';
import 'otp_verification_controller.dart';

/// Layar verifikasi OTP bersama untuk registrasi (tiket 03) dan login
/// (tiket 04): user memasukkan kode 6 digit yang dikirim ke email. Alur
/// dibedakan lewat [OtpChallenge] yang dibawa sebagai argumen route.
/// Kirim ulang OTP tersedia (story 5).
class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final _otp = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Controller app-scoped: bersihkan status percobaan sebelumnya supaya
    // error basi tidak menempel saat layar dibuka lagi. Ditunda ke frame
    // berikutnya — Riverpod melarang mengubah provider saat initState.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(otpVerificationControllerProvider.notifier).reset();
    });
  }

  @override
  void dispose() {
    _otp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final args = GoRouterState.of(context).extra;

    // Route ini hanya sah bila dibuka dari alur register/login (challenge
    // terbawa). Masuk langsung lewat URL menampilkan pesan jelas, bukan crash.
    if (args is! OtpChallenge) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.otpTitle)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              l10n.otpMissingDraft,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final state = ref.watch(otpVerificationControllerProvider);

    // Sukses → sesi tersimpan; masuk home sementara (Katalog).
    ref.listen<OtpState>(otpVerificationControllerProvider, (previous, next) {
      if (next is OtpVerified) {
        context.go(AppRoutes.catalog);
      } else if (next is OtpResent) {
        // Konfirmasi kirim ulang tanpa memindahkan fokus dari field OTP.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.otpResent(args.email))),
        );
      }
    });

    final busy = state is OtpVerifying || state is OtpResending;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.otpTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.otpSentTo(args.email),
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _otp,
              keyboardType: TextInputType.number,
              maxLength: 6,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: l10n.otpFieldLabel,
                border: const OutlineInputBorder(),
                counterText: '',
              ),
            ),
            const SizedBox(height: 16),
            if (state is OtpFailed)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ErrorMessage(_failureText(state.failure, l10n)),
              ),
            FilledButton(
              // Hanya 6 digit yang bisa dikirim; loading dilarang ganda-klik.
              onPressed: busy || _otp.text.length != 6
                  ? null
                  : () => ref
                      .read(otpVerificationControllerProvider.notifier)
                      .verify(challenge: args, otp: _otp.text),
              child: Text(busy ? l10n.otpVerifying : l10n.otpVerify),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: busy
                  ? null
                  : () => ref
                      .read(otpVerificationControllerProvider.notifier)
                      .resend(challenge: args),
              child: Text(
                state is OtpResending ? l10n.otpResending : l10n.otpResend,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _failureText(OtpFailure failure, AppLocalizations l10n) =>
      switch (failure) {
        OtpWrongCode() => l10n.otpWrongCode,
        OtpTooManyAttempts() => l10n.otpTooManyAttempts,
        OtpApiFailure(:final kind) => apiErrorText(kind, l10n),
      };
}
