import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddBookModel extends ChangeNotifier {
  String selectedGenre = 'フロントエンド';
  String? title;
  String? author;
  File? imageFile;
  final picker = ImagePicker();

  Future addBook() async {
    final doc = FirebaseFirestore.instance.collection('book').doc();

    String? imgURL;
    if (imageFile != null) {
      final task = await FirebaseStorage.instance
          .ref('books/${doc.id}')
          .putFile(imageFile!);
      imgURL = await task.ref.getDownloadURL();
    }

    await doc.set({
      'title': title,
      'author': author,
      'imgURL': imgURL,
      'genre': selectedGenre,
    });
  }

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      notifyListeners();
    }
  }
}
