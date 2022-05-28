import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:tech_library/views/account/components/drawer_list_page.dart';
import 'components/my_account.dart';
import 'components/my_book.dart';
import 'components/my_favorite_book.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NewGradientAppBar(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.lightBlue.shade200],
        ),
        elevation: 0.0,
      ),
      drawer: const Drawer(child: DrawerListPage()),
      body: Column(
        children: [
          const MyAccount(),
          Expanded(
            child: ListView(
              children: const [MyBook(), MyFavoriteBook()],
            ),
          )
        ],
      ),
    );
  }
}
