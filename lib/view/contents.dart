import 'package:flutter/material.dart';
import 'package:tech_library/view/book_list/book_list_page.dart';

class Contents extends StatelessWidget {
  const Contents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        BookListPage(title: 'フロントエンド'),
        BookListPage(title: 'バックエンド'),
        BookListPage(title: 'スマホアプリ'),
        BookListPage(title: 'データサイエンス'),
        BookListPage(title: '自己啓発'),
        BookListPage(title: 'その他')
      ],
    );
  }
}
