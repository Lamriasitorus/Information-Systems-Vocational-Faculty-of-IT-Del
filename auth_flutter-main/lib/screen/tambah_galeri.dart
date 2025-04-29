import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../provider/galeri_provider.dart';

class TambahGaleriPage extends StatefulWidget {
  @override
  _TambahGaleriPageState createState() => _TambahGaleriPageState();
}

class _TambahGaleriPageState extends State<TambahGaleriPage> {
  TextEditingController _keteranganController = TextEditingController();
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
    final galeriProvider = Provider.of<GaleriProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 201, 216, 245),
        elevation: 4.0,
        shadowColor: Color.fromARGB(255, 42, 127, 224),
        title: Text(
          "Tambah Galeri",
          style: TextStyle(
              color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.normal),
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
                'Tambah Galeri',
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
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _keteranganController.clear();
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
                      if (keterangan.isEmpty || _imageFile == null) {
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
                        galeriProvider.tambahgaleri(
                          _imageFile!,
                          keterangan,
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
                        setState(() {
                          _imageFile = null;
                        });
                      }
                    },
                    child: Text('Tambah Galeri'),
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
