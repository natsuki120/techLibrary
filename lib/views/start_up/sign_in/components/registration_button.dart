import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:tech_library/error/firebase_auth_exception_handler.dart';
import 'package:tech_library/error/show_error_dialog.dart';
import 'package:tech_library/view_models/start_up/sign_in_model.dart';
import 'package:tech_library/my_home_page.dart';

class RegistrationButton extends StatelessWidget {
  const RegistrationButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<SignInModel>(builder: (context, model, child) {
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
            EasyLoading.show(status: 'loading...');
            await model.login();
            EasyLoading.showSuccess('Success!');
            EasyLoading.dismiss();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MyHomePage(),
              ),
            );
          } on FirebaseAuthException catch (e) {
            EasyLoading.dismiss();
            var result = FirebaseAuthExceptionHandler.handleException(e);
            showErrorDialog(context, result);
          }
        },
      );
    });
  }
}
