import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_library/view_models/start_up/sign_up_model.dart';
import 'components/background.dart';
import 'components/registration.dart';
import 'components/registration_button.dart';
import 'components/user_image.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
      create: (_) => SignUpModel(),
      child: Scaffold(
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
      ),
    );
  }
}
