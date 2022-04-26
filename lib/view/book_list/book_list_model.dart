import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tech_library/utils/authentication.dart';

import '../../model/book.dart';

class BookListModel extends ChangeNotifier {
  List<Book>? bookList = [];
  List borrowBooks = [];
  List borrowMyBooks = [];
  List favoriteBooks = [];
  List lendableBooks = [];

  void fetchBookList(String title) async {
    Stream<QuerySnapshot> book = FirebaseFirestore.instance
        .collection('users')
        .where('title', isEqualTo: title)
        .snapshots();
    book.listen((QuerySnapshot snapshot) {
      final bookList = snapshot.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        return Book(
          id: document.id,
          title: data['name'],
          imagePath: data['image_path'],
        );
      }).toList();
      this.bookList = bookList;
      notifyListeners();
    });
  }

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
