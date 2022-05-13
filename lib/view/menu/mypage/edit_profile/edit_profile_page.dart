import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:tech_library/view/menu/mypage/edit_profile/edit_profile_model.dart';
import '../../../../domain/account.dart';
import '../../../../utils/authentication.dart';
import '../../../../utils/function_utils.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage({Key? key}) : super(key: key);

  // 画像

  // 名前
  final nameKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Account myAccount = Authentication.myAccount!;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: NewGradientAppBar(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.lightBlue.shade200],
        ),
        elevation: 0.0,
      ),
      body: Consumer<EditProfileModel>(
        builder: (context, model, child) {
          return Column(
            children: [
              // 登録した時の写真
              GestureDetector(
                child: SizedBox(
                  width: size.width * 0.35,
                  height: size.height * 0.3,
                  child: CircleAvatar(
                    foregroundImage: model.getImage(),
                  ),
                ),
                onTap: () async {
                  await model.pickImage();
                },
              ),
              // 名前
              Form(
                key: nameKey,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: '新しい名前',
                      hintStyle: TextStyle(
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  if (nameController.text.isNotEmpty &&
                      model.imageFile != null) {
                    EasyLoading.show(status: 'loading...');
                    String imagePath = '';
                    if (model.imageFile == null) {
                      imagePath = myAccount.imagePath;
                    } else {
                      var result = await FunctionUtils.uploadImage(
                          myAccount.id, model.imageFile!);
                      imagePath = result;
                    }
                    Account editAccount = Account(
                      id: Authentication.myAccount!.id,
                      name: nameController.text,
                      imagePath: imagePath,
                    );
                    await model.update(editAccount);
                    EasyLoading.showSuccess('更新しました');
                    Navigator.pop(context);
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
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: size.height * 0.05),
                  width: size.width * 0.4,
                  height: size.height * 0.06,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.lightBlue.shade100],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    '更新する',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.width * 0.04,
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
