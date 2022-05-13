import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../domain/book.dart';

class SearchModel extends ChangeNotifier {
  String text = '';
  var searchList = [];
  var searchBookList = [];
  var searchResultList = [];

  //　isEqualtoクエリだと部分一致ができない
  // seachListはキャッシュする

  void fetchBookName() {
    FirebaseFirestore.instance
        .collection('book')
        .get()
        .then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        searchBookList.add(doc.get('title'));
      }
    });
  }

  void searchBookName(String bookName) async {
    Stream<QuerySnapshot<Map<String, dynamic>>> snapshot = FirebaseFirestore
        .instance
        .collection('book')
        .where('title', isEqualTo: bookName)
        .snapshots();

    snapshot.listen((QuerySnapshot snapshot) {
      final searchBookList = snapshot.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        return Book(
            id: document.id,
            title: data['title'],
            author: data['author'],
            imgURL: data['imgURL']);
      }).toList();
      this.searchBookList = searchBookList;
      notifyListeners();
    });
  }
}
