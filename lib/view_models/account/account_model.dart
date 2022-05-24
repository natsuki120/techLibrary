import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tech_library/models/account.dart';
import 'package:tech_library/models/book.dart';
import 'package:tech_library/utils/authentication.dart';

class AccountModel extends ChangeNotifier {
  Account? usersInfo;
  List<Book>? usersBook;
  List usersFavoriteBook = [];
  static final _firestoreInstance = FirebaseFirestore.instance;
  File? imageFile;
  final picker = ImagePicker();
  String? userName;
  String? userImage;

  void getMyAccount() async {
    Stream<DocumentSnapshot<Map<String, dynamic>>> myAccount =
        _firestoreInstance
            .collection('users')
            .doc(Authentication.myAccount!.id)
            .snapshots();

    myAccount.listen((DocumentSnapshot snapshot) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      Account usersInfo = Account(
        name: data['name'],
        imagePath: data['image_path'],
      );
      this.usersInfo = usersInfo;
      notifyListeners();
    });
  }

  void getMyBook() async {
    Stream<QuerySnapshot<Map<String, dynamic>>> myBook = _firestoreInstance
        .collection('users')
        .doc(Authentication.myAccount!.id)
        .collection('my_book')
        .snapshots();

    myBook.listen((QuerySnapshot snapshot) {
      final usersBook = snapshot.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        return Book(
            id: document.id,
            title: data['title'],
            author: data['author'],
            imgURL: data['imgURL']);
      }).toList();
      this.usersBook = usersBook;
      notifyListeners();
    });
  }

  void getMyFavoriteBook() async {
    final Stream<QuerySnapshot<Map<String, dynamic>>> usersFavoriteBook =
        _firestoreInstance
            .collection('users')
            .doc(Authentication.myAccount!.id)
            .collection('favorite')
            .snapshots();
    usersFavoriteBook.listen((QuerySnapshot snapshot) {
      final usersFavoriteBook = snapshot.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        return Book(
            id: document.id,
            title: data['title'],
            author: data['author'],
            imgURL: data['imgURL']);
      }).toList();
      this.usersFavoriteBook = usersFavoriteBook;
      notifyListeners();
    });
  }

  ImageProvider getImage() {
    if (imageFile == null) {
      return NetworkImage(Authentication.myAccount!.imagePath);
    } else {
      return FileImage(imageFile!);
    }
  }

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      notifyListeners();
    }
  }

  Future update(Account editAccount) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Authentication.myAccount!.id)
        .update({
      'name': editAccount.name,
      'image_path': editAccount.imagePath,
    });
    notifyListeners();
  }
}
