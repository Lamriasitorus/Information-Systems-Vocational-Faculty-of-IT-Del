import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';


class TestimoniProvider extends ChangeNotifier {
  final CollectionReference _testimoniCollection =
      FirebaseFirestore.instance.collection('testimoni');

  Future<String?> tambahtestimoni(
    File? imageFile, String nama, String keterangan, String pekerjaan) async {
    try {
      if (nama.isNotEmpty && keterangan.isNotEmpty && pekerjaan.isNotEmpty) {
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
        await _testimoniCollection.add({
          'nama': nama,
          'gambar': imageUrl,
          'keterangan': keterangan,
          'pekerjaan': pekerjaan,
        });
        return null;
      } else {
        return 'Semua kolom harus diisi.';
      }
    } catch (error) {
      return 'Gagal menambahkan data testimoni: $error';
    }
  }

  Future<String?> Edittestimoni(
      String nama, dynamic gambar, String keterangan, String pekerjaan, String docId) async {
    try {
      // Ambil data kegiatan yang akan diedit dari Firestore
      DocumentSnapshot snapshot = await _testimoniCollection.doc(docId).get();
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      // Jika tidak ada perubahan gambar, gunakan gambar lama
      String imageUrl = data!['gambar'];

      // Jika ada perubahan gambar, upload gambar baru ke Firebase Storage
      if (gambar is File) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageRef =
            FirebaseStorage.instance.ref().child('images/$fileName');
        UploadTask uploadTask = storageRef.putFile(gambar);
        await uploadTask.whenComplete(() => null);
        imageUrl = await storageRef.getDownloadURL();
      }

      // Perbarui data berita di Firestore
      await _testimoniCollection.doc(docId).update({
          'nama': nama,
          'gambar': imageUrl,
          'keterangan': keterangan,
          'pekerjaan': pekerjaan,
      });
      return null;
    } catch (error) {
      return 'Gagal memperbarui data testimoni: $error';
    }
  }

  Future<String?> hapustestimoni(String docId) async {
    try {
      await _testimoniCollection.doc(docId).delete();
      return null;
    } catch (error) {
      return 'Gagal menghapus data testimoni: $error';
    }
  }
}
