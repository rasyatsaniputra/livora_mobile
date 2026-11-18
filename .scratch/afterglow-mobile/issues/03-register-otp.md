# 03: Register + verifikasi OTP

**What to build:** Orang yang belum punya akun bisa mendaftar dari aplikasi: mengisi email dan password, menerima kode OTP, memasukkannya di layar verifikasi, dan akunnya terverifikasi. Kirim ulang OTP tersedia. Kesalahan (kode salah/kedaluwarsa, email sudah terdaftar) menghasilkan pesan yang jelas.

**Blocked by:** 01 (Fondasi app shell), 02 (Seam HTTP boundary).

**Status:** ready-for-agent

- [x] Form register dengan validasi input
- [x] Layar verifikasi OTP terbuka setelah register
- [x] Kirim ulang OTP berfungsi
- [x] Verifikasi sukses membawa user ke kondisi terdaftar/terverifikasi
- [x] Pesan error jelas untuk kode salah/kedaluwarsa dan email terdaftar
- [x] Test alur register sukses & gagal verifikasi lewat seam HTTP
