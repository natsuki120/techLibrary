import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:tech_library/error/show_error_dialog.dart';
import 'package:tech_library/view_models/account_model.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: NewGradientAppBar(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.lightBlue.shade200],
        ),
        elevation: 0.0,
      ),
      body: ChangeNotifierProvider.value(
        value: AccountModel()..fetchMyAccount(),
        child: Consumer<AccountModel>(
          builder: (context, model, child) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    child: SizedBox(
                      width: size.width * 0.35,
                      height: size.height * 0.3,
                      child: CircleAvatar(
                        foregroundImage: model.fetchImage(),
                      ),
                    ),
                    onTap: () async {
                      await model.pickImage();
                    },
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                    child: TextFormField(
                      controller: model.nameController,
                      decoration: InputDecoration(
                        hintText: '新しい名前',
                        hintStyle: TextStyle(
                          color: Colors.black.withOpacity(0.2),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      try {
                        EasyLoading.show(status: 'loading...');
                        await model.update();
                        EasyLoading.showSuccess('更新しました');
                        Navigator.pop(context);
                      } catch (e) {
                        EasyLoading.dismiss();
                        showErrorDialog(context, '全て入力してください');
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
              ),
            );
          },
        ),
      ),
    );
  }
}
