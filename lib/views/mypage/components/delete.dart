import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:tech_library/error/firebase_auth_exception_handler.dart';
import 'package:tech_library/error/show_error_dialog.dart';
import 'package:tech_library/utils/authentication.dart';
import 'package:tech_library/utils/firestore/users.dart';
import '../../start_up/sign_in/sign_in_page.dart';

class Delete extends StatelessWidget {
  const Delete({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: NewGradientAppBar(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.lightBlue.shade200],
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.2,
            ),
            Container(
              alignment: Alignment.center,
              width: size.width * 0.7,
              child: Wrap(
                children: const [
                  Text('確認のため、メールアドレスとパスワードを入力してください'),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: size.width * 0.1),
              child: TextFormField(
                controller: Authentication.emailController,
                decoration: InputDecoration(
                  hintText: 'メールアドレス',
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.2),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: size.width * 0.1),
              child: TextFormField(
                controller: Authentication.passwordController,
                decoration: InputDecoration(
                  hintText: 'パスワード',
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.2),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      content: const Text("退会します。よろしいですか？"),
                      actions: <Widget>[
                        TextButton(
                          child: const Text("Cancel"),
                          onPressed: () => Navigator.pop(context),
                        ),
                        TextButton(
                          child: const Text("OK"),
                          onPressed: () async {
                            try {
                              EasyLoading.show(status: 'Loading...');
                              await Authentication.signOut();
                              await UserFirestore.deleteUser();
                              EasyLoading.showSuccess('退会しました');
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => const SignInPage(),
                                ),
                                (route) => false,
                              );
                            } on FirebaseAuthException catch (e) {
                              Navigator.pop(context);
                              EasyLoading.dismiss();
                              var result =
                                  FirebaseAuthExceptionHandler.handleException(
                                      e);
                              showErrorDialog(context, result);
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: size.height * 0.05),
                width: size.width * 0.4,
                height: size.height * 0.06,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.lightBlue.shade100],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  '退会する',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size.width * 0.04,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
