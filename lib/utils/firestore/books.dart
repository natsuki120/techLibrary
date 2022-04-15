import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tech_library/utils/authentication.dart';

class BookFirestore {
  static final _firestoreinstance = FirebaseFirestore.instance;
  static final CollectionReference book = _firestoreinstance.collection('book');
  static final CollectionReference borrowedBook =
      _firestoreinstance.collection('borrowBook');

  static Future<List?> getBook(String genre) async {
    List bookList = [];
    try {
      book.where(genre).get().then((QuerySnapshot snapshot) {
        snapshot.docs.forEach((doc) {
          bookList.add(doc.id);
        });
      });
      print('本の情報取得完了');
      return bookList;
    } on FirebaseException catch (e) {
      print('本の情報取得エラー: $e');
      return null;
    }
  }

  static Future<dynamic> getFavoriteBook(
      String favoriteBook, String imgURL, String bookName) async {
    try {
      final CollectionReference favorite = _firestoreinstance
          .collection('users')
          .doc(Authentication.myAccount!.id)
          .collection('favorite');
      favorite.doc(favoriteBook).set({
        'imgURL': imgURL,
        'created_time': Timestamp.now(),
        'name': bookName,
      });
      print('お気に入り登録完了');
      return true;
    } on FirebaseException catch (e) {
      print('お気に入り登録エラー：　$e');
      return false;
    }
  }

  static Future<dynamic> removeFavoriteBook(String favoriteBook) async {
    try {
      final CollectionReference favorite = _firestoreinstance
          .collection('users')
          .doc(Authentication.myAccount!.id)
          .collection('favorite');
      favorite.doc(favoriteBook).delete();
      print('お気に入り削除完了');
      return true;
    } on FirebaseException catch (e) {
      print('お気に入り削除エラー：　$e');
      return false;
    }
  }

  static Future<dynamic> borrowBook(
      String newBook, String bookURL, String bookName) async {
    try {
      final CollectionReference _userBooks = _firestoreinstance
          .collection('users')
          .doc(Authentication.myAccount!.id)
          .collection('my_book');
      _userBooks.doc(newBook).set({
        'created_time': Timestamp.now(),
        'imgURL': bookURL,
        'name': bookName
      });
      borrowedBook.doc(newBook).set({'created_time': Timestamp.now()});
      print('貸出完了');
      return true;
    } on FirebaseException catch (e) {
      print('貸出エラー：　$e');
      return false;
    }
  }

  static Future<dynamic> returnMyBook(String returnBook) async {
    try {
      final DocumentReference<Map<String, dynamic>> _userBooks =
          _firestoreinstance
              .collection('users')
              .doc(Authentication.myAccount!.id)
              .collection('my_book')
              .doc(returnBook);
      _userBooks.delete();
      borrowedBook.doc(returnBook).delete();
      print('返却完了');
      return true;
    } on FirebaseException catch (e) {
      print('返却エラー：　$e');
      return false;
    }
  }

  static Future<dynamic> searchBook(String searchBook) async {
    // 書き方あってる？
    try {
      var findBook = book.where((book) => book['name'].contains(searchBook));
      return findBook;
    } on FirebaseException catch (e) {
      print('検索エラー：　$e');
      return null;
    }
  }
}
