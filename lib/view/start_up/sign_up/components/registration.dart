import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_library/main.dart';

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
        //情報入力欄
        child: Card(
          child: Consumer(
            builder: (context, ref, child) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    //名前入力欄
                    Container(
                      margin: EdgeInsets.only(
                        left: size.width * 0.1,
                        right: size.width * 0.1,
                        top: size.height * 0.025,
                      ),
                      child: TextFormField(
                        controller: ref.watch(signupProvider).nameController,
                        decoration: InputDecoration(
                          hintText: '名前',
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ),
                      ),
                    ),
                    //メアド入力欄
                    Container(
                      margin: EdgeInsets.only(
                        left: size.width * 0.1,
                        right: size.width * 0.1,
                        top: size.height * 0.025,
                      ),
                      child: TextFormField(
                        controller: ref.watch(signupProvider).emailController,
                        decoration: InputDecoration(
                          hintText: 'メールアドレス',
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ),
                      ),
                    ),
                    //パスワード入力欄
                    Container(
                      margin: EdgeInsets.only(
                        left: size.width * 0.1,
                        right: size.width * 0.1,
                        top: size.height * 0.025,
                      ),
                      child: TextFormField(
                        controller:
                            ref.watch(signupProvider).passwordController,
                        decoration: InputDecoration(
                          hintText: 'パスワード',
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.2),
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
