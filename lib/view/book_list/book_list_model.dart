import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tech_library/utils/authentication.dart';
import '../../domain/book.dart';

class BookListModel extends ChangeNotifier {
  List books = [];
  List genreBooks = [];

  void fetchBook(String genre) async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('book')
        .where('genre', isEqualTo: genre)
        .get();

    final List<Book> books = snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      final String id = document.id;
      final String title = data['title'];
      final String author = data['author'];
      final String imgURL = data['imgURL'];
      return Book(id: id, title: title, author: author, imgURL: imgURL);
    }).toList();
    this.books = books;
    notifyListeners();
  }

  void fetchGenreBook(String collection, String genre) async {
    Stream<QuerySnapshot<Map<String, dynamic>>> genreBook = FirebaseFirestore
        .instance
        .collection(collection)
        .where('genre', isEqualTo: genre)
        .snapshots();

    genreBook.listen((QuerySnapshot snapshot) {
      final genreBooks = snapshot.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        return Book(
            id: document.id,
            title: data['title'],
            author: data['author'],
            imgURL: data['imgURL']);
      }).toList();
      this.genreBooks = genreBooks;
      notifyListeners();
    });
  }
}
