import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:tech_library/models/account.dart';
import 'package:tech_library/models/book.dart';
import 'package:tech_library/utils/authentication.dart';
import 'package:tech_library/utils/function_utils.dart';

class AccountModel extends ChangeNotifier {
  Account? usersInfo;
  List<Book> usersBook = [];
  static final _firestoreInstance = FirebaseFirestore.instance;
  File? imageFile;
  TextEditingController nameController =
      TextEditingController(text: Authentication.myAccount!.name);

  void fetchMyAccount() {
    final Stream<DocumentSnapshot> snapshots = _firestoreInstance
        .collection('users')
        .doc(Authentication.myAccount!.id)
        .snapshots();

    snapshots.listen((DocumentSnapshot snapshot) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      Account usersInfo = Account(
        name: data['name'],
        imagePath: data['image_path'],
      );
      this.usersInfo = usersInfo;
      notifyListeners();
    });
  }

  void fetchMyBook() {
    final Stream<QuerySnapshot> snapshots = _firestoreInstance
        .collection('users')
        .doc(Authentication.myAccount!.id)
        .collection('my_book')
        .snapshots();

    snapshots.listen((QuerySnapshot snapshot) {
      final usersBook = snapshot.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        return Book(
            id: document.id, title: data['title'], imgURL: data['imgURL']);
      }).toList();
      this.usersBook = usersBook;
      notifyListeners();
    });
  }

  ImageProvider fetchImage() {
    if (imageFile == null) {
      return NetworkImage(usersInfo!.imagePath);
    } else {
      return FileImage(imageFile!);
    }
  }

  Future pickImage() async {
    final pickedFile = await FunctionUtils.fetchImageFromGallery();
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      notifyListeners();
    }
  }

  Future update() async {
    String imagePath = '';
    if (imageFile == null) {
      imagePath = Authentication.myAccount!.imagePath;
    } else {
      var result = await FunctionUtils.uploadImage(
          Authentication.myAccount!.id, imageFile!);
      imagePath = result;
    }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Authentication.myAccount!.id)
        .update({
      'name': nameController.text,
      'image_path': imagePath,
    });
    Authentication.myAccount!.name = nameController.text;
    notifyListeners();
    imageFile == null;
  }
}
