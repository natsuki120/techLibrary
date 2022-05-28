import 'dart:core';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:tech_library/models/account.dart';
import 'package:tech_library/utils/authentication.dart';
import 'package:tech_library/utils/firestore/users.dart';
import 'package:tech_library/utils/function_utils.dart';

class SignUpModel extends ChangeNotifier {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  File? imageFile;
  bool isObscure = true;

  void makeToCanSee() {
    isObscure = !isObscure;
    notifyListeners();
  }

  Future register() async {
    var result = await Authentication.signUp(
        email: emailController.text, pass: passwordController.text);
    String imagePath =
        await FunctionUtils.uploadImage(result.user!.uid, imageFile!);
    Account newAccount = Account(
      id: result.user!.uid,
      name: nameController.text,
      imagePath: imagePath,
    );
    await UserFirestore.setUser(newAccount);
    await UserFirestore.fetchUser(result.user!.uid);
  }

  void pickImage() async {
    var result = await FunctionUtils.fetchImageFromGallery();
    if (result != null) {
      imageFile = File(result.path);
      notifyListeners();
    }
  }
}
