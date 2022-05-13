import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_library/error/firebase_auth_exception_handler.dart';
import 'package:tech_library/error/show_error_dialog.dart';
import 'package:tech_library/main.dart';
import 'package:tech_library/domain/account.dart';
import 'package:tech_library/utils/authentication.dart';
import 'package:tech_library/utils/firestore/users.dart';
import 'package:tech_library/utils/function_utils.dart';

class RegistationButton extends StatelessWidget {
  const RegistationButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer(
      builder: (context, ref, child) {
        return GestureDetector(
          child: Center(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: size.height * 0.7),
              width: size.width * 0.7,
              height: size.height * 0.1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.lightBlue.shade100],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                'Create',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size.width * 0.05,
                ),
              ),
            ),
          ),
          onTap: () async {
            try {
              ref.read(signupProvider).checkInfo();
              var result = await Authentication.signUp(
                  email: ref.read(signupProvider).emailController.text,
                  pass: ref.read(signupProvider).passwordController.text);
              if (result is UserCredential) {
                String imagePath = await FunctionUtils.uploadImage(
                    result.user!.uid, ref.read(signupProvider).imageFile!);
                Account newAccount = Account(
                  id: result.user!.uid,
                  name: ref.read(signupProvider).nameController.text,
                  imagePath: imagePath,
                );
                await UserFirestore.setUser(newAccount);
                Navigator.pop(context);
              } else {
                final errorMessage =
                    FirebaseAuthExceptionHandler.exceptionMessage(result);
                showErrorDialog(context, errorMessage);
              }
            } catch (e) {
              showErrorDialog(context, '$e');
            }
          },
        );
      },
    );
  }
}
