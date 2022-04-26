import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:tech_library/utils/authentication.dart';
import '../../../../model/account.dart';
import '../../../../model/book.dart';

class AccountModel extends ChangeNotifier {
  Account? usersInfo;
  List<Book>? usersBook;
  List<Book>? usersFavoriteBook;
  static final _firestoreInstance = FirebaseFirestore.instance;

  // ユーザー情報の取得
  Stream<DocumentSnapshot<Map<String, dynamic>>> myAccount = _firestoreInstance
      .collection('users')
      .doc(Authentication.myAccount!.id)
      .snapshots();

  // ユーザーが借りている本の取得
  static Stream<QuerySnapshot<Map<String, dynamic>>> myBook = _firestoreInstance
      .collection('users')
      .doc(Authentication.myAccount!.id)
      .collection('my_book')
      .snapshots();

  // ユーザーのお気に入り本の取得
  final Stream<QuerySnapshot<Map<String, dynamic>>> myFavoriteBook =
      _firestoreInstance
          .collection('users')
          .doc(Authentication.myAccount!.id)
          .collection('favorite')
          .snapshots();

  void getMyAccount() async {
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
    myFavoriteBook.listen((QuerySnapshot snapshot) {
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
}
