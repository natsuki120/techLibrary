import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_library/view_models/start_up/sign_up_model.dart';

class RegistraionPage extends StatelessWidget {
  const RegistraionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        width: size.width * 0.9,
        height: size.height * 0.35,
        margin: EdgeInsets.only(
          top: size.height * 0.3,
        ),
        child: Card(
          child: Consumer<SignUpModel>(
            builder: (context, model, child) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        left: size.width * 0.1,
                        right: size.width * 0.1,
                        top: size.height * 0.025,
                      ),
                      child: TextFormField(
                        controller: model.nameController,
                        decoration: InputDecoration(
                          hintText: '名前',
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
                        top: size.height * 0.025,
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
                        top: size.height * 0.025,
                      ),
                      child: TextFormField(
                        controller: model.passwordController,
                        obscureText: model.isObscure,
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
              );
            },
          ),
        ),
      ),
    );
  }
}
