# 12: Transfer tiket

**What to build:** Dari detail tiket, customer dapat mentransfer tiket ke pengguna lain. Setelah transfer sukses, tiket hilang dari daftar pemberi dan muncul di penerima. Kesalahan (target tidak valid) menampilkan pesan yang jelas.

**Blocked by:** 11 (E-tiket — daftar + QR code).

**Status:** ready-for-agent

- [ ] Form transfer tiket dengan input tujuan
- [ ] Transfer sukses memindahkan kepemilikan tiket
- [ ] Tiket hilang dari daftar pemberi setelah transfer
- [ ] Pesan error jelas untuk target tidak valid
- [ ] Test alur transfer (sukses & gagal) lewat seam HTTP
