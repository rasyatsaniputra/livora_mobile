# Spec — Afterglow (Aplikasi Mobile Pemesanan Tiket Konser)

> Spec ini disusun dari hasil diskusi & interview grilling pada sesi perancangan.
> Backend **Soundtix API v1.0.0** sudah tersedia dan terdokumentasi (OpenAPI) di folder `docs/`.
> Status: **ready-for-agent**

---

## Problem Statement

Customer ingin membeli tiket konser secara digital, tetapi belum ada aplikasi mobile
yang menghubungkan mereka dengan platform Soundtix. Proses pembelian tiket konser
biasanya melibatkan antrean fisik atau transfer manual tanpa bukti transaksi yang rapi,
dan e-tiket harus ditukar secara manual di gerbang. Pengguna butuh satu aplikasi yang
membuat seluruh proses — menjelajah konser, memilih kategori tiket, membayar, dan
menunjukkan e-tiket ber-QR — terjadi di dalam satu genggaman.

## Solution

Sebuah aplikasi Flutter untuk Android bernama **Afterglow** — client resmi untuk
customer platform Soundtix. Aplikasi mencakup: autentikasi berbasis OTP, katalog
konser dengan bookmark, checkout dengan voucher, pembayaran (mock) dengan
sinkronisasi status, e-tiket ber-QR code yang bisa ditransfer, serta riwayat order
dan refund. Aplikasi mendukung tema light/dark dan bilingual (Indonesia default,
English opsional). Terbagi menjadi 7 modul yang dikerjakan berurutan:

1. Fondasi aplikasi (arsitektur, theme, network, i18n, router)
2. Autentikasi & profil
3. Katalog konser & bookmark
4. Checkout & voucher
5. Pembayaran
6. E-tiket
7. Riwayat order & refund

## User Stories

### Autentikasi & Profil

1. Sebagai customer, saya ingin mendaftar akun dengan email dan password, sehingga saya bisa mulai menggunakan aplikasi.
2. Sebagai customer, saya ingin memverifikasi pendaftaran lewat kode OTP yang dikirim ke email, sehingga akun terjamin milik email saya.
3. Sebagai customer, saya ingin login dengan email dan password, sehingga saya bisa mengakses fitur pemesanan tiket.
4. Sebagai customer, saya ingin memverifikasi login lewat OTP, sehingga akun saya terlindungi dari akses orang lain.
5. Sebagai customer, saya ingin meminta ulang kode OTP, sehingga saya tidak terkunci jika kode belum sampai atau kedaluwarsa.
6. Sebagai customer, saya ingin tetap dalam kondisi login saat membuka aplikasi lagi, sehingga saya tidak perlu login ulang setiap kali.
7. Sebagai customer, saya ingin melihat data profil saya (nama, email), sehingga saya tahu akun apa yang sedang aktif.
8. Sebagai customer, saya ingin mengubah data profil saya, sehingga informasi akun selalu akurat.
9. Sebagai customer, saya ingin logout, sehingga sesi saya berakhir di perangkat tersebut.
10. Sebagai customer, saya ingin access token diperbarui otomatis saat kedaluwarsa, sehingga saya tidak tiba-tiba ter-logout di tengah proses checkout.

### Katalog Konser & Bookmark

11. Sebagai customer, saya ingin melihat daftar konser beserta poster, nama, tanggal, dan venue, sehingga saya bisa menjelajah event yang tersedia.
12. Sebagai customer, saya ingin melihat statistik event (misal jumlah terjual), sehingga saya bisa menilai seberapa populer sebuah konser.
13. Sebagai customer, saya ingin melihat halaman detail event yang lengkap, sehingga saya bisa memutuskan apakah membeli tiket.
14. Sebagai customer, saya ingin melihat profil organizer penyelenggara, sehingga saya yakin event tersebut resmi.
15. Sebagai customer, saya ingin mencari event dengan kata kunci, sehingga saya cepat menemukan konser tertentu.
16. Sebagai customer, saya ingin memfilter daftar event, sehingga hasil yang tampil relevan dengan minat saya.
17. Sebagai customer, saya ingin bookmark (menyimpan) sebuah event, sehingga saya bisa kembali ke event yang diminati.
18. Sebagai customer, saya ingin melihat daftar bookmark saya, sehingga event favorit mudah diakses.
19. Sebagai customer, saya ingin menghapus bookmark, sehingga daftar favorit saya tetap bersih.

### Checkout & Voucher

