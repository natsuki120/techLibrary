import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tech_library/views/start_up/sign_up/sign_up_page.dart';

class Registration extends StatelessWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.1),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black),
          children: [
            const TextSpan(
              text: '新規登録は',
              style: TextStyle(color: Colors.grey),
            ),
            TextSpan(
              text: 'こちら',
              style: const TextStyle(color: Colors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpPage(),
                    ),
                  );
                },
            )
          ],
        ),
      ),
    );
  }
}
