# 10: Order aktif + bayar (mock) + batal

**What to build:** Customer melihat order aktif (belum dibayar) miliknya: detail item dan total. Tombol bayar memicu pembayaran mock dari aplikasi; status pembayaran tersinkron (refresh manual/polling) sampai paid, lalu kuitansi dapat dibuka. Order yang belum dibayar dapat dibatalkan.

**Blocked by:** 09 (Checkout + voucher).

**Status:** ready-for-agent

- [ ] Layar order aktif menampilkan detail & total dari endpoint order aktif
- [ ] Bayar mock mengubah status menjadi paid
- [ ] Sinkronisasi status (manual refresh atau polling) berfungsi
- [ ] Kuitansi dapat dibuka setelah paid
- [ ] Pembatalan order sebelum bayar berfungsi
- [ ] Test alur bayar & batal lewat seam HTTP
