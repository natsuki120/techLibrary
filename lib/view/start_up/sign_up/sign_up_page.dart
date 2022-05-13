import 'package:flutter/material.dart';
import 'package:tech_library/view/start_up/sign_up/components/registration.dart';
import 'package:tech_library/view/start_up/sign_up/components/registration_button.dart';
import 'package:tech_library/view/start_up/sign_up/components/user_image.dart';
import '../sign_up/components/background.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // キーボードが出てきてもピクセルオーバーしないようにSingleChildScrollView
      body: SingleChildScrollView(
        child: Stack(
          children: [
            const BackGround(),
            SizedBox(
              height: size.height * 0.85,
              child: Stack(
                children: const [
                  RegistraionPage(),
                  UserImage(),
                  RegistationButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
