import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthExceptionHandler {
  static String handleException(FirebaseAuthException e) {
    String? result;
    switch (e.code) {
      case 'invalid-email':
        result = 'メールアドレスが不正です。';
        break;
      case 'wrong-password':
        result = 'パスワードが違います';
        break;
      case 'weak-password':
        result = 'パスワードは6文字以上を入力してください';
        break;
      case 'user-not-found':
        result = '指定されたユーザーは存在しません。';
        break;
      case 'user-disabled':
        result = '指定されたユーザーは無効です。';
        break;
      case 'email-already-in-use':
        result = '指定されたメールアドレスは既に使用されています。';
        break;
      default:
        result = '全て入力してください。';
        break;
    }
    return result;
  }
}