20. Sebagai customer, saya ingin melihat kategori tiket per event (nama, harga, kuota tersisa), sehingga saya bisa memilih sesuai budget.
21. Sebagai customer, saya ingin memilih jumlah tiket per kategori, sehingga saya bisa membeli untuk lebih dari satu orang.
22. Sebagai customer, saya ingin memasukkan kode voucher dan melihat potongan harganya, sehingga saya bisa berhemat.
23. Sebagai customer, saya ingin melakukan checkout dan menerima kode order, sehingga pesanan saya tercatat resmi.
24. Sebagai customer, saya ingin melihat order aktif (belum dibayar) milik saya, sehingga saya tidak membuat pesanan ganda.
25. Sebagai customer, saya ingin membatalkan order sebelum dibayar, sehingga saya tidak terikat pesanan yang salah.

### Pembayaran

26. Sebagai customer, saya ingin menyelesaikan pembayaran (mock) langsung dari aplikasi, sehingga tiket saya terbit tanpa proses manual.
27. Sebagai customer, saya ingin melihat status pembayaran (pending/paid/failed) secara jelas, sehingga saya tahu kondisi transaksi saya.
28. Sebagai customer, saya ingin sinkronisasi ulang status pembayaran, sehingga status yang tampil selalu akurat.
29. Sebagai customer, saya ingin melihat kuitansi pembayaran, sehingga saya punya bukti transaksi.

### E-Tiket

30. Sebagai customer, saya ingin melihat daftar tiket yang saya miliki, sehingga semua tiket mudah diakses.
31. Sebagai customer, saya ingin melihat detail tiket lengkap dengan QR code, sehingga saya bisa menunjukkannya di gerbang konser.
32. Sebagai customer, saya ingin mentransfer tiket ke pengguna lain, sehingga saya bisa memberikan tiket ke teman yang akan datang.

### Riwayat Order & Refund

33. Sebagai customer, saya ingin melihat riwayat seluruh order saya, sehingga saya bisa menelusuri pembelian yang pernah saya buat.
34. Sebagai customer, saya ingin membuka detail order lama beserta kuitansinya, sehingga arsip transaksi saya lengkap.
35. Sebagai customer, saya ingin meminta pengiriman ulang e-tiket ke email, sehingga tiket tidak hilang.
36. Sebagai customer, saya ingin melihat status refund untuk event yang dibatalkan, sehingga saya tahu kapan uang saya kembali.

### Pengalaman Aplikasi (Fondasi)

37. Sebagai customer, saya ingin berpindah bahasa antara Indonesia dan English, sehingga aplikasi nyaman saya gunakan.
38. Sebagai customer, saya ingin aplikasi mengikuti tema light/dark dari setting perangkat, sehingga nyaman dilihat kapan pun.
39. Sebagai customer, saya ingin melihat splash screen dengan branding Afterglow, sehingga aplikasi terasa profesional.
40. Sebagai customer, saya ingin melihat pesan error yang jelas ketika server gagal atau tidak terjangkau, sehingga saya tahu apa yang harus dilakukan.
41. Sebagai customer, saya ingin indikator loading saat data diambil, sehingga aplikasi tidak terasa "menggantung".

## Implementation Decisions

### Stack & Arsitektur

- **Flutter (Android saja)** — target preview/demo adalah Android emulator; effort iOS tidak dikeluarkan.
- **Riverpod** sebagai state management — seluruh modul memakai pola provider yang sama.
- **go_router** untuk navigasi — alur dalam (login → katalog → detail → checkout → pembayaran → e-tiket) dikelola secara declarative dengan shell untuk bottom navigation.
- **dio** sebagai HTTP client, dengan **interceptor Bearer token** dan **auto-refresh** saat access token kedaluwarsa (401 → refresh → retry).
- **Arsitektur feature-first**: satu folder per fitur (`auth`, `catalog`, `checkout`, `payment`, `e_ticket`, `history`) berisi data & UI masing-masing; kode lintas-fitur (network, theme, config, router, i18n) berada di layer core.
- **Codegen model**: `freezed` + `json_serializable` untuk parsing JSON; model dibuat per-modul saat modul dikerjakan, bukan sekaligus di awal.

### Fondasi (Modul 1)

- **Base URL API dikonfigurasi di satu tempat** dengan nilai default `10.0.2.2` (alias localhost dari Android emulator), mudah ditukar saat backend di-deploy.
- **Token disimpan di flutter_secure_storage** (terenkripsi), bukan shared_preferences.
- **Tema light + dark**: semua warna wajib diambil dari `Theme.of(context)`; palet placeholder terpusat di satu konstanta tema dan nanti ditukar dengan color scheme final dari user tanpa refactor.
- **i18n**: Indonesia sebagai default, English sebagai pilihan manual via toggle; memakai `intl` + file `.arb`. Semua teks UI wajib lewat key, dilarang literal string.
- **Branding**: nama aplikasi "Afterglow"; logo dan launcher icon berupa placeholder yang dibuat otomatis, mudah diganti.
- **Smoke test fondasi**: satu halaman tes yang memanggil endpoint health Soundtix untuk memastikan konektivitas dari emulator.

