import 'package:flutter/cupertino.dart';
import 'package:tech_library/utils/authentication.dart';
import 'package:tech_library/utils/firestore/users.dart';

class SignInModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isObscure = true;

  void makeToCanSee() {
    isObscure = !isObscure;
    notifyListeners();
  }

  Future login() async {
    var result = await Authentication.emailSignIn(
        email: emailController.text, pass: passwordController.text);
    await UserFirestore.fetchUser(result.user!.uid);
  }
}
