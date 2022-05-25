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
  final formKey = GlobalKey<FormState>();
  // 本のタイトル
  TextEditingController titleController = TextEditingController();
  // 著者
  TextEditingController authorController = TextEditingController();

  List<String> genre = [
    'フロントエンド',
    'バックエンド',
    'ネイティブアプリ',
    'データサイエンス',
    '自己啓発',
    'その他'
  ];

  Future addBook() async {
    title = titleController.text;
    author = authorController.text;

    if (title != null && author != null && imageFile != null) {
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

      authorController.clear();
      titleController.clear();
      imageFile!.delete;
    } else {
      throw Error();
    }
  }

  void pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      notifyListeners();
    }
  }
}
