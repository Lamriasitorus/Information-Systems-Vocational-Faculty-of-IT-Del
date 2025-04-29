import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';


class BeritaProvider extends ChangeNotifier {
  final CollectionReference _beritaCollection =
      FirebaseFirestore.instance.collection('berita');

  Future<String?> tambahBerita(
    File? imageFile, String judul, String keterangan, String tanggal) async {
    try {
      if (judul.isNotEmpty && keterangan.isNotEmpty && tanggal.isNotEmpty) {
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
        await _beritaCollection.add({
          'judul': judul,
          'gambar': imageUrl,
          'keterangan': keterangan,
          'tanggal': tanggal,
        });
        return null;
      } else {
        return 'Semua kolom harus diisi.';
      }
    } catch (error) {
      return 'Gagal menambahkan data kegiatan: $error';
    }
  }

  Future<String?> editBerita(
      String judul, dynamic gambar, String keterangan, String tanggal, String docId) async {
    try {
      // Ambil data kegiatan yang akan diedit dari Firestore
      DocumentSnapshot snapshot = await _beritaCollection.doc(docId).get();
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
      await _beritaCollection.doc(docId).update({
        'judul': judul,
        'gambar': imageUrl,
        'keterangan': keterangan,
        'tanggal': tanggal,
      });
      return null;
    } catch (error) {
      return 'Gagal memperbarui data berita: $error';
    }
  }

  Future<String?> hapusBerita(String docId) async {
    try {
      await _beritaCollection.doc(docId).delete();
      return null;
    } catch (error) {
      return 'Gagal menghapus data berita: $error';
    }
  }
}
