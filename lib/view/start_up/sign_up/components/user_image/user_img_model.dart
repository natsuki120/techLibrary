import 'dart:io';
import 'package:flutter/cupertino.dart';
import '../../../../../utils/function_utils.dart';

class UserImageModel extends ChangeNotifier {
  File? image;

  void changeUserImage() async {
    var result = await FunctionUtils.getImageFromCamera();
    if (result != null) {
      image = File(result.path);
      notifyListeners();
    }
  }
}
