# 01: Fondasi app shell + smoke health check

**What to build:** Aplikasi **Afterglow** dapat dijalankan di Android emulator dan menampilkan splash screen berbranding, skeleton navigasi, tema light+dark (mengikuti setting sistem) dengan palet placeholder yang terpusat di satu titik, teks UI lewat key i18n (Indonesia default), serta satu halaman smoke yang memanggil endpoint health Soundtix dan menampilkan status konektivitas. Base URL API dikonfigurasi di satu tempat (default `10.0.2.2` untuk emulator). Struktur folder feature-first untuk 7 fitur siap pakai.

**Blocked by:** None (can start immediately).

**Status:** ready-for-agent

- [x] App jalan di emulator; splash Afterglow tampil lalu masuk skeleton navigasi
- [x] Tema light & dark keduanya tampil benar mengikuti setting sistem; tidak ada warna hardcode di luar titik tema
- [x] Teks UI lewat key i18n (ID default), tidak ada literal string di alur awal
- [x] Halaman smoke memanggil health Soundtix dan menampilkan hasil OK / pesan error yang jelas
- [x] Base URL dapat diganti di satu tempat konfigurasi tanpa menyentuh kode lain
- [x] Logo & launcher icon placeholder terpasang
- [x] Struktur folder feature-first untuk 7 modul (auth, catalog, checkout, payment, e-ticket, history, core) tersedia
