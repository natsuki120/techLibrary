import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tech_library/utils/authentication.dart';
import '../../../../domain/account.dart';

class EditProfileModel extends ChangeNotifier {
  File? imageFile;
  final picker = ImagePicker();
  String? userName;
  String? userImage;

  ImageProvider getImage() {
    if (imageFile == null) {
      return NetworkImage(Authentication.myAccount!.imagePath);
    } else {
      return FileImage(imageFile!);
    }
  }

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      notifyListeners();
    }
  }

  Future update(Account editAccount) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Authentication.myAccount!.id)
        .update({
      'name': editAccount.name,
      'image_path': editAccount.imagePath,
    });
    notifyListeners();
  }
}
