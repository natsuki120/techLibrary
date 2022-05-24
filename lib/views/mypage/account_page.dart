import 'package:flutter/material.dart';
import 'components/my_account.dart';
import 'components/my_book.dart';
import 'components/my_favorite_book.dart';

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
