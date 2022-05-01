import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../../error/firebase_auth_exception_handler.dart';
import '../../../../error/show_error_dialog.dart';
import '../../../../utils/authentication.dart';
import '../../../../utils/firestore/users.dart';
import '../../../my_home_page.dart';

class CustomCard extends StatefulWidget {
  const CustomCard({Key? key}) : super(key: key);

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  // メールアドレス
  final emailKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  // パスワード
  final passKey = GlobalKey<FormState>();

  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Center(
          child: Container(
            margin: EdgeInsets.only(top: size.height * 0.35),
            width: size.width * 0.9,
            height: size.height * 0.3,
            //情報入力欄
            child: Card(
              child: Column(
                children: [
                  //名前入力欄
                  Form(
                    key: emailKey,
                    child: Container(
                      margin: EdgeInsets.only(
                        left: size.width * 0.1,
                        right: size.width * 0.1,
                        top: size.height * 0.04,
                      ),
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'メールアドレス',
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '入力してください';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  //パスワード入力欄
                  Form(
                    key: passKey,
                    child: Container(
                      margin: EdgeInsets.only(
                        left: size.width * 0.1,
                        right: size.width * 0.1,
                        top: size.height * 0.03,
                      ),
                      child: TextFormField(
                        controller: passController,
                        decoration: InputDecoration(
                          hintText: 'パスワード',
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '入力してください';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // サインインボタン
        GestureDetector(
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
            if (emailKey.currentState!.validate() &&
                passKey.currentState!.validate()) {
              EasyLoading.show(status: 'loading...');
              var result = await Authentication.emailSignIn(
                email: emailController.text,
                pass: passController.text,
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
            }
          },
        ),
      ],
    );
  }
}
