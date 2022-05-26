import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:tech_library/models/book.dart';
import 'package:tech_library/utils/authentication.dart';

class BookListModel extends ChangeNotifier {
  List<Book> books = [];
  List borrowBooks = [];
  List favoriteBooks = [];
  List<Book> genreBooks = [];
  List<Book>? usersFavoriteBook = [];
  static final _firestoreInstance = FirebaseFirestore.instance;

  void fetchBook() async {
    Stream<QuerySnapshot<Map<String, dynamic>>> books =
        _firestoreInstance.collection('book').snapshots();

    books.listen((QuerySnapshot snapshot) {
      final books = snapshot.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        return Book(
            id: document.id, title: data['title'], imgURL: data['imgURL']);
      }).toList();
      this.books = books;
    });
  }

  void fetchGenreBook(String genre) async {
    Stream<QuerySnapshot<Map<String, dynamic>>> genreBooks = _firestoreInstance
        .collection('book')
        .where('genre', isEqualTo: genre)
        .snapshots();

    genreBooks.listen((QuerySnapshot snapshot) {
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

  void fetchBorrowBookList() async {
    Stream<QuerySnapshot> borrowBook =
        FirebaseFirestore.instance.collection('borrowBook').snapshots();
    borrowBook.listen((QuerySnapshot snap) {
      borrowBooks.clear();
      final borrowBookCollection = snap.docs.map((DocumentSnapshot doc) {
        borrowBooks.add(doc.id);
        return borrowBooks;
      });
      if (kDebugMode) {
        print(borrowBookCollection);
      }
      notifyListeners();
    });
  }

  void fetchFavoriteBookList() async {
    // お気に入り本の取得、更新
    Stream<QuerySnapshot<Map<String, dynamic>>> favoriteBookList =
        _firestoreInstance
            .collection('users')
            .doc(Authentication.myAccount!.id)
            .collection('favorite')
            .snapshots();
    favoriteBookList.listen((QuerySnapshot snap) {
      favoriteBooks.clear();
      final favoriteBookCollection = snap.docs.map((DocumentSnapshot doc) {
        favoriteBooks.add(doc.id);
        return favoriteBooks;
      });
      if (kDebugMode) {
        print(favoriteBookCollection);
      }
      notifyListeners();
    });
  }

  void fetchMyFavoriteBook() async {
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
}
