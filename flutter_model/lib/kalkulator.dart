import 'package:flutter/material.dart';

void main() {
  runApp(KalkulatorApp());
}

class KalkulatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalkulator Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: KalkulatorHomePage(),
    );
  }
}

class KalkulatorHomePage extends StatefulWidget {
  @override
  _KalkulatorHomePageState createState() => _KalkulatorHomePageState();
}

class _KalkulatorHomePageState extends State<KalkulatorHomePage> {
  final TextEditingController _angka1Controller = TextEditingController();
  final TextEditingController _angka2Controller = TextEditingController();
  String _hasil = "";

  void _hitung(String operasi) {
    double angka1 = double.tryParse(_angka1Controller.text) ?? 0;
    double angka2 = double.tryParse(_angka2Controller.text) ?? 0;
    double hasil = 0;

    switch (operasi) {
      case '+':
        hasil = angka1 + angka2;
        break;
      case '-':
        hasil = angka1 - angka2;
        break;
      case '*':
        hasil = angka1 * angka2;
        break;
      case '/':
        if (angka2 != 0) {
          hasil = angka1 / angka2;
        } else {
          _hasil = "Tidak dapat dibagi dengan nol";
          setState(() {});
          return;
        }
        break;
    }

    _hasil = hasil.toString();
    setState(() {});
  }

  Widget _buildButton(String operasi) {
    return ElevatedButton(
      onPressed: () => _hitung(operasi),
      child: Text(
        operasi,
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kalkulator Flutter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _angka1Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Angka 1',
              ),
            ),
            TextField(
              controller: _angka2Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Angka 2',
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildButton('+'),
                _buildButton('-'),
                _buildButton('*'),
                _buildButton('/'),
              ],
            ),
            SizedBox(height: 20.0),
            Text(
              'Hasil: $_hasil',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}