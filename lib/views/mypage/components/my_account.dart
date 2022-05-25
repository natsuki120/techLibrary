import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_library/view_models/account/account_model.dart';
import 'package:tech_library/views/mypage/edit_profile_page.dart';

class MyAccount extends StatelessWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          height: size.height * 0.45,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlue.shade200],
            ),
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: size.height * 0.02),
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: size.height * 0.1),
                        width: size.width * 0.2,
                        height: size.height * 0.05,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          '編集',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size.width * 0.05,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfilePage(),
                          ),
                        );
                      },
                    ),
                  ),
                  ChangeNotifierProvider<AccountModel>(
                    create: (_) => AccountModel()..getMyAccount(),
                    child: Consumer<AccountModel>(
                      builder: (context, model, child) {
                        return Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: size.height * 0.12),
                          child: Column(
                            children: [
                              SizedBox(
                                height: size.height * 0.23,
                                width: size.width * 0.35,
                                child: CircleAvatar(
                                  foregroundImage:
                                      NetworkImage(model.usersInfo!.imagePath),
                                ),
                              ),
                              Text(
                                model.usersInfo!.name,
                                style: TextStyle(
                                  fontSize: size.height * 0.04,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
