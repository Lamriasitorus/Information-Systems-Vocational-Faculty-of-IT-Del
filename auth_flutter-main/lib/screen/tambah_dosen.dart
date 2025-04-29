import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_uilogin/provider/dosen_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class TambahDosenPage extends StatefulWidget {
  @override
  _TambahDosenPageState createState() => _TambahDosenPageState();
}

class _TambahDosenPageState extends State<TambahDosenPage> {
  TextEditingController _namaController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _jabatanController = TextEditingController();
  TextEditingController _prestasiController = TextEditingController();
  TextEditingController _riwayatpendidikanController = TextEditingController();
  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dosenProvider = Provider.of<DosenProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 201, 216, 245),
        elevation: 4.0,
        shadowColor: Color.fromARGB(255, 42, 127, 224),
        title: Text(
          "Tambah Dosen",
          style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.normal),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tambah Dosen',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _namaController,
                decoration: InputDecoration(
                  labelText: 'Nama',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _imageFile == null
                      ? Center(
                          child: Text(
                            'Tap untuk memilih gambar',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : Image.file(
                          _imageFile!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _jabatanController,
                decoration: InputDecoration(
                  labelText: 'Jabatan',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _prestasiController,
                decoration: InputDecoration(
                  labelText: 'Prestasi',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _riwayatpendidikanController,
                decoration: InputDecoration(
                  labelText: 'Riwayat Pendidikan',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _namaController.clear();
                      _emailController.clear();
                      _jabatanController.clear();
                      _prestasiController.clear();
                      _riwayatpendidikanController.clear();
                    },
                    child: Text('Batal'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      String nama = _namaController.text;
                      String email = _emailController.text;
                      String jabatan = _jabatanController.text;
                      String prestasi = _prestasiController.text;
                      String riwayatpendidikan = _riwayatpendidikanController.text;

                      if (nama.isEmpty ||
                          email.isEmpty ||
                          jabatan.isEmpty ||
                          prestasi.isEmpty ||
                          riwayatpendidikan.isEmpty ||
                          _imageFile == null) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Error'),
                              content: Text('Semua kolom harus diisi.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        dosenProvider.tambahDosen(
                          _imageFile!,
                          nama,
                          email,
                          jabatan,
                          prestasi,
                          riwayatpendidikan,
                        );
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Sukses'),
                              content: Text('Data berhasil ditambahkan.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                        _namaController.clear();
                        _emailController.clear();
                        _jabatanController.clear();
                        _prestasiController.clear();
                        _riwayatpendidikanController.clear();
                        setState(() {
                          _imageFile = null;
                        });
                      }
                    },
                    child: Text('Tambah Dosen'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
