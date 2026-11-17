# 02: Seam HTTP boundary + pola test pertama

**What to build:** Sebagai prefactoring kualitas: seluruh trafik HTTP menuju Soundtix melewati satu boundary yang adapternya dapat ditukar di test dengan respons contoh dari spesifikasi API — tanpa backend yang hidup. Satu test pertama membuktikan pola: interseptor Bearer token dan auto-refresh (401 → refresh → retry) bekerja melalui adapter palsu. Pola ini menjadi contoh yang diikuti semua modul berikutnya; tidak ada mock per-layer lain.

**Blocked by:** 01 (Fondasi app shell + smoke health check).

**Status:** ready-for-agent

- [x] Semua request HTTP melewati satu boundary yang dapat ditukar di test
- [x] Test pembuktian: 401 → refresh token → retry sukses, memakai adapter palsu
- [x] Access & refresh token tersimpan di secure storage
- [x] Pola test (override provider + adapter palsu) terbentuk dan dipakai test pertama
- [x] Suite test hijau via `flutter test` tanpa jaringan sungguhan
