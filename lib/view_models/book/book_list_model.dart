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

  void fetchBook() {
    final Stream<QuerySnapshot> snapshots =
        _firestoreInstance.collection('book').snapshots();

    snapshots.listen((QuerySnapshot snapshot) {
      final books = snapshot.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        return Book(
            id: document.id, title: data['title'], imgURL: data['imgURL']);
      }).toList();
      this.books = books;
    });
  }

  void fetchGenreBook(String genre) {
    final Stream<QuerySnapshot> snapshots = _firestoreInstance
        .collection('book')
        .where('genre', isEqualTo: genre)
        .snapshots();

    snapshots.listen((QuerySnapshot snapshot) {
      final List<Book> genreBooks =
          snapshot.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        return Book(
          id: document.id,
          title: data['title'],
          imgURL: data['imgURL'],
        );
      }).toList();
      this.genreBooks = genreBooks;
      notifyListeners();
    });
  }

  void fetchBorrowBook() {
    final Stream<QuerySnapshot> snapshots =
        FirebaseFirestore.instance.collection('borrowBook').snapshots();

    snapshots.listen((QuerySnapshot snapshot) {
      borrowBooks.clear();
      snapshot.docs.map((DocumentSnapshot doc) {
        borrowBooks.add(doc.id);
        return borrowBooks;
      }).toList();
      notifyListeners();
    });
  }

  void fetchFavoriteBook() {
    final Stream<QuerySnapshot> snapshots = _firestoreInstance
        .collection('users')
        .doc(Authentication.myAccount!.id)
        .collection('favorite')
        .snapshots();

    snapshots.listen((QuerySnapshot snapshot) {
      favoriteBooks.clear();
      snapshot.docs.map((DocumentSnapshot doc) {
        favoriteBooks.add(doc.id);
        return favoriteBooks;
      }).toList();
      notifyListeners();
    });
  }

  // 参照先にfetchBorrowBookがあるため、AccountModelではなくBookListModel内に記述
  void fetchMyFavoriteBook() {
    final Stream<QuerySnapshot> snapshots = _firestoreInstance
        .collection('users')
        .doc(Authentication.myAccount!.id)
        .collection('favorite')
        .snapshots();

    snapshots.listen((QuerySnapshot snapshot) {
      final usersFavoriteBook = snapshot.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        return Book(
          id: document.id,
          title: data['title'],
          imgURL: data['imgURL'],
        );
      }).toList();
      this.usersFavoriteBook = usersFavoriteBook;
      notifyListeners();
    });
  }
}
