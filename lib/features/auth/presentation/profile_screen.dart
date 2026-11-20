import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/presentation/error_message.dart';
import '../../../core/presentation/validators.dart';
import '../../../core/router/app_routes.dart';
import '../data/user_profile.dart';
import 'profile_controller.dart';

/// Tab Profil (tiket 05): menampilkan nama, email, dan nomor HP customer
/// dari `GET /users/me`, mengubah nama/nomor HP lewat `PATCH /users/me`,
/// serta logout yang membersihkan sesi lalu kembali ke layar login.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();

  var _editing = false;
  var _saving = false;
  var _signingOut = false;
  ApiExceptionKind? _saveError;

  @override
  void initState() {
    super.initState();
    // Muat profil saat tab dibuka. Ditunda ke frame berikutnya — Riverpod
    // melarang mengubah provider saat initState.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(profileControllerProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _startEditing(UserProfile profile) {
    _name.text = profile.username;
    _phone.text = profile.noHp ?? '';
    setState(() {
      _editing = true;
      _saveError = null;
    });
  }

  void _cancelEditing() {
    setState(() {
      _editing = false;
      _saveError = null;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _saveError = null;
    });
    final kind = await ref
        .read(profileControllerProvider.notifier)
        .save(
          username: _name.text.trim(),
          noHp: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
        );
    if (!mounted) return;
    setState(() {
      _saving = false;
      _saveError = kind;
      _editing = kind != null;
    });
    if (kind == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.profileSaved)),
      );
    }
  }

  Future<void> _logout() async {
    setState(() => _signingOut = true);
    await ref.read(profileControllerProvider.notifier).logout();
    if (!mounted) return;
    // Sesi sudah dibersihkan: keluar dari shell dan kembali ke login.
    context.go(AppRoutes.login);
  }

  String? _validateName(String? value) {
    final l10n = AppLocalizations.of(context)!;
    final name = value?.trim() ?? '';
    if (name.length < 3) return l10n.profileNameInvalid;
    if (name.length > 50) return l10n.profileNameTooLong;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(profileControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navProfile)),
      body: switch (state) {
        ProfileLoading() => const Center(child: CircularProgressIndicator()),
        ProfileFailed(:final kind) => Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ErrorMessage(apiErrorText(kind, l10n)),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () =>
                      ref.read(profileControllerProvider.notifier).load(),
                  child: Text(l10n.profileRetry),
                ),
              ],
            ),
          ),
        ),
        ProfileReady(:final profile) => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            if (_editing)
              _EditForm(
                formKey: _formKey,
                name: _name,
                phone: _phone,
                email: profile.email,
                saving: _saving,
                saveError: _saveError,
                onSave: _save,
                onCancel: _cancelEditing,
                nameValidator: _validateName,
                phoneValidator: (value) =>
                    validatePhone(value, l10n.profilePhoneInvalid),
              )
            else ...[
              _ProfileDetails(profile: profile),
              const SizedBox(height: 24),
              FilledButton.tonal(
                onPressed: _signingOut ? null : () => _startEditing(profile),
                child: Text(l10n.profileEdit),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _signingOut ? null : _logout,
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                ),
                child: Text(
                  _signingOut ? l10n.profileLoggingOut : l10n.profileLogout,
                ),
              ),
            ],
          ],
        ),
      },
    );
  }
}

/// Data profil mode baca: nama, email (tidak dapat diubah lewat API), dan
/// nomor HP.
class _ProfileDetails extends StatelessWidget {
  const _ProfileDetails({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CircleAvatar(
          radius: 32,
          child: profile.username.isEmpty
              ? const Icon(Icons.person)
              : Text(
                  profile.username.characters.first.toUpperCase(),
                  style: theme.textTheme.headlineMedium,
                ),
        ),
        const SizedBox(height: 16),
        Text(
          profile.username,
          style: theme.textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        _DetailRow(
          icon: Icons.email_outlined,
          label: l10n.profileEmailLabel,
          value: profile.email,
        ),
        _DetailRow(
          icon: Icons.phone_outlined,
          label: l10n.profilePhoneLabel,
          value: profile.noHp?.isNotEmpty == true
              ? profile.noHp!
              : l10n.profilePhoneEmpty,
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(label),
      subtitle: Text(value),
    );
  }
}

/// Form edit nama & nomor HP. Email ditampilkan tetapi tidak dapat diubah
/// (PATCH /users/me hanya menerima username dan no_hp).
class _EditForm extends StatelessWidget {
  const _EditForm({
    required this.formKey,
    required this.name,
    required this.phone,
    required this.email,
    required this.saving,
    required this.saveError,
    required this.onSave,
    required this.onCancel,
    required this.nameValidator,
    required this.phoneValidator,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController name;
  final TextEditingController phone;
  final String email;
  final bool saving;
  final ApiExceptionKind? saveError;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final FormFieldValidator<String> nameValidator;
  final FormFieldValidator<String> phoneValidator;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            key: const Key('profileNameField'),
            controller: name,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: l10n.profileNameLabel,
              border: const OutlineInputBorder(),
            ),
            validator: nameValidator,
          ),
          const SizedBox(height: 12),
          TextFormField(
            // Email hanya informasi — kontrak API tidak menerima perubahan.
            initialValue: email,
            enabled: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: l10n.profileEmailLabel,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            key: const Key('profilePhoneField'),
            controller: phone,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              // Aturan karakter sama dengan validator nomor HP.
              FilteringTextInputFormatter.allow(phoneAllowedCharacters),
            ],
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: l10n.profilePhoneLabel,
              border: const OutlineInputBorder(),
            ),
            validator: phoneValidator,
          ),
          const SizedBox(height: 16),
          if (saveError != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ErrorMessage(apiErrorText(saveError!, l10n)),
            ),
          FilledButton(
            onPressed: saving ? null : onSave,
            child: Text(saving ? l10n.profileSaving : l10n.profileSave),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: saving ? null : onCancel,
            child: Text(l10n.profileCancel),
          ),
        ],
      ),
    );
  }
}
