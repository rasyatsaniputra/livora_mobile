import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/presentation/error_message.dart';
import '../../../core/presentation/validators.dart';
import '../../../core/router/app_routes.dart';
import 'login_controller.dart';

/// Layar login (story 3–4). API Soundtix passwordless (lihat
/// `auth_repository.dart`): pengguna memasukkan email, menerima OTP, lalu
/// memverifikasinya di layar berikutnya — tidak ada field password.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Controller app-scoped: bersihkan status percobaan sebelumnya supaya
    // error basi tidak tampil saat layar dibuka lagi. Ditunda ke frame
    // berikutnya — Riverpod melarang mengubah provider saat initState.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(loginControllerProvider.notifier).reset();
    });
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(loginControllerProvider.notifier).submit(_email.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final state = ref.watch(loginControllerProvider);
    final submitting = state is LoginSubmitting;

    // OTP terkirim → buka layar verifikasi membawa email (push agar user
    // masih bisa kembali memperbaiki email bila perlu).
    ref.listen<LoginState>(loginControllerProvider, (previous, next) {
      if (next is LoginSubmitted) {
        context.push(AppRoutes.loginVerify, extra: next.challenge);
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(l10n.loginTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.loginSubtitle,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  labelText: l10n.loginEmailLabel,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) =>
                    validateEmail(value, l10n.loginEmailInvalid),
              ),
              const SizedBox(height: 16),
              FilledButton(
                // Loading dilarang ganda-klik (story 41).
                onPressed: submitting ? null : _submit,
                child: Text(
                  submitting ? l10n.loginSubmitting : l10n.loginSubmit,
                ),
              ),
              if (state is LoginFailed)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: ErrorMessage(apiErrorText(state.kind, l10n)),
                ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l10n.loginRegisterPrompt),
                  TextButton(
                    onPressed: () => context.push(AppRoutes.register),
                    child: Text(l10n.loginRegisterAction),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
