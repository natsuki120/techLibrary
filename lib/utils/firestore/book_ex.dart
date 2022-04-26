import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tech_library/utils/authentication.dart';

class BookFirestore {
  static final _firestoreinstance = FirebaseFirestore.instance;
  static final CollectionReference books =
      _firestoreinstance.collection('books');
  static final CollectionReference borrowedBook =
      _firestoreinstance.collection('borrowBook');

  static Future<List?> getBook(String genre) async {
    List bookList = [];
    try {
      books.where(genre).get().then((QuerySnapshot snapshot) {
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

  static Future<dynamic> borrowBook(String newBook, String bookURL) async {
    try {
      final CollectionReference _userBooks = _firestoreinstance
          .collection('users')
          .doc(Authentication.myAccount!.id)
          .collection('my_book');
      _userBooks
          .doc(newBook)
          .set({'created_time': Timestamp.now(), 'imgURL': bookURL});
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
}
