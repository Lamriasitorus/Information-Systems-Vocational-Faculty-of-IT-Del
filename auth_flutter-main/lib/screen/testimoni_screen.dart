import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../provider/testimoni_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'tambah_testimoni.dart';
import 'dart:io';

class TestimoniPage extends StatefulWidget {
  @override
  _TestimoniPageState createState() => _TestimoniPageState();
}

class _TestimoniPageState extends State<TestimoniPage> {
  TextEditingController _namaController = TextEditingController();
  TextEditingController _pekerjaanController = TextEditingController();
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
    final testimoniProvider = Provider.of<TestimoniProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 201, 216, 245),
        elevation: 4.0,
        shadowColor: Color.fromARGB(255, 42, 127, 224),
        title: Text(
          "Halaman Testimoni",
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
                'Daftar Testimoni',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('testimoni')
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
                        var testimoni = snapshot.data!.docs[index];
                        String docId = testimoni.id;
                        return Container(
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[200],
                          ),
                          child: ListTile(
                            title: Text(
                              testimoni['nama'],
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
                                    testimoni['gambar'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  testimoni['pekerjaan'],
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                      255,
                                      89,
                                      89,
                                      89,
                                    ),
                                    fontFamily: 'Pacifico',
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  testimoni['keterangan'],
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                      255,
                                      89,
                                      89,
                                      89,
                                    ),
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
                                    _namaController.text = testimoni['nama'];
                                    _pekerjaanController.text = testimoni['pekerjaan'];
                                    _keteranganController.text = testimoni['keterangan'];
                                    _imageFile = null; // Reset image file

                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('Edit Testimoni'),
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
                                                        ? Image.network(testimoni['gambar'], fit: BoxFit.cover)
                                                        : Image.file(_imageFile!, fit: BoxFit.cover),
                                                  ),
                                                ),
                                                TextField(
                                                  controller: _namaController,
                                                  decoration: InputDecoration(labelText: 'Nama'),
                                                ),
                                                TextField(
                                                  controller: _pekerjaanController,
                                                  decoration: InputDecoration(labelText: 'Pekerjaan'),
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
                                                _namaController.clear();
                                                _pekerjaanController.clear();
                                                _keteranganController.clear();
                                                setState(() {
                                                  _imageFile = null;
                                                });
                                                Navigator.pop(context);
                                              },
                                              child: Text('Batal'),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                String? error = await testimoniProvider.Edittestimoni(
                                                  _namaController.text,
                                                  _imageFile ?? testimoni['gambar'],
                                                  _pekerjaanController.text,
                                                  _keteranganController.text,
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
                                                _pekerjaanController.clear();
                                                _keteranganController.clear();
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
                                              child: Text("Ya"),
                                              onPressed: () {
                                                testimoniProvider
                                                    .hapustestimoni(docId);
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
            MaterialPageRoute(builder: (context) => tambahTestimoniPage()),
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
