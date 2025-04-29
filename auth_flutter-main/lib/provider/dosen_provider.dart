import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';


class DosenProvider extends ChangeNotifier {
  final CollectionReference _dosenCollection =
      FirebaseFirestore.instance.collection('dosen');

  Future<String?> tambahDosen(
    File? imageFile, String nama, String email, String jabatan, String prestasi, String riwayatpendidikan) async {
    try {
      if (nama.isNotEmpty && email.isNotEmpty && jabatan.isNotEmpty && prestasi.isNotEmpty && riwayatpendidikan.isNotEmpty) {
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
        await _dosenCollection.add({
          'nama': nama,
          'gambar': imageUrl,
          'email': email,
          'jabatan': jabatan,
          'prestasi': prestasi,
          'riwayatpendidikan': riwayatpendidikan,
        });
        return null;
      } else {
        return 'Semua kolom harus diisi.';
      }
    } catch (error) {
      return 'Gagal menambahkan data kegiatan: $error';
    }
  }

  Future<String?> editDosen(
      String nama, dynamic gambar, String email, String jabatan, String prestasi, String riwayatpendidikan, String docId) async {
    try {
      // Ambil data kegiatan yang akan diedit dari Firestore
      DocumentSnapshot snapshot = await _dosenCollection.doc(docId).get();
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

      // Perbarui data dosen di Firestore
      await _dosenCollection.doc(docId).update({
          'nama': nama,
          'gambar': imageUrl,
          'email': email,
          'jabatan': jabatan,
          'prestasi': prestasi,
          'riwayatpendidikan': riwayatpendidikan,
      });
      return null;
    } catch (error) {
      return 'Gagal memperbarui data dosen: $error';
    }
  }

  Future<String?> hapusDosen(String docId) async {
    try {
      await _dosenCollection.doc(docId).delete();
      return null;
    } catch (error) {
      return 'Gagal menghapus data dosen: $error';
    }
  }
}
