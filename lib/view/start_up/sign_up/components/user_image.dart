import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_library/main.dart';

class UserImage extends StatelessWidget {
  const UserImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: size.height * 0.15),
      child: Center(
        child: Consumer(
          builder: (context, ref, child) {
            return GestureDetector(
              onTap: () {
                ref.watch(signupProvider).pickImage();
              },
              child: CircleAvatar(
                foregroundImage: ref.watch(signupProvider).imageFile == null
                    ? null
                    : FileImage(ref.watch(signupProvider).imageFile!),
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