### Kontrak API (Soundtix)

- Autentikasi: register + verifikasi OTP, login + verifikasi OTP, request-OTP, refresh, logout, profil (`/users/me` GET/PATCH).
- Katalog: daftar event + stats, detail event, detail organizer, bookmark/unbookmark, daftar bookmark.
- Checkout: kategori tiket per event, validasi voucher, checkout order, order aktif, pembatalan order.
- Pembayaran: mock-pay, sinkronisasi status, kuitansi.
- E-tiket: daftar tiket, detail tiket (basis QR code), transfer kepemilikan tiket.
- Riwayat: daftar order, detail order, kuitansi order, resend e-tiket, daftar refund, pembatalan event.

Detail kontrak lengkap mengikuti spesifikasi OpenAPI Soundtix yang ada di `docs/`.

### Prioritas Ketika Waktu Mepet

Jika timeline (1–2 minggu) menipis di akhir, **kelengkapan 7 modul fitur diutamakan
di atas polish tema/animasi**. Tema light+dark dan bilingual tetap disiplinkan sejak
awal karena murah kalau disiplin, mahal kalau ditunda.

## Testing Decisions

### Karakteristik test yang baik

- Test hanya menguji **perilaku dari luar** (hasil yang terlihat user / kontrak provider), bukan detail implementasi internal (misal struktur internal repository).
- Tidak memanggil jaringan sungguhan dan tidak bergantung pada backend yang hidup.

### Seam utama (satu-satunya seam baru)

- **Seam berada di boundary HTTP**: dio dibungkus sehingga `HttpClientAdapter` bisa
  ditukar dengan adapter palsu yang mengembalikan respons contoh dari spesifikasi API.
  Dengan satu seam ini, semua test berjalan "setinggi mungkin": repository, interceptor
  refresh-token, provider Riverpod, dan widget ikut ter-exercise tanpa mock per-layer.
- Tidak ada seam lain yang direncanakan (tidak mock per-provider, tidak mock per-repository).
- Test dijalankan melalui override provider Riverpod + widget test untuk alur kunci.

### Cakupan test (minimal, sesuai timeline)

- **API client**: parsing response, interceptor refresh token, penanganan error HTTP.
- **Logika krusial**: validasi voucher dan perhitungan checkout (potongan harga, total).
- Sisanya diuji manual di emulator; backend punya kredensial uji (customer uji tersedia dari seed database Soundtix).

### Prior art

- Belum ada test yang ada di codebase (proyek masih template) — pola test pertama yang
  dibuat di modul fondasi akan menjadi pola yang diikuti modul-modul berikutnya.

## Out of Scope

- **Role Admin, Organizer, dan Crew Gate** (dashboard, payout, verifikasi event, scan gerbang) — backend sudah menyediakan endpoint-nya, tetapi untuk aplikasi terpisah; aplikasi ini murni client customer.
- **Payment gateway nyata** (Xendit via WebView/hosted checkout) — pembayaran memakai flow mock-pay yang disediakan backend; webhook dan settlement berada di sisi backend.
- **Push notification** (FCM) — pengingat dan resend e-tiket cukup via in-app + email dari backend.
- **Rilis ke Play Store / CI/CD** — targetnya demo di emulator.
- **Dukungan iOS** — tidak diuji di iOS untuk fase ini.
- **Coverage test menyeluruh** (unit + widget untuk semua modul) — hanya cakupan minimal sesuai keputusan timeline.

## Further Notes

- **Color scheme final** belum ditentukan — user akan menyediakannya; untuk itu palet
  placeholder sengaja terpusat di satu titik agar penukaran tidak menyentuh kode lain.
- **Logo & launcher icon** berupa placeholder buatan, akan diganti bila user punya aset final.
- **Backend di-deploy nanti**: cukup ubah base URL di satu tempat konfigurasi; tidak ada
  perubahan kode lain yang dibutuhkan.
- Proyek ini untuk **UKK Kelas 12**; spesifikasi backend menyebut `bun run db:seed`
  menghasilkan akun uji (customer: `buyer@soundtix.id`) yang bisa dipakai untuk demo.
- Pembagian kerja mengikuti 7 modul dengan urutan pengerjaan: fondasi → auth → katalog
  → checkout → pembayaran → e-tiket → riwayat, karena setiap modul bergantung pada
  modul sebelumnya.
- Modul 1–3 saja sudah layak demo (login + katalog); modul 4–6 adalah inti pemesanan;
  modul 7 pelengkap.
