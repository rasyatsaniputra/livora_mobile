# Design Tree — Bagian 1: Fondasi Aplikasi (Afterglow)

> Rekonstruksi interview grilling Bagian 1 ke format design tree (skill `grilling`).
> Sumber: 3 ronde interview pada sesi perancangan + spesifikasi `docs/spec-afterglow-mobile.md`.
> Status: **frontier kosong** — semua cabang telah dikunjungi, tidak ada yang diasumsikan diam-diam.

```
Root: Fondasi aplikasi Afterglow (client customer Soundtix)
│
├── [R1] State management ── Riverpod
│   └── [turunan] Pola provider tunggal untuk semua 7 modul; model state per fitur.
│
├── [R1] Routing ── go_router
│   └── [turunan] Alur dalam (login→katalog→detail→checkout→bayar→e-tiket)
│       dikelola declarative + shell untuk bottom nav.
│
├── [R1] HTTP client ── dio
│   ├── [turunan] Interseptor Bearer + auto-refresh saat 401 (→ tiket 02: seam HTTP)
│   └── [R2] Base URL backend ── emulator 10.0.2.2
│       └── [turunan] Base URL di SATU tempat konfigurasi; ganti saat deploy.
│           ⏳ Fakta tertunda: URL publik backend bila nanti di-deploy.
│
├── [R1] Arsitektur folder ── feature-first
│   └── [turunan] lib/features/{auth,catalog,checkout,payment,e_ticket,history}
│       + lib/core/ (network, theme, config, router, l10n).
│
├── [R1] Target platform ── Android saja
│   └── [turunan] Demo via Android emulator; effort iOS tidak dikeluarkan.
│
├── [R1] Timeline ── 1–2 minggu
│   └── [R3] Prioritas saat mepet ── fitur 7 bagian > polish tema
│       └── [turunan] Disiplin tema & i18n tetap sejak awal (murah bila disiplin).
│
├── [R2] Simpan token ── flutter_secure_storage
│   └── [turunan] Access + refresh token terenkripsi; bukan shared_preferences.
│
├── [R2] Parsing JSON ── codegen (freezed + json_serializable)
│   └── [turunan] Model dibuat per-modul saat modul dikerjakan, bukan sekaligus.
│
├── [R2] Tema ── light + dark
│   └── [turunan] Semua warna via Theme.of(context); dilarang hardcode.
│       └── [R3] Color scheme ── placeholder dulu di satu titik
│           ⏳ Fakta tertunda: palet final dari user → tinggal menukar satu file.
│
├── [R2] Testing ── minimal
│   └── [turunan] Unit test hanya API client + logika krusial (voucher, checkout);
│       sisanya manual; pola test dari seam HTTP (tiket 02).
│
├── [R2] Bahasa ── keduanya, bisa berganti
│   └── [R3] Default & pilihan ── ID default + EN via toggle manual
│       └── [turunan] intl + file .arb; semua teks UI lewat key.
│           (Pilihan "EN default + ID" dan "ikut locale sistem" ditolak.)
│
├── [R2] Nama aplikasi ── Afterglow
│   └── [R3] Logo & icon ── placeholder dibuat otomatis
│       ⏳ Fakta tertunda: aset logo final dari user (jika ada).
│
└── [R1] Desain UI ── bebas, tapi color scheme dari user
    └── → bercabang ke node "Tema" di atas.
```

**Legenda:**
- `[R1] [R2] [R3]` = ronde interview saat keputusan diambil.
- `[turunan]` = keputusan yang menggantung langsung dari keputusan induknya (tidak perlu ditanya terpisah).
- ⏳ **Fakta tertunda** = bukan keputusan terbuka, melainkan input dari user/environment yang tinggal dipasang; pemuasannya sudah disiapkan (satu titik konfigurasi/penggantian).

## Fakta tertunda yang menggantung (3)

| # | Fakta | Dipasang di mana | Kapan |
|---|---|---|---|
| 1 | Color scheme final | Satu titik konstanta tema | Kapan pun sebelum polish |
| 2 | Logo/aset final (jika ada) | Launcher icon & splash | Kapan pun |
| 3 | URL backend publik bila di-deploy | Satu titik konfigurasi base URL | Saat backend di-hosting |

## Kesimpulan

- Interview Bagian 1 valid terhadap proses skill `grilling`: semua keputusan sudah
  dimiliki user (bukan diasumsikan), dan tiap ronde hanya bertanya yang prasyaratnya
  sudah lunas.
- **Frontier Bagian 1 kosong** — bersedia lanjut ke implementasi tiket 01.
- Bagian 2–7 akan di-grill ulang dengan proses ini sesaat sebelum tiket terkait dimulai
  (lihat pemetaan tiket ↔ bagian di percakapan).
