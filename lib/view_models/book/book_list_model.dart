import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:tech_library/models/book.dart';
import 'package:tech_library/utils/authentication.dart';

class BookListModel extends ChangeNotifier {
  List<Book> books = [];
  List borrowBooks = [];
  List favoriteBooks = [];
  List<Book> genreBooks = [];
  List<Book> usersFavoriteBook = [];
  static final _firestoreInstance = FirebaseFirestore.instance;

  void fetchBook() async {
    final QuerySnapshot snapshot =
        await _firestoreInstance.collection('book').get();

    final books = snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      return Book(
          id: document.id, title: data['title'], imgURL: data['imgURL']);
    }).toList();
    this.books = books;
  }

  void fetchGenreBook(String genre) async {
    final QuerySnapshot snapshot = await _firestoreInstance
        .collection('book')
        .where('genre', isEqualTo: genre)
        .get();

    final List<Book> genreBooks =
        snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      return Book(
          id: document.id,
          title: data['title'],
          author: data['author'],
          imgURL: data['imgURL']);
    }).toList();
    this.genreBooks = genreBooks;
    notifyListeners();
  }

  void fetchBorrowBook() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('borrowBook').get();
    borrowBooks.clear();
    snapshot.docs.map((DocumentSnapshot doc) {
      borrowBooks.add(doc.id);
      return borrowBooks;
    }).toList();
    notifyListeners();
  }

  void fetchFavoriteBook() async {
    final QuerySnapshot snapshot = await _firestoreInstance
        .collection('users')
        .doc(Authentication.myAccount!.id)
        .collection('favorite')
        .get();
    favoriteBooks.clear();
    snapshot.docs.map((DocumentSnapshot doc) {
      favoriteBooks.add(doc.id);
      return favoriteBooks;
    }).toList();
    notifyListeners();
  }

  // 参照先にfetchBorrowBookがあるため、AccountModelではなくBookListModel内に記述
  void fetchMyFavoriteBook() async {
    final QuerySnapshot snapshot = await _firestoreInstance
        .collection('users')
        .doc(Authentication.myAccount!.id)
        .collection('favorite')
        .get();
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
  }
}
