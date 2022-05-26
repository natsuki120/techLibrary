import 'package:firebase_auth/firebase_auth.dart';
import 'package:tech_library/models/account.dart';
import 'package:tech_library/models/book.dart';

class Authentication {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static Account? myAccount;
  static Book? selectedBook;
  static User? currentFirebaseUser;

  static Future<dynamic> signUp(
      {required String email, required String pass}) async {
    UserCredential newAccount = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: pass);
    return newAccount;
  }

  static Future<dynamic> emailSignIn(
      {required String email, required String pass}) async {
    final UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: pass);
    currentFirebaseUser = userCredential.user;
    return userCredential;
  }
}
