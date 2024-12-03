import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> books = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  // Fungsi untuk mengambil data buku
  Future<void> fetchBooks() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost/pustaka/databasepustaka/buku.php'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          books = data['data'];
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fungsi untuk menambah buku
  Future<void> addBook() async {
    final TextEditingController judulController = TextEditingController();
    final TextEditingController pengarangController = TextEditingController();
    final TextEditingController penerbitController = TextEditingController();
    final TextEditingController tahunController = TextEditingController();
    final TextEditingController urlGambarController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Tambah Buku Baru'),
          content: Container(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(
                    controller: judulController,
                    label: 'Judul Buku',
                    icon: Icons.book,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: pengarangController,
                    label: 'Nama Pengarang',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: penerbitController,
                    label: 'Penerbit',
                    icon: Icons.business,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: tahunController,
                    label: 'Tahun Terbit',
                    icon: Icons.calendar_today,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: urlGambarController,
                    label: 'URL Gambar',
                    icon: Icons.image,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal', style: TextStyle(color: Colors.grey[600])),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final response = await http.post(
                    Uri.parse('http://localhost/pustaka/databasepustaka/buku.php'),
                    headers: {'Content-Type': 'application/json'},
                    body: json.encode({
                      'judul': judulController.text,
                      'pengarang': pengarangController.text,
                      'penerbit': penerbitController.text,
                      'tahun': tahunController.text,
                      'url_gambar': urlGambarController.text,
                      'status': 'Tersedia',
                    }),
                  );

                  if (response.statusCode == 200) {
                    Navigator.pop(context);
                    fetchBooks();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Buku berhasil ditambahkan'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk mengupdate buku
  Future<void> updateBook(Map<String, dynamic> book) async {
    final TextEditingController judulController = 
        TextEditingController(text: book['judul']);
    final TextEditingController pengarangController = 
        TextEditingController(text: book['pengarang']);
    final TextEditingController penerbitController = 
        TextEditingController(text: book['penerbit']);
    final TextEditingController tahunController = 
        TextEditingController(text: book['tahun']);
    final TextEditingController urlGambarController = 
        TextEditingController(text: book['url_gambar']);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Buku'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: judulController,
                  decoration: const InputDecoration(labelText: 'Judul'),
                ),
                TextField(
                  controller: pengarangController,
                  decoration: const InputDecoration(labelText: 'Pengarang'),
                ),
                TextField(
                  controller: penerbitController,
                  decoration: const InputDecoration(labelText: 'Penerbit'),
                ),
                TextField(
                  controller: tahunController,
                  decoration: const InputDecoration(labelText: 'Tahun'),
                ),
                TextField(
                  controller: urlGambarController,
                  decoration: const InputDecoration(labelText: 'URL Gambar'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final response = await http.put(
                    Uri.parse('http://localhost/pustaka/databasepustaka/buku.php'),
                    headers: {'Content-Type': 'application/json'},
                    body: json.encode({
                      'id': book['id'],
                      'judul': judulController.text,
                      'pengarang': pengarangController.text,
                      'penerbit': penerbitController.text,
                      'tahun': tahunController.text,
                      'url_gambar': urlGambarController.text,
                      'status': book['status'] ?? 'Tersedia',
                    }),
                  );

                  if (response.statusCode == 200) {
                    Navigator.pop(context);
                    fetchBooks(); // Refresh data
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Buku berhasil diupdate')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menghapus buku
  Future<void> deleteBook(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost/pustaka/databasepustaka/buku.php?id=$id'),
      );
      
      if (response.statusCode == 200) {
        fetchBooks(); // Refresh data
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Buku berhasil dihapus')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perpustakaan Digital'),
        backgroundColor: Colors.blue[800],
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue[800]!,
              Colors.blue[200]!,
            ],
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final book = books[index];
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: Colors.white.withOpacity(0.9),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Gambar Buku
                        Expanded(
                          flex: 3,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(15),
                              ),
                              color: Colors.grey[200],
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(15),
                              ),
                              child: book['url_gambar'] != null && book['url_gambar'].toString().trim().isNotEmpty
                                  ? Image.network(
                                      book['url_gambar'].toString(),
                                      fit: BoxFit.cover,
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress.expectedTotalBytes != null
                                                ? loadingProgress.cumulativeBytesLoaded / 
                                                  loadingProgress.expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                      errorBuilder: (context, error, stackTrace) {
                                        print('Error loading image: $error');
                                        return const Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                        );
                                      },
                                    )
                                  : const Center(
                                      child: Icon(
                                        Icons.image_not_supported,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        // Informasi Buku
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book['judul'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  book['pengarang'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Tahun ${book['tahun']}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const Spacer(),
                                // Tombol aksi
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, 
                                        size: 20, 
                                        color: Colors.blue
                                      ),
                                      onPressed: () => updateBook(book),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.delete, 
                                        size: 20, 
                                        color: Colors.red
                                      ),
                                      onPressed: () => showDialog(
                                        context: context,
                                        builder: (BuildContext context) => 
                                          _buildDeleteDialog(book),
                                      ),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addBook,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Buku'),
        backgroundColor: Colors.blue[800],
      ),
    );
  }

  // Tambahkan method baru untuk dialog delete
  Widget _buildDeleteDialog(Map<String, dynamic> book) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: const Text('Konfirmasi Hapus'),
      content: const Text('Yakin ingin menghapus buku ini?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Batal', style: TextStyle(color: Colors.grey[600])),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            deleteBook(book['id'].toString());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Hapus'),
        ),
      ],
    );
  }

  // Tambahkan helper method untuk TextField yang konsisten
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }
}