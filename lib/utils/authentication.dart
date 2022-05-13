import 'package:firebase_auth/firebase_auth.dart';
import 'package:tech_library/error/firebase_auth_exception_handler.dart';
import 'package:tech_library/error/firebase_auth_result_status.dart';
import 'package:tech_library/domain/account.dart';
import 'package:tech_library/domain/book.dart';

class Authentication {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static Account? myAccount;
  static Book? selectedBook;
  static User? currentFirebaseUser;

  static Future<dynamic> signUp(
      {required String email, required String pass}) async {
    FirebaseAuthResultStatus _result;
    try {
      UserCredential newAccount = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: pass);
      print('新規登録が完了しました');
      return newAccount;
    } on FirebaseAuthException catch (e) {
      print('新規登録エラー： $e');
      _result = FirebaseAuthExceptionHandler.handleException(e);
      return _result;
    }
  }

  static Future<dynamic> emailSignIn(
      {required String email, required String pass}) async {
    FirebaseAuthResultStatus _result;
    try {
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: pass);
      currentFirebaseUser = userCredential.user;
      print('サインイン完了');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('サインインエラー: $e');
      _result = FirebaseAuthExceptionHandler.handleException(e);
      return _result;
    }
  }
}
