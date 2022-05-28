import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_library/view_models/start_up/sign_up_model.dart';

class UserImage extends StatelessWidget {
  const UserImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: size.height * 0.15),
      child: Center(
        child: Consumer<SignUpModel>(
          builder: (context, model, child) {
            return GestureDetector(
              onTap: () {
                model.pickImage();
              },
              child: CircleAvatar(
                foregroundImage: model.imageFile == null
                    ? null
                    : FileImage(model.imageFile!),
                radius: 50,
                child: const Text(
                  '画像を選択してください',
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: Colors.grey,
              ),
            );
          },
        ),
      ),
    );
  }
}
