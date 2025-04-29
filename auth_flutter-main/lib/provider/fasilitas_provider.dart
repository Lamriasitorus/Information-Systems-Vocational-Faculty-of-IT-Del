import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';


class FasilitasProvider extends ChangeNotifier {
  final CollectionReference _fasilitasCollection =
      FirebaseFirestore.instance.collection('fasilitas');

  Future<String?> tambahFasilitas(
    File? imageFile, String judul, String keterangan) async {
    try {
      if (judul.isNotEmpty && keterangan.isNotEmpty) {
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
        await _fasilitasCollection.add({
          'judul': judul,
          'gambar': imageUrl,
          'keterangan': keterangan,
        });
        return null;
      } else {
        return 'Semua kolom harus diisi.';
      }
    } catch (error) {
      return 'Gagal menambahkan data kegiatan: $error';
    }
  }

  Future<String?> editFasilitas(
      String judul, dynamic gambar, String keterangan, String docId) async {
    try {
      // Ambil data kegiatan yang akan diedit dari Firestore
      DocumentSnapshot snapshot = await _fasilitasCollection.doc(docId).get();
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

      // Perbarui data fasilitas di Firestore
      await _fasilitasCollection.doc(docId).update({
        'judul': judul,
        'gambar': imageUrl,
        'keterangan': keterangan,
      });
      return null;
    } catch (error) {
      return 'Gagal memperbarui data fasilitas: $error';
    }
  }

  Future<String?> hapusFasilitas(String docId) async {
    try {
      await _fasilitasCollection.doc(docId).delete();
      return null;
    } catch (error) {
      return 'Gagal menghapus data fasilitas: $error';
    }
  }
}
