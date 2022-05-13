import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:tech_library/main.dart';
import 'package:tech_library/utils/firestore/books.dart';

class BorrowBookPage extends StatelessWidget {
  const BorrowBookPage(
      {Key? key,
      required this.bookImg,
      required this.bookId,
      required this.bookName,
      required this.author})
      : super(key: key);
  final String bookImg;
  final String bookId;
  final String bookName;
  final String author;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer(
      builder: (context, ref, child) {
        List favoriteBooks = ref.watch(bookModelProvider).favoriteBooks;
        return Scaffold(
          appBar: NewGradientAppBar(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlue.shade200],
            ),
            elevation: 0.0,
          ),
          body: Stack(
            children: [
              // 背景
              Container(
                height: size.height * 0.35,
                padding: EdgeInsets.only(bottom: size.height * 0.04),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.blue, Colors.lightBlue.shade200]),
                ),
                // 本
                child: SizedBox(
                  child: Image.network(bookImg),
                ),
              ),
              // 詳細部分
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: size.height * 0.49,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // 本の名前
                          Container(
                            alignment: Alignment.center,
                            width: size.width * 0.7,
                            child: Text(
                              bookName,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: size.height * 0.035,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                          Container(
                            height: size.height * 0.1,
                          ),
                          // 借りるボタン
                          GestureDetector(
                            child: Center(
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 30),
                                alignment: Alignment.center,
                                width: size.width * 0.8,
                                height: size.height * 0.15,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue,
                                      Colors.lightBlue.shade100
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  'この本を借りる',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.width * 0.05,
                                      letterSpacing: 2.0),
                                ),
                              ),
                            ),
                            onTap: () async {
                              EasyLoading.show(status: 'Loading...');
                              var result = await BookFirestore.borrowBook(
                                  bookId, bookImg, bookName, author);
                              EasyLoading.showSuccess('貸出に成功しました');
                              if (result == true) {
                                Navigator.pop(context);
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // お気に入りボタン
              Container(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  child: favoriteBooks.contains(bookId)
                      ? const Icon(
                          Icons.favorite,
                          size: 60,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_border,
                          size: 60,
                          color: Colors.grey,
                        ),
                  onTap: () async {
                    favoriteBooks.contains(bookId)
                        ? await BookFirestore.removeFavoriteBook(bookId)
                        : await BookFirestore.getFavoriteBook(
                            bookId, bookImg, bookName, author);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
