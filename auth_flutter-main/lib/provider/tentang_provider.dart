import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';


class TentangProvider extends ChangeNotifier {
  final CollectionReference _tentangCollection =
      FirebaseFirestore.instance.collection('tentang');

  Future<String?> tambahtentang(
    File? imageFile, String prodi, String keterangan, String visi, String misi) async {
    try {
      if ( keterangan.isNotEmpty && prodi.isNotEmpty && visi.isNotEmpty && misi.isNotEmpty) {
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
        await _tentangCollection.add({
          'gambar': imageUrl,
          'keterangan': keterangan,
          'prodi': prodi,
          'visi': visi,
          'misi': misi,
        });
        return null;
      } else {
        return 'Semua kolom harus diisi.';
      }
    } catch (error) {
      return 'Gagal menambahkan data tentang: $error';
    }
  }

  Future<String?> Edittentang(
  String prodi, dynamic gambar, String keterangan, String visi, String misi, String docId) async {
  try {
    DocumentSnapshot snapshot = await _tentangCollection.doc(docId).get();
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    String imageUrl = data!['gambar'];

    if (gambar is File) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef =
          FirebaseStorage.instance.ref().child('images/$fileName');
      UploadTask uploadTask = storageRef.putFile(gambar);
      await uploadTask.whenComplete(() => null);
      imageUrl = await storageRef.getDownloadURL();
    }

    await _tentangCollection.doc(docId).update({
      'gambar': imageUrl,
      'keterangan': keterangan,
      'prodi': prodi,
      'visi': visi,
      'misi': misi,
    });
    return null;
  } catch (error) {
    return 'Gagal memperbarui data berita: $error';
  }
}


  Future<String?> hapustentang(String docId) async {
    try {
      await _tentangCollection.doc(docId).delete();
      return null;
    } catch (error) {
      return 'Gagal menghapus data berita: $error';
    }
  }
}
