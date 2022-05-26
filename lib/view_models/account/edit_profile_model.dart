import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tech_library/models/account.dart';
import 'package:tech_library/utils/authentication.dart';
import 'package:tech_library/utils/function_utils.dart';

class EditProfileModel extends ChangeNotifier {
  File? imageFile;
  final picker = ImagePicker();
  String? userName;
  String? userImage;
  Account? usersInfo;
  final nameKey = GlobalKey<FormState>();
  TextEditingController nameController =
      TextEditingController(text: Authentication.myAccount!.name);
  static final _firestoreInstance = FirebaseFirestore.instance;

  void getMyAccount() async {
    Stream<DocumentSnapshot<Map<String, dynamic>>> myAccount =
        _firestoreInstance
            .collection('users')
            .doc(Authentication.myAccount!.id)
            .snapshots();

    myAccount.listen((DocumentSnapshot snapshot) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      Account usersInfo = Account(
        name: data['name'],
        imagePath: data['image_path'],
      );
      this.usersInfo = usersInfo;
      notifyListeners();
    });
  }

  ImageProvider fetchImage() {
    if (imageFile == null) {
      return NetworkImage(usersInfo!.imagePath);
    } else {
      return FileImage(imageFile!);
    }
  }

  Future pickImage() async {
    final pickedFile = await FunctionUtils.fetchImageFromGallery();
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
    }
    notifyListeners();
  }

  Future update() async {
    String imagePath = '';
    if (imageFile == null) {
      imagePath = Authentication.myAccount!.imagePath;
    } else {
      var result = await FunctionUtils.uploadImage(
          Authentication.myAccount!.id, imageFile!);
      imagePath = result;
    }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Authentication.myAccount!.id)
        .update({
      'name': nameController.text,
      'image_path': imagePath,
    });
    Authentication.myAccount!.name = nameController.text;
    notifyListeners();
  }
}
