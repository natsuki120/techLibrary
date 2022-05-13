import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_library/main.dart';

class CustomCard extends StatefulWidget {
  const CustomCard({Key? key}) : super(key: key);

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer(
      builder: (context, ref, child) {
        return Center(
          child: Container(
            margin: EdgeInsets.only(top: size.height * 0.35),
            width: size.width * 0.9,
            height: size.height * 0.3,
            //情報入力欄
            child: Card(
              child: Form(
                key: ref.read(signinProvider).formKey,
                child: Column(
                  children: [
                    //名前入力欄
                    Container(
                      margin: EdgeInsets.only(
                        left: size.width * 0.1,
                        right: size.width * 0.1,
                        top: size.height * 0.04,
                      ),
                      child: TextFormField(
                        controller: ref.read(signinProvider).emailController,
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
                        top: size.height * 0.03,
                      ),
                      child: TextFormField(
                        controller: ref.read(signinProvider).passwordController,
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
              ),
            ),
          ),
        );
      },
    );
  }
}
