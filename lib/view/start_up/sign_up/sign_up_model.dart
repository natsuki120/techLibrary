import 'dart:core';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:tech_library/utils/function_utils.dart';

class SignUpModel extends ChangeNotifier {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  File? imageFile;

  void checkInfo() {
    if (nameController.text == '') {
      throw '名前が入力されていません';
    }
    if (emailController.text == '') {
      throw 'メールアドレスが入力されていません';
    }
    if (passwordController.text == '') {
      throw 'パスワードが入力されていません';
    }
    if (imageFile == null) {
      throw '画像を選択してください';
    }
  }

  void pickImage() async {
    var result = await FunctionUtils.getImageFromCamera();
    if (result != null) {
      imageFile = File(result.path);
      notifyListeners();
    }
  }
}
