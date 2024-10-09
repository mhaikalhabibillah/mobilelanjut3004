import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Package untuk format tanggal
import 'hasil.dart'; // Import halaman hasil

class BillingEntryScreen extends StatefulWidget {
  @override
  _BillingEntryScreenState createState() => _BillingEntryScreenState();
}

class _BillingEntryScreenState extends State<BillingEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _kodePelangganController = TextEditingController();
  final TextEditingController _namaPelangganController = TextEditingController();
  final TextEditingController _jamMasukController = TextEditingController();
  final TextEditingController _jamKeluarController = TextEditingController();
  String _jenisPelanggan = 'VIP';
  DateTime _selectedDate = DateTime.now(); // Untuk menyimpan tanggal yang dipilih

  // Fungsi untuk memilih tanggal
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Fungsi untuk memproses data input dan berpindah ke halaman hasil
  void _submitData() {
    if (_formKey.currentState!.validate()) {
      double jamMasuk = double.parse(_jamMasukController.text);
      double jamKeluar = double.parse(_jamKeluarController.text);
      double lama = jamKeluar - jamMasuk;

      if (lama <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Jam Keluar harus lebih besar dari Jam Masuk')),
        );
        return;
      }

      // Navigasi ke halaman hasil dengan membawa data yang telah diinput
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BillingResultScreen(
            kodePelanggan: _kodePelangganController.text,
            namaPelanggan: _namaPelangganController.text,
            jenisPelanggan: _jenisPelanggan,
            lama: lama,
            tglMasuk: DateFormat('dd-MM-yyyy').format(_selectedDate), // Format tanggal masuk
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entri Data Pelanggan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _kodePelangganController,
                decoration: InputDecoration(labelText: 'Kode Pelanggan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan Kode Pelanggan';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _namaPelangganController,
                decoration: InputDecoration(labelText: 'Nama Pelanggan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan Nama Pelanggan';
                  }
                  return null;
                },
              ),
              
              // Menambahkan input untuk Tanggal Masuk (DatePicker)
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Tanggal Masuk: ${DateFormat('dd-MM-yyyy').format(_selectedDate)}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),

              TextFormField(
                controller: _jamMasukController,
                decoration: InputDecoration(labelText: 'Jam Masuk'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan Jam Masuk';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _jamKeluarController,
                decoration: InputDecoration(labelText: 'Jam Keluar'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan Jam Keluar';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _jenisPelanggan,
                onChanged: (String? newValue) {
                  setState(() {
                    _jenisPelanggan = newValue!;
                  });
                },
                items: ['VIP', 'GOLD'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Jenis Pelanggan'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitData, // Memanggil fungsi untuk submit data
                child: Text('Lanjutkan ke Halaman Hasil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
