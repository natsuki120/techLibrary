import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tech_library/error/firebase_auth_exception_handler.dart';
import 'package:tech_library/error/show_error_dialog.dart';
import 'package:tech_library/utils/authentication.dart';
import 'package:tech_library/utils/firestore/users.dart';
import 'package:tech_library/view/my_home_page.dart';
import 'create_account_page.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // メールアドレス
  final emailKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  // パスワード
  final passKey = GlobalKey<FormState>();

  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // キーボードが出てきてもピクセルオーバーしないようにSingleChildScrollView
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // 上の背景
            Container(
              height: size.height * 0.45,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.blue, Colors.lightBlue.shade100])),
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.2,
                            width: size.width * 0.3,
                          ),
                        ],
                      )),
                  Text('TechLibrary',
                      style: TextStyle(
                          fontSize: size.height * 0.04,
                          color: Colors.white.withOpacity(0.9))),
                ],
              ),
            ),

            // 情報入力欄のレイアウト
            Column(
              children: [
                Stack(
                  children: [
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: size.height * 0.35),
                        width: size.width * 0.9,
                        height: size.height * 0.35,
                        //情報入力欄
                        child: Card(
                          child: Column(
                            children: [
                              //名前入力欄
                              Form(
                                key: emailKey,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 40, right: 40, top: 30),
                                  child: TextFormField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      hintText: 'メールアドレス',
                                      hintStyle: TextStyle(
                                          color: Colors.black.withOpacity(0.2)),
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
                                  margin: const EdgeInsets.only(
                                      left: 40, right: 40, top: 20),
                                  child: TextFormField(
                                    controller: passController,
                                    decoration: InputDecoration(
                                      hintText: 'パスワード',
                                      hintStyle: TextStyle(
                                          color: Colors.black.withOpacity(0.2)),
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
                          margin: EdgeInsets.only(top: size.height * 0.65),
                          width: size.width * 0.7,
                          height: size.height * 0.1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Colors.blue,
                              Colors.lightBlue.shade100
                            ]),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: size.width * 0.05),
                          ),
                        ),
                      ),
                      onTap: () async {
                        EasyLoading.show(status: 'loading...');
                        if (emailKey.currentState!.validate() &&
                            passKey.currentState!.validate()) {
                          var result = await Authentication.emailSignIn(
                              email: emailController.text,
                              pass: passController.text);
                          if (result is UserCredential) {
                            var _result =
                                await UserFirestore.getUser(result.user!.uid);
                            EasyLoading.showSuccess('Success!');
                            EasyLoading.dismiss();
                            if (_result == true) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MyHomePage()));
                            }
                          } else {
                            EasyLoading.dismiss();
                            final errorMessage =
                                FirebaseAuthExceptionHandler.exceptionMessage(
                                    result);
                            showErrorDialog(context, errorMessage);
                          }
                        }
                      },
                    ),
                  ],
                ),

                // 新規登録の誘導
                Container(
                  margin: EdgeInsets.only(top: size.height * 0.05),
                  child: RichText(
                    text: TextSpan(
                        style: const TextStyle(color: Colors.black),
                        children: [
                          const TextSpan(
                              text: '新規登録は',
                              style: TextStyle(color: Colors.grey)),
                          TextSpan(
                              text: 'こちら',
                              style: const TextStyle(color: Colors.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const CreateAccountPage()));
                                })
                        ]),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
