import 'package:flutter/material.dart';
import 'package:tech_library/view/menu/mypage/components/my_account.dart';
import 'package:tech_library/view/menu/mypage/components/my_book.dart';
import 'package:tech_library/view/menu/mypage/components/my_favorite_book.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const MyAccount(),
        Expanded(
          child: ListView(
            children: const [
              MyBook(),
              MyFavoriteBook(),
            ],
          ),
        )
      ],
    );
  }
}
