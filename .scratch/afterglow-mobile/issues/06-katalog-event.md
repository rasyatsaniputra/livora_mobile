# 06: Katalog event — daftar + cari + stats

**What to build:** Setelah login, halaman utama menampilkan daftar konser berposter (nama, tanggal, venue) dari Soundtix, dengan pencarian kata kunci dan filter, plus statistik event. State loading, error (server tak terjangkau), dan kosong tampil jelas.

**Blocked by:** 04 (Login + OTP + sesi persist + auto-refresh).

**Status:** ready-for-agent

- [ ] Daftar event berposter tampil dari API beserta statistik event
- [ ] Pencarian kata kunci memfilter hasil
- [ ] Filter daftar berfungsi
- [ ] Loading, error, dan empty state jelas
- [ ] Test parsing response & provider katalog lewat seam HTTP
