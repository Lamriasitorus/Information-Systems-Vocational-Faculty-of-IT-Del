import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'tambah_galeri.dart';
import '../provider/galeri_provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class GaleriPage extends StatefulWidget {
  @override
  _GaleriPageState createState() => _GaleriPageState();
}

class _GaleriPageState extends State<GaleriPage> {
  @override
  Widget build(BuildContext context) {
    final galeriProvider = Provider.of<GaleriProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 201, 216, 245),
        elevation: 4.0,
        shadowColor: Color.fromARGB(255, 42, 127, 224),
        title: Text(
          "Halaman Galeri",
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
                'Daftar Galeri',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('galeri')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var galeri = snapshot.data!.docs[index];
                        String docId = galeri.id;
                        return Container(
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[200],
                          ),
                          child: ListTile(
                            title: Text(
                              galeri['keterangan'],
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
                                    galeri['gambar'],
                                    fit: BoxFit.cover,
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
                                        TextEditingController _keteranganController =
                                            TextEditingController(text: galeri['keterangan']);
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

                                        return AlertDialog(
                                          title: Text('Edit Galeri'),
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
                                                            galeri['gambar'],
                                                            fit: BoxFit.cover,
                                                          )
                                                        : Image.file(
                                                            _imageFile!,
                                                            fit: BoxFit.cover,
                                                          ),
                                                  ),
                                                ),
                                                TextField(
                                                  controller: _keteranganController,
                                                  decoration: InputDecoration(labelText: 'Keterangan'),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('Batal'),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                String? error = await galeriProvider.editgaleri(
                                                  _imageFile ?? galeri['gambar'],
                                                  _keteranganController.text,
                                                  docId,
                                                );
                                                if (error == null) {
                                                  Navigator.pop(context);
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Text("Sukses"),
                                                        content: Text("Data berhasil diubah."),
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
                                              child: Text("Ya"),
                                              onPressed: () {
                                                galeriProvider.hapusgaleri(docId);
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
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TambahGaleriPage()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 201, 216, 245),
        foregroundColor: Colors.black,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
