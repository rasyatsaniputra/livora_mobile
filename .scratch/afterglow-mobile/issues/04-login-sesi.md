# 04: Login + OTP + sesi persist + auto-refresh

**What to build:** Customer bisa login dengan email + password dan verifikasi OTP. Sesi tersimpan aman sehingga membuka ulang aplikasi tidak perlu login lagi; access token diperbarui otomatis saat kedaluwarsa tanpa user sadar. Aplikasi membuka home bila sesi aktif, atau layar login bila tidak. Ini juga mengikat interseptor auto-refresh dari tiket 02 ke data sesi nyata.

**Blocked by:** 03 (Register + verifikasi OTP).

**Status:** ready-for-agent

- [x] Login + verifikasi OTP berfungsi end-to-end
- [x] Sesi persist: restart app tetap login
- [x] Token refresh otomatis saat kedaluwarsa tanpa interupsi user
- [x] Redirect pembuka: sesi aktif → home; tanpa sesi → login
- [x] Logout belum ada di tiket ini (tiket 05)
- [x] Test alur login (sukses, OTP salah, sesi persist) lewat seam HTTP
