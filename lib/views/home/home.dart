import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:tech_library/views/home/search.dart';
import 'book_list_page.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: NewGradientAppBar(
        elevation: 0,
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.lightBlue.shade200],
        ),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              // 上の検索窓の背景
              Container(
                height: size.height * 0.15,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(36),
                    bottomLeft: Radius.circular(36),
                  ),
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.lightBlue.shade200],
                  ),
                ),
              ),
              // 検索窓
              const Search(),
            ],
          ),
          // 本の表示
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: const [
                  BookListPage(title: 'フロントエンド'),
                  BookListPage(title: 'バックエンド'),
                  BookListPage(title: 'スマホアプリ'),
                  BookListPage(title: 'データサイエンス'),
                  BookListPage(title: '自己啓発'),
                  BookListPage(title: 'その他'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
