import 'package:flutter/material.dart';
import 'package:tech_library/utils/authentication.dart';
import 'package:tech_library/views/account/components/delete.dart';
import 'package:tech_library/views/account/edit_profile_page.dart';
import 'package:tech_library/views/start_up/sign_in/sign_in_page.dart';

class DrawerListPage extends StatelessWidget {
  const DrawerListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        GestureDetector(
          child: const ListTile(
            title: Text('プロフィール編集'),
          ),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EditProfilePage(),
              ),
            );
          },
        ),
        GestureDetector(
          child: const ListTile(
            title: Text('ログアウト'),
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  content: const Text("ログアウトしますか？"),
                  actions: <Widget>[
                    TextButton(
                      child: const Text("Cancel"),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      child: const Text("OK"),
                      onPressed: () async {
                        await Authentication.logOut();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => const SignInPage(),
                          ),
                          (route) => false,
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
        GestureDetector(
          child: const ListTile(
            title: Text('退会する'),
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  content: const Text("退会しますか？"),
                  actions: <Widget>[
                    TextButton(
                      child: const Text("Cancel"),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      child: const Text("OK"),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Delete(),
                          ),
                        );
                        Authentication.emailController.clear();
                        Authentication.passwordController.clear();
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}
