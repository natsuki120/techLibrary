import 'package:flutter/cupertino.dart';

class SignInModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void checkInfo() {
    if (emailController.text == '') {
      throw 'メールアドレスが入力されていません';
    }
    if (passwordController.text == '') {
      throw 'パスワードが入力されていません';
    }
  }
}
