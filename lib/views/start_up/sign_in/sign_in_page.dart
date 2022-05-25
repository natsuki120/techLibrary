import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_library/view_models/start_up/sign_in_model.dart';
import '../sign_up/components/background.dart';
import 'components/custom_card.dart';
import 'components/registration.dart';
import 'components/registration_button.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignInModel(),
      child: Scaffold(
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
      ),
    );
  }
}
