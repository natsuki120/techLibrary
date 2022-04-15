import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tech_library/model/account.dart';
import 'package:tech_library/utils/authentication.dart';
import 'package:tech_library/utils/firestore/users.dart';
import 'dart:io';
import 'package:tech_library/utils/function_utils.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  // 名前
  final nameKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  // メールアドレス
  final emailKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  // パスワード
  final passKey = GlobalKey<FormState>();
  TextEditingController passController = TextEditingController();
  // 画像取得用のファイル
  File? image;
  ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // キーボードが出てきてもピクセルオーバーしないようにSingleChildScrollView
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // ページ上部の背景
            Container(
              height: size.height * 0.45,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.blue, Colors.lightBlue.shade100])),
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.2,
                            width: size.width * 0.3,
                          ),
                        ],
                      )),
                  Text('TechLibrary',
                      style: TextStyle(
                          fontSize: size.height * 0.04,
                          color: Colors.white.withOpacity(0.9))),
                ],
              ),
            ),
            //情報入力欄
            SizedBox(
              height: size.height * 0.85,
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: size.height * 0.3),
                      width: size.width * 0.9,
                      height: size.height * 0.4,
                      //情報入力欄
                      child: Card(
                        child: Column(
                          children: [
                            //名前入力欄
                            Form(
                              key: nameKey,
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: 40, right: 40, top: 20),
                                child: TextFormField(
                                    controller: nameController,
                                    decoration: InputDecoration(
                                      hintText: 'ユーザー名',
                                      hintStyle: TextStyle(
                                          color: Colors.black.withOpacity(0.2)),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return '入力してください';
                                      }
                                    }),
                              ),
                            ),
                            //メアド入力欄
                            Form(
                              key: emailKey,
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: 40, right: 40, top: 20),
                                child: TextFormField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      hintText: 'メールアドレス',
                                      hintStyle: TextStyle(
                                          color: Colors.black.withOpacity(0.2)),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return '入力してください';
                                      }
                                    }),
                              ),
                            ),
                            //パスワード入力欄
                            Form(
                              key: passKey,
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: 40, right: 40, top: 20),
                                child: TextFormField(
                                    controller: passController,
                                    decoration: InputDecoration(
                                      hintText: 'パスワード',
                                      hintStyle: TextStyle(
                                          color: Colors.black.withOpacity(0.2)),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return '入力してください';
                                      }
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 登録ボタン
                  GestureDetector(
                    child: Center(
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: size.height * 0.75),
                        width: size.width * 0.7,
                        height: size.height * 0.1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.blue, Colors.lightBlue.shade100]),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          'Create',
                          style: TextStyle(
                              color: Colors.white, fontSize: size.width * 0.05),
                        ),
                      ),
                    ),
                    onTap: () async {
                      if (nameKey.currentState!.validate() &&
                          emailKey.currentState!.validate() &&
                          passKey.currentState!.validate() &&
                          image != null) {
                        var result = await Authentication.signUp(
                            email: emailController.text,
                            pass: passController.text);
                        if (result is UserCredential) {
                          String imagePath = await FunctionUtils.uploadImage(
                              result.user!.uid, image!);
                          Account newAccount = Account(
                            id: result.user!.uid,
                            name: nameController.text,
                            imagePath: imagePath,
                          );
                          var _result = await UserFirestore.setUser(newAccount);
                          if (_result == true) {
                            Navigator.pop(context);
                          }
                        }
                      } else {
                        return showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              title: const Text('全て入力してください'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () async {
                                    Navigator.pop(dialogContext);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                  //写真
                  Container(
                    margin: EdgeInsets.only(bottom: size.height * 0.15),
                    child: Center(
                      child: GestureDetector(
                        onTap: () async {
                          var result = await FunctionUtils.getImageFromGalley();
                          if (result != null) {
                            setState(() {
                              image = File(result.path);
                            });
                          }
                        },
                        child: CircleAvatar(
                          foregroundImage:
                              image == null ? null : FileImage(image!),
                          radius: 50,
                          child: const Text(
                            '画像を選択してください',
                            style: TextStyle(color: Colors.black),
                          ),
                          backgroundColor: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
