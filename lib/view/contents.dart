import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:tech_library/view/book_list/book_list_page.dart';

class Contents extends StatelessWidget {
  const Contents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        BookGalley(title: 'フロントエンド'),
        BookGalley(title: 'バックエンド'),
        BookGalley(title: 'ネイティブアプリ'),
        BookGalley(title: 'データサイエンス'),
        BookGalley(
          title: '自己啓発',
        ),
        BookGalley(title: 'その他')
      ],
    );
  }
}
