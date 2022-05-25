import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tech_library/models/book.dart';
import 'package:tech_library/utils/authentication.dart';

class BookFirestore {
  static final _firestoreinstance = FirebaseFirestore.instance;
  static final CollectionReference bookCollection =
      _firestoreinstance.collection('book');
  static final CollectionReference borrowBookCollection =
      _firestoreinstance.collection('borrowBook');

  static Future<dynamic> fetchFavoriteBook(Book favoriteBook) async {
    try {
      final CollectionReference favorite = _firestoreinstance
          .collection('users')
          .doc(Authentication.myAccount!.id)
          .collection('favorite');
      favorite.doc(favoriteBook.id).set({
        'imgURL': favoriteBook.imgURL,
        'created_time': Timestamp.now(),
        'title': favoriteBook.title,
        'author': favoriteBook.author,
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

  static Future<dynamic> borrowBook(Book borrowBook) async {
    try {
      final CollectionReference _userBooks = _firestoreinstance
          .collection('users')
          .doc(Authentication.myAccount!.id)
          .collection('my_book');
      _userBooks.doc(borrowBook.id).set({
        'created_time': Timestamp.now(),
        'imgURL': borrowBook.imgURL,
        'title': borrowBook.title,
        'author': borrowBook.author,
      });
      borrowBookCollection
          .doc(borrowBook.id)
          .set({'created_time': Timestamp.now()});
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
      borrowBookCollection.doc(returnBook).delete();
      print('返却完了');
      return true;
    } on FirebaseException catch (e) {
      print('返却エラー：　$e');
      return false;
    }
  }
}
