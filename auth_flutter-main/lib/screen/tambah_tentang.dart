import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../provider/tentang_provider.dart';

class TambahTentangPage extends StatefulWidget {
  @override
  _TambahTentangPageState createState() => _TambahTentangPageState();
}

class _TambahTentangPageState extends State<TambahTentangPage> {
  TextEditingController _keteranganController = TextEditingController();
  TextEditingController _prodiController = TextEditingController();
  TextEditingController _visiController = TextEditingController();
  TextEditingController _misiController = TextEditingController();
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
    final tentangProvider = Provider.of<TentangProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 201, 216, 245),
        elevation: 4.0,
        shadowColor: Color.fromARGB(255, 42, 127, 224),
        title: Text(
          "Tambah Tentang",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.normal,
          ),
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
                'Tambah Tentang',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
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
                controller: _keteranganController,
                decoration: InputDecoration(
                  labelText: 'Keterangan',
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
                controller: _prodiController,
                decoration: InputDecoration(
                  labelText: 'Prodi',
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
                controller: _visiController,
                decoration: InputDecoration(
                  labelText: 'Visi',
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
                controller: _misiController,
                decoration: InputDecoration(
                  labelText: 'Misi',
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
                      _keteranganController.clear();
                      _prodiController.clear();
                      _visiController.clear();
                      _misiController.clear();
                      setState(() {
                        _imageFile = null;
                      });
                    },
                    child: Text('Batal'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      String keterangan = _keteranganController.text;
                      String prodi = _prodiController.text;
                      String visi = _visiController.text;
                      String misi = _misiController.text;
                      if (keterangan.isEmpty ||
                          prodi.isEmpty ||
                          visi.isEmpty ||
                          misi.isEmpty ||
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
                        tentangProvider.tambahtentang(
                          _imageFile!,
                          keterangan,
                          prodi,
                          visi,
                          misi,
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
                        _keteranganController.clear();
                        _prodiController.clear();
                        _visiController.clear();
                        _misiController.clear();
                        setState(() {
                          _imageFile = null;
                        });
                      }
                    },
                    child: Text('Tambah Tentang'),
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
