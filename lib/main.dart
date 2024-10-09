import 'package:flutter/material.dart';
import 'entry.dart'; // Import halaman entri

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Penghitungan Biaya Warnet',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BillingEntryScreen(), // Tampilkan halaman entri sebagai halaman utama
    );
  }
}
