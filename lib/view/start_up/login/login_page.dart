import 'package:flutter/material.dart';
import 'package:tech_library/view/start_up/login/components/background.dart';
import 'package:tech_library/view/start_up/login/components/custom_card.dart';
import 'package:tech_library/view/start_up/login/components/registration.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // キーボードが出てきてもピクセルオーバーしないようにSingleChildScrollView
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // 上の背景
            const BackGround(),
            Column(
              children: const [
                // 情報入力欄のレイアウト
                CustomCard(),
                // 新規登録の誘導
                Registration()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
