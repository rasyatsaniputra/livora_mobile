import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/session_controller.dart';
import '../../../core/network/api_exception.dart';
import '../data/auth_repository.dart';
import '../data/profile_repository.dart';
import '../data/user_profile.dart';

/// Status layar profil.
sealed class ProfileState {
  const ProfileState();
}

final class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

final class ProfileReady extends ProfileState {
  const ProfileReady(this.profile);

  final UserProfile profile;
}

/// Profil gagal dimuat — layar menampilkan pesan per [ApiExceptionKind]
/// beserta tombol coba lagi (story 40–41).
final class ProfileFailed extends ProfileState {
  const ProfileFailed(this.kind);

  final ApiExceptionKind kind;
}

class ProfileController extends Notifier<ProfileState> {
  @override
  ProfileState build() => const ProfileLoading();

  /// Memuat profil dari server — dipanggil saat layar profil dibuka dan
  /// oleh tombol "coba lagi".
  Future<void> load() async {
    state = const ProfileLoading();
    await _fetch();
  }

  /// Menyimpan perubahan profil lalu mengganti state dengan data hasil
  /// baca ulang dari server. Mengembalikan [ApiExceptionKind] bila gagal
  /// (layar menampilkan pesan tanpa membuang data lama), atau null bila
  /// berhasil.
  Future<ApiExceptionKind?> save({
    required String username,
    String? noHp,
  }) async {
    try {
      final profile = await ref
          .read(profileRepositoryProvider)
          .updateProfile(username: username, noHp: noHp);
      if (!ref.mounted) return null;
      state = ProfileReady(profile);
      return null;
    } on ApiException catch (e) {
      return e.kind;
    } on Exception {
      return ApiExceptionKind.request;
    }
  }

  /// Logout: cabut sesi di server (best-effort), hapus token lokal, lalu
  /// tandai sesi aplikasi berakhir. State dikosongkan supaya login
  /// berikutnya tidak sempat menampilkan profil pengguna sebelumnya.
  ///
  /// `finally` memastikan tombol keluar tidak pernah menggantung: apa pun
  /// yang gagal di sisi server/storage, sesi aplikasi tetap diakhiri dan
  /// layar dapat kembali ke login.
  Future<void> logout() async {
    try {
      await ref.read(authRepositoryProvider).logout();
    } on Object {
      // Sesi lokal sudah diusahakan dibersihkan oleh repository; jangan
      // menahan user di layar profil karena kegagalan tersebut.
    } finally {
      await ref.read(sessionControllerProvider.notifier).markSignedOut();
      if (ref.mounted) state = const ProfileLoading();
    }
  }

  Future<void> _fetch() async {
    try {
      final profile = await ref.read(profileRepositoryProvider).fetchProfile();
      if (!ref.mounted) return;
      state = ProfileReady(profile);
    } on ApiException catch (e) {
      if (!ref.mounted) return;
      state = ProfileFailed(e.kind);
    } on Exception {
      // Bukan error HTTP (mis. bentuk respons aneh): tetap beri pesan agar
      // layar tidak menggantung di spinner (story 40).
      if (!ref.mounted) return;
      state = const ProfileFailed(ApiExceptionKind.request);
    }
  }
}

final profileControllerProvider =
    NotifierProvider<ProfileController, ProfileState>(ProfileController.new);
