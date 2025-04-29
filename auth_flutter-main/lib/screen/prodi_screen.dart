import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../provider/prodi_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'tambah_prodi.dart';

class ProdiPage extends StatefulWidget {
  @override
  _ProdiPageState createState() => _ProdiPageState();
}

class _ProdiPageState extends State<ProdiPage> {
  TextEditingController _namaController = TextEditingController();
  TextEditingController _sejarahController = TextEditingController();
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
    final prodiProvider = Provider.of<ProdiProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 201, 216, 245),
        elevation: 4.0,
        shadowColor: Color.fromARGB(255, 42, 127, 224),
        title: Text(
          "Halaman Program Studi",
          style: TextStyle(
              color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.normal),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TambahProdiPage()),
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
                'Daftar prodi',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('prodi').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var prodi = snapshot.data!.docs[index];
                        String docId = prodi.id;

                        return Container(
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[200],
                          ),
                          child: ListTile(
                            title: Text(
                              prodi['nama'],
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
                                    prodi['gambar'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  prodi['sejarah'],
                                  style: TextStyle(
                                    color: const Color.fromARGB(255, 89, 89, 89),
                                    fontFamily: 'Pacifico',
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  prodi['visi'],
                                  style: TextStyle(
                                    color: const Color.fromARGB(255, 89, 89, 89),
                                    fontFamily: 'Pacifico',
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  prodi['misi'],
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
                                    _namaController.text = prodi['nama'];
                                    _sejarahController.text = prodi['sejarah'];
                                    _visiController.text = prodi['visi'];
                                    _misiController.text = prodi['misi'];
                                    _imageFile = null; // Reset image file

                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('Edit Prodi'),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                GestureDetector(
                                                  onTap: _pickImage,
                                                  child: Container(
                                                    height: 200,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(color: Colors.grey),
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: _imageFile == null
                                                        ? Image.network(prodi['gambar'], fit: BoxFit.cover)
                                                        : Image.file(_imageFile!, fit: BoxFit.cover),
                                                  ),
                                                ),
                                                TextField(
                                                  controller: _namaController,
                                                  decoration: InputDecoration(labelText: 'Nama'),
                                                ),
                                                TextField(
                                                  controller: _sejarahController,
                                                  decoration: InputDecoration(labelText: 'Sejarah'),
                                                ),
                                                TextField(
                                                  controller: _visiController,
                                                  decoration: InputDecoration(labelText: 'Visi'),
                                                ),
                                                TextField(
                                                  controller: _misiController,
                                                  decoration: InputDecoration(labelText: 'Misi'),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                _namaController.clear();
                                                _sejarahController.clear();
                                                _visiController.clear();
                                                _misiController.clear();
                                                setState(() {
                                                  _imageFile = null;
                                                });
                                                Navigator.pop(context);
                                              },
                                              child: Text('Batal'),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                String? error = await prodiProvider.Editprodi(
                                                  _namaController.text,
                                                  _imageFile ?? prodi['gambar'],
                                                  _sejarahController.text,
                                                  _visiController.text,
                                                  _misiController.text,
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
                                                _sejarahController.clear();
                                                _visiController.clear();
                                                _misiController.clear();
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
                                          content: Text(
                                              "Apakah Anda yakin ingin menghapus data ini?"),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text("Batal"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text("Hapus"),
                                              onPressed: () async {
                                                await FirebaseFirestore.instance
                                                    .collection('prodi')
                                                    .doc(docId)
                                                    .delete();
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
