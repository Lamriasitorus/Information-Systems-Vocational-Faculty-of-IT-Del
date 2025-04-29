import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';


class GaleriProvider extends ChangeNotifier {
  final CollectionReference _galeriCollection =
      FirebaseFirestore.instance.collection('galeri');

  Future<String?> tambahgaleri( 
      File? imageFile, String keterangan) async {
    try {
      if (keterangan.isNotEmpty) {
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

        await _galeriCollection.add({
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

  Future<String?> editgaleri(
      dynamic gambar, String keterangan, String docId) async {
    try {
      // Ambil data kegiatan yang akan diedit dari Firestore
      DocumentSnapshot snapshot = await _galeriCollection.doc(docId).get();
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

      // Perbarui data kegiatan di Firestore
      await _galeriCollection.doc(docId).update({
        'gambar': imageUrl,
        'keterangan': keterangan,
      });
      return null;
    } catch (error) {
      return 'Gagal memperbarui data kegiatan: $error';
    }
  }

  Future<String?> hapusgaleri(String docId) async {
    try {
      await _galeriCollection.doc(docId).delete();
      return null;
    } catch (error) {
      return 'Gagal menghapus data kegiatan: $error';
    }
  }
}
