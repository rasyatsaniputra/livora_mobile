# 09: Checkout + voucher

**What to build:** Dari detail event, customer memilih jumlah tiket per kategori, dapat memasukkan kode voucher (diskon tampil bila valid, ditolak dengan alasan bila tidak), lalu checkout menghasilkan kode order dengan ringkasan total. Perhitungan harga (subtotal − potongan = total) diuji unit test.

**Blocked by:** 07 (Detail event + profil organizer).

**Status:** ready-for-agent

- [ ] Pilih jumlah tiket per kategori dengan validasi kuota
- [ ] Validasi voucher: diskon tampil bila valid; pesan alasan bila ditolak
- [ ] Checkout sukses menghasilkan kode order & layar ringkasan
- [ ] Unit test perhitungan potongan & total
- [ ] Error state: kuota habis, voucher invalid, server gagal
