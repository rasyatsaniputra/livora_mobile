import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/presentation/error_message.dart';
import '../../../core/presentation/validators.dart';
import '../../../core/router/app_routes.dart';
import '../data/auth_repository.dart';
import 'register_controller.dart';

/// Layar pendaftaran (story 1). API Soundtix passwordless (lihat
/// `auth_repository.dart`): cukup email + nama, OTP dikirim ke email untuk
/// diverifikasi di layar berikutnya — tidak ada field password.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Controller app-scoped: bersihkan status percobaan sebelumnya supaya
    // error basi tidak tampil saat layar dibuka lagi. Ditunda ke frame
    // berikutnya — Riverpod melarang mengubah provider saat initState.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(registerControllerProvider.notifier).reset();
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().length < 3) {
      return AppLocalizations.of(context)!.registerNameInvalid;
    }
    return null;
  }

  /// Data pendaftaran dari isian form.
  RegistrationOtpChallenge get _challenge => RegistrationOtpChallenge(
        email: _email.text.trim(),
        username: _name.text.trim(),
      );

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(registerControllerProvider.notifier).submit(_challenge);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final state = ref.watch(registerControllerProvider);
    final submitting = state is RegisterSubmitting;

    // OTP terkirim → buka layar verifikasi membawa email & nama (push agar
    // user masih bisa kembali memperbaiki email bila perlu).
    ref.listen<RegisterState>(registerControllerProvider, (previous, next) {
      if (next is RegisterSubmitted) {
        context.push(AppRoutes.registerVerify, extra: _challenge);
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(l10n.registerTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.registerSubtitle,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _name,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: l10n.registerNameLabel,
                  border: const OutlineInputBorder(),
                ),
                validator: _validateName,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: l10n.registerEmailLabel,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) =>
                    validateEmail(value, l10n.registerEmailInvalid),
              ),
              const SizedBox(height: 16),
              FilledButton(
                // Loading dilarang ganda-klik (story 41).
                onPressed: submitting ? null : _submit,
                child: Text(
                  submitting ? l10n.registerSubmitting : l10n.registerSubmit,
                ),
              ),
              // Pesan kegagalan yang jelas (kriteria tiket 03): email sudah
              // terdaftar / error lain dari kind ApiException.
              if (state is RegisterFailed)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: ErrorMessage(_failureText(state.failure, l10n)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _failureText(RegisterFailure failure, AppLocalizations l10n) =>
      switch (failure) {
        RegisterEmailTaken() => l10n.errorEmailRegistered,
        RegisterApiFailure(:final kind) => apiErrorText(kind, l10n),
      };
}
