import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';


class ProdiProvider extends ChangeNotifier {
  final CollectionReference _prodiCollection =
      FirebaseFirestore.instance.collection('prodi');

  Future<String?> tambahprodi(
    File? imageFile, String nama, String sejarah, String visi, String misi) async {
    try {
      if ( nama.isNotEmpty && sejarah.isNotEmpty && visi.isNotEmpty && misi.isNotEmpty) {
        // Simpan file gambar ke Firebase Storage
        String imageUrl;
        if (imageFile != null) {
          String fileName = DateTime.now().millisecondsSinceEpoch.toString();
          Reference storageRef =
              FirebaseStorage.instance.ref().child('images/$fileName');
          UploadTask uploadTask = storageRef.putFile(imageFile);
          await uploadTask.whenComplete(() => null);
          imageUrl = await storageRef.getDownloadURL();
        } else {
          imageUrl =
              ''; // Atau URL gambar default jika tidak ada file gambar yang diunggah
        }
        await _prodiCollection.add({
          'gambar': imageUrl,
          'nama': nama,
          'sejarah': sejarah,
          'visi': visi,
          'misi': misi,
        });
        return null;
      } else {
        return 'Semua kolom harus diisi.';
      }
    } catch (error) {
      return 'Gagal menambahkan data prodi: $error';
    }
  }

  Future<String?> Editprodi(String nama, dynamic gambar, String sejarah, String visi, String misi, String docId) async {
  try {
    DocumentSnapshot snapshot = await _prodiCollection.doc(docId).get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    String imageUrl = data!['gambar'];

    if (gambar is File) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = FirebaseStorage.instance.ref().child('images/$fileName');
      UploadTask uploadTask = storageRef.putFile(gambar);
      await uploadTask.whenComplete(() => null);
      imageUrl = await storageRef.getDownloadURL();
    }

    await _prodiCollection.doc(docId).update({
      'gambar': imageUrl,
      'nama': nama,
      'sejarah': sejarah,
      'visi': visi,
      'misi': misi,
    });

    return null;
  } catch (error) {
    return 'Gagal memperbarui data berita: $error';
  }
}

  Future<String?> hapusprodi(String docId) async {
    try {
      await _prodiCollection.doc(docId).delete();
      return null;
    } catch (error) {
      return 'Gagal menghapus data prodi: $error';
    }
  }
}
