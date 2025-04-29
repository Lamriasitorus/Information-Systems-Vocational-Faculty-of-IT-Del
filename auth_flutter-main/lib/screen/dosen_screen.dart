import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_uilogin/provider/dosen_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'tambah_dosen.dart';

class DosenPage extends StatefulWidget {
  @override
  _DosenPageState createState() => _DosenPageState();
}

class _DosenPageState extends State<DosenPage> {
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
          "Halaman Dosen",
          style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.normal),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TambahDosenPage()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 201, 216, 245),
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Daftar Dosen',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('dosen').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var dosen = snapshot.data!.docs[index];
                        String docId = dosen.id;

                        return Container(
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[200],
                          ),
                          child: ListTile(
                            title: Text(
                              dosen['nama'],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 123,
                                  child: Image.network(
                                    dosen['gambar'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  dosen['email'],
                                  style: TextStyle(
                                    color: const Color.fromARGB(255, 89, 89, 89),
                                    fontFamily: 'Pacifico',
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  dosen['jabatan'],
                                  style: TextStyle(
                                    color: const Color.fromARGB(255, 89, 89, 89),
                                    fontFamily: 'Pacifico',
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  dosen['prestasi'],
                                  style: TextStyle(
                                    color: const Color.fromARGB(255, 89, 89, 89),
                                    fontFamily: 'Pacifico',
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  dosen['riwayatpendidikan'],
                                  style: TextStyle(
                                    color: const Color.fromARGB(255, 89, 89, 89),
                                    fontFamily: 'Pacifico',
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        _namaController.text = dosen['nama'];
                                        _emailController.text = dosen['email'];
                                        _jabatanController.text = dosen['jabatan'];
                                        _prestasiController.text = dosen['prestasi'];
                                        _riwayatpendidikanController.text = dosen['riwayatpendidikan'];
                                        return AlertDialog(
                                          title: Text('Edit Dosen'),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                GestureDetector(
                                                  onTap: _pickImage,
                                                  child: Container(
                                                    height: 200,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                      ),
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: _imageFile == null
                                                        ? Image.network(
                                                            dosen['gambar'],
                                                            fit: BoxFit.cover,
                                                          )
                                                        : Image.file(
                                                            _imageFile!,
                                                            fit: BoxFit.cover,
                                                          ),
                                                  ),
                                                ),
                                                TextField(
                                                  controller: _namaController,
                                                  decoration: InputDecoration(labelText: 'nama'),
                                                ),
                                                TextField(
                                                  controller: _emailController,
                                                  decoration: InputDecoration(labelText: 'email'),
                                                ),
                                                TextField(
                                                  controller: _jabatanController,
                                                  decoration: InputDecoration(labelText: 'jabatan'),
                                                ),
                                                TextField(
                                                  controller: _prestasiController,
                                                  decoration: InputDecoration(labelText: 'prestasi'),
                                                ),
                                                TextField(
                                                  controller: _riwayatpendidikanController,
                                                  decoration: InputDecoration(labelText: 'riwayatpendidikan'),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                _namaController.clear();
                                                _emailController.clear();
                                                _jabatanController.clear();
                                                _prestasiController.clear();
                                                _riwayatpendidikanController.clear();
                                                setState(() {
                                                  _imageFile = null;
                                                });
                                                Navigator.pop(context);
                                              },
                                              child: Text('Batal'),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                String? error = await dosenProvider.editDosen(
                                                  _namaController.text,
                                                  _imageFile ?? dosen['gambar'],
                                                  _emailController.text,
                                                  _jabatanController.text,
                                                  _prestasiController.text,
                                                  _riwayatpendidikanController.text,
                                                  docId,
                                                );
                                                if (error == null) {
                                                  Navigator.pop(context);
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Text('Sukses'),
                                                        content: Text('Data berhasil diubah.'),
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
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Text('Error'),
                                                        content: Text(error),
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
                                                }
                                                _namaController.clear();
                                                _emailController.clear();
                                                _jabatanController.clear();
                                                _prestasiController.clear();
                                                _riwayatpendidikanController.clear();
                                                setState(() {
                                                  _imageFile = null;
                                                });
                                              },
                                              child: Text('Simpan'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Konfirmasi"),
                                          content: Text("Apakah Anda yakin ingin menghapus data ini?"),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text("Batal"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text("Ya"),
                                              onPressed: () {
                                                dosenProvider.hapusDosen(docId);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
