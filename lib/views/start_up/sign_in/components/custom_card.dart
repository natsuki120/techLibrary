import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_library/view_models/start_up/sign_in_model.dart';

class CustomCard extends StatefulWidget {
  const CustomCard({Key? key}) : super(key: key);

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<SignInModel>(
      builder: (context, model, child) {
        return Center(
          child: Container(
            margin: EdgeInsets.only(top: size.height * 0.35),
            width: size.width * 0.9,
            height: size.height * 0.3,
            child: Card(
              child: Form(
                key: model.formKey,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        left: size.width * 0.1,
                        right: size.width * 0.1,
                        top: size.height * 0.04,
                      ),
                      child: TextFormField(
                        controller: model.emailController,
                        decoration: InputDecoration(
                          hintText: 'メールアドレス',
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: size.width * 0.1,
                        right: size.width * 0.1,
                        top: size.height * 0.03,
                      ),
                      child: TextFormField(
                        obscureText: model.isObscure,
                        controller: model.passwordController,
                        decoration: InputDecoration(
                          hintText: 'パスワード',
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.2),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(model.isObscure
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              model.makeToCanSee();
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
