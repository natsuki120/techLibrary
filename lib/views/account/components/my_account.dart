import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_library/view_models/account_model.dart';

class MyAccount extends StatelessWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          height: size.height * 0.3,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlue.shade200],
            ),
          ),
          child: ChangeNotifierProvider<AccountModel>(
            create: (_) => AccountModel(),
            child: Consumer<AccountModel>(
              builder: (context, model, child) {
                model.fetchMyAccount();
                return Container(
                  alignment: Alignment.center,
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
          ),
        ),
      ],
    );
  }
}
