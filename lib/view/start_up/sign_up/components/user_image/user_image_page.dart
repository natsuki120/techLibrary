import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_library/view/start_up/sign_up/components/user_image/user_img_model.dart';

class UserImagePage extends StatelessWidget {
  UserImagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ChangeNotifierProvider<UserImageModel>(
      create: (_) => UserImageModel(),
      child: Container(
        margin: EdgeInsets.only(bottom: size.height * 0.15),
        child: Center(
          child: Consumer<UserImageModel>(builder: (context, model, child) {
            return GestureDetector(
              onTap: () {
                model.changeUserImage();
              },
              child: CircleAvatar(
                foregroundImage:
                    model.image == null ? null : FileImage(model.image!),
                radius: 50,
                child: const Text(
                  '画像を選択してください',
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: Colors.grey,
              ),
            );
          }),
        ),
      ),
    );
  }
}
