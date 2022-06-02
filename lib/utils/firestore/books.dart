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
    final CollectionReference favorite = _firestoreinstance
        .collection('users')
        .doc(Authentication.myAccount!.id)
        .collection('favorite');
    favorite.doc(favoriteBook.id).set({
      'imgURL': favoriteBook.imgURL,
      'created_time': Timestamp.now(),
      'title': favoriteBook.title,
    });
  }

  static Future<dynamic> removeFavoriteBook(String favoriteBook) async {
    final CollectionReference favorite = _firestoreinstance
        .collection('users')
        .doc(Authentication.myAccount!.id)
        .collection('favorite');
    favorite.doc(favoriteBook).delete();
  }

  static Future<dynamic> borrowBook(Book borrowBook) async {
    final CollectionReference _userBooks = _firestoreinstance
        .collection('users')
        .doc(Authentication.myAccount!.id)
        .collection('my_book');
    _userBooks.doc(borrowBook.id).set({
      'created_time': Timestamp.now(),
      'imgURL': borrowBook.imgURL,
      'title': borrowBook.title,
    });
    borrowBookCollection
        .doc(borrowBook.id)
        .set({'created_time': Timestamp.now()});
  }

  static Future<dynamic> returnMyBook(String returnBook) async {
    final DocumentReference<Map<String, dynamic>> _userBooks =
        _firestoreinstance
            .collection('users')
            .doc(Authentication.myAccount!.id)
            .collection('my_book')
            .doc(returnBook);
    _userBooks.delete();
    borrowBookCollection.doc(returnBook).delete();
  }
}
