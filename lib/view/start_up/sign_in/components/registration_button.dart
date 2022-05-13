import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_library/error/firebase_auth_exception_handler.dart';
import 'package:tech_library/error/show_error_dialog.dart';
import 'package:tech_library/main.dart';
import 'package:tech_library/utils/authentication.dart';
import 'package:tech_library/utils/firestore/users.dart';
import 'package:tech_library/view/my_home_page.dart';

class RegistrationButton extends StatelessWidget {
  const RegistrationButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer(builder: (context, ref, child) {
      return GestureDetector(
        child: Center(
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: size.height * 0.6),
            width: size.width * 0.7,
            height: size.height * 0.1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.lightBlue.shade100],
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              'Sign In',
              style: TextStyle(
                color: Colors.white,
                fontSize: size.width * 0.05,
              ),
            ),
          ),
        ),
        onTap: () async {
          try {
            ref.read(signinProvider).checkInfo();
            EasyLoading.show(status: 'loading...');
            var result = await Authentication.emailSignIn(
              email: ref.read(signinProvider).emailController.text,
              pass: ref.read(signinProvider).passwordController.text,
            );
            if (result is UserCredential) {
              var _result = await UserFirestore.getUser(result.user!.uid);
              EasyLoading.showSuccess('Success!');
              EasyLoading.dismiss();
              if (_result == true) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyHomePage(),
                  ),
                );
              }
            } else {
              EasyLoading.dismiss();
              final errorMessage =
                  FirebaseAuthExceptionHandler.exceptionMessage(result);
              showErrorDialog(context, errorMessage);
            }
          } catch (e) {
            EasyLoading.dismiss();
            showErrorDialog(context, '$e');
          }
        },
      );
    });
  }
}
