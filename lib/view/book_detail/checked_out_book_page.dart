import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:tech_library/main.dart';
import 'package:tech_library/utils/firestore/books.dart';

class CheckedOutBookPage extends StatelessWidget {
  const CheckedOutBookPage({
    Key? key,
    required this.bookId,
    required this.bookImg,
    required this.bookName,
    required this.author,
  }) : super(key: key);
  final String bookId;
  final String bookImg;
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
              Container(
                height: size.height * 0.35,
                padding: EdgeInsets.only(bottom: size.height * 0.04),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.blue, Colors.lightBlue.shade200]),
                ),
                child: SizedBox(
                  height: size.height * 0.3,
                  child: SizedBox(
                    height: size.height * 0.3,
                    child: Image.network(bookImg),
                  ),
                ),
              ),
              // 詳細部分
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: size.height * 0.49,
                    width: size.width,
                    child: SingleChildScrollView(
                      child: Column(
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
                          // 「貸出中」の表示
                          Center(
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: size.height * 0.1),
                              alignment: Alignment.center,
                              width: size.width * 0.8,
                              height: size.height * 0.15,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: Colors.black.withOpacity(0.8)),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                '貸出中',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: size.width * 0.05,
                                  letterSpacing: 2.0,
                                ),
                              ),
                            ),
                          ),
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
                          size: 50,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_border,
                          size: 50,
                          color: Colors.grey,
                        ),
                  onTap: () async {
                    favoriteBooks.contains(bookId)
                        ? await BookFirestore.removeFavoriteBook(bookId)
                        : await BookFirestore.getFavoriteBook(
                            bookId,
                            bookImg,
                            bookName,
                            author,
                          );
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
