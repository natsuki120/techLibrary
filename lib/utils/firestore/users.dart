import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tech_library/domain/account.dart';
import 'package:tech_library/domain/book.dart';
import '../authentication.dart';

class UserFirestore {
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference users =
      _firestoreInstance.collection('users');
  static final CollectionReference borrowAccount =
      _firestoreInstance.collection('borrowAccount');

  static Future<dynamic> setUser(Account newAccount) async {
    try {
      await users.doc(newAccount.id).set({
        'name': newAccount.name,
        'image_path': newAccount.imagePath,
      });
      print('新規ユーザー作成完了');
      return true;
    } on FirebaseException catch (e) {
      print('新規ユーザー作成エラー: $e');
      return false;
    }
  }

  static Future<dynamic> getUser(String uid) async {
    try {
      DocumentSnapshot documentSnapshot = await users.doc(uid).get();
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      Account myAccount = Account(
        id: uid,
        name: data['name'],
        imagePath: data['image_path'],
      );
      Authentication.myAccount = myAccount;
      print('ユーザー取得完了');
      return true;
    } on FirebaseException catch (e) {
      print('ユーザー取得エラー: $e');
      return false;
    }
  }

  static Future<dynamic> getBook(String uid) async {
    try {
      Book selectedBook = Book(
        id: uid,
      );
      Authentication.selectedBook = selectedBook;
      print('ユーザー取得完了');
      return true;
    } on FirebaseException catch (e) {
      print('ユーザー取得エラー: $e');
      return false;
    }
  }

  static Future<List?> getMyBook() async {
    List myBookList = [];
    try {
      users
          .doc(Authentication.myAccount!.id)
          .collection('my_book')
          .get()
          .then((QuerySnapshot snapshot) {
        for (var doc in snapshot.docs) {
          myBookList.add(doc.id);
        }
      });
      print('本の情報取得完了');
      return myBookList;
    } on FirebaseException catch (e) {
      print('本の情報取得エラー: $e');
      return null;
    }
  }

  static Future<dynamic> addUser() async {
    try {
      await borrowAccount.doc(Authentication.myAccount!.id).set({
        'created_time': Timestamp.now(),
      });
      print('貸出完了');
      return true;
    } on FirebaseException catch (e) {
      print('貸出エラー： $e');
      return false;
    }
  }

  static Future<dynamic> editUser(String editName, String editImgUrl) async {
    try {
      await users.doc(Authentication.myAccount!.id).update({
        'name': editName,
        'image_path': editImgUrl,
      });
      print('ユーザー編集完了');
      return true;
    } on FirebaseException catch (e) {
      print('ユーザー編集エラー: $e');
      return false;
    }
  }
}
