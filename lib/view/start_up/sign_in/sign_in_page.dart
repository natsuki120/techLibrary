import 'package:flutter/material.dart';
import 'package:tech_library/view/start_up/sign_in//components/background.dart';
import 'package:tech_library/view/start_up/sign_in//components/custom_card.dart';
import 'package:tech_library/view/start_up/sign_in//components/registration.dart';
import 'package:tech_library/view/start_up/sign_in//components/registration_button.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            const BackGround(),
            Column(
              children: const [
                CustomCard(),
                Registration(),
              ],
            ),
            const RegistrationButton(),
          ],
        ),
      ),
    );
  }
}
