import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_library/view/book_list/components/book.dart';
import 'package:tech_library/view/book_list/components/header.dart';

class BookListPage extends StatelessWidget {
  const BookListPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Header(title: title),
        Book(
          title: title,
        ),
      ],
    );
  }
}
