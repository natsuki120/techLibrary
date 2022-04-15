import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tech_library/utils/authentication.dart';

class BookListModel extends ChangeNotifier {
  List borrowBooks = [];
  List borrowMyBooks = [];
  List favoriteBooks = [];
  List lendableBooks = [];

  void fetchBorrowBookList() async {
    // 貸出中の本の取得、更新
    Stream<QuerySnapshot> borrowBook =
        FirebaseFirestore.instance.collection('borrowBook').snapshots();
    borrowBook.listen((QuerySnapshot snap) {
      borrowBooks.clear();
      final borrowBookCollection = snap.docs.map((DocumentSnapshot doc) {
        borrowBooks.add(doc.id);
        return borrowBooks;
      });
      print(borrowBookCollection);
      notifyListeners();
    });
  }

  void fetchFavoriteBookList() async {
    // お気に入り本の取得、更新
    Stream<QuerySnapshot> favorite = FirebaseFirestore.instance
        .collection('users')
        .doc(Authentication.myAccount!.id)
        .collection('favorite')
        .snapshots();
    favorite.listen((QuerySnapshot snap) {
      favoriteBooks.clear();
      final favoriteBookCollection = snap.docs.map((DocumentSnapshot doc) {
        favoriteBooks.add(doc.id);
        return favoriteBooks;
      });
      print(favoriteBookCollection);
      notifyListeners();
    });
  }
}
