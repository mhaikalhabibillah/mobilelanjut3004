import 'package:flutter/material.dart';

class BillingResultScreen extends StatelessWidget {
  final String kodePelanggan;
  final String namaPelanggan;
  final String jenisPelanggan;
  final double lama;
  final String tglMasuk; // Menyimpan tanggal masuk yang dipilih
  final double tarifPerJam = 10000;

  BillingResultScreen({
    required this.kodePelanggan,
    required this.namaPelanggan,
    required this.jenisPelanggan,
    required this.lama,
    required this.tglMasuk, // Menambahkan parameter tanggal masuk
  });

  @override
  Widget build(BuildContext context) {
    double tarif = lama * tarifPerJam;
    double diskon = 0;

    // Logika diskon
    if (jenisPelanggan == 'VIP' && lama > 2) {
      diskon = tarif * 0.02;
    } else if (jenisPelanggan == 'GOLD' && lama > 2) {
      diskon = tarif * 0.05;
    }

    double totalBayar = tarif - diskon;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hasil Perhitungan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kode Pelanggan: $kodePelanggan'),
            Text('Nama Pelanggan: $namaPelanggan'),
            Text('Jenis Pelanggan: $jenisPelanggan'),
            Text('Tanggal Masuk: $tglMasuk'), // Menampilkan tanggal masuk
            Text('Durasi: $lama jam'),
            SizedBox(height: 20),
            Text('Total Bayar: Rp$totalBayar', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Kembali ke halaman sebelumnya
                Navigator.pop(context);
              },
              child: Text('Kembali ke Halaman Entri'),
            ),
          ],
        ),
      ),
    );
  }
}
