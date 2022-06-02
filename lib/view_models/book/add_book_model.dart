import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddBookModel extends ChangeNotifier {
  String selectedGenre = 'フロントエンド';
  String? title;
  File? imageFile;
  final picker = ImagePicker();
  final formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();

  List<String> genre = [
    'フロントエンド',
    'バックエンド',
    'スマホアプリ',
    'データサイエンス',
    '自己啓発',
    'その他'
  ];

  void setGenre(String item) {
    selectedGenre = item;
    notifyListeners();
  }

  void pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      notifyListeners();
    }
  }

  Future addBook() async {
    title = titleController.text;

    if (title != null && imageFile != null) {
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
        'imgURL': imgURL,
        'genre': selectedGenre,
      });

      titleController.clear();
      imageFile = null;
      notifyListeners();
    } else {
      throw Error();
    }
  }
}
