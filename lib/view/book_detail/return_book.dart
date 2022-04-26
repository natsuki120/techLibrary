import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:tech_library/utils/firestore/books.dart';
import 'package:tech_library/view/book_list/book_list_model.dart';

// 確かセーフエリアってあったよね？

class ReturnBook extends StatelessWidget {
  const ReturnBook(
      {Key? key,
      required this.bookInfo,
      required this.bookImg,
      required this.bookName,
      required this.author})
      : super(key: key);
  final String bookInfo;
  final String bookImg;
  final String bookName;
  final String author;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ChangeNotifierProvider<BookListModel>(
      create: (_) => BookListModel()..fetchFavoriteBookList(),
      child: Consumer<BookListModel>(
        builder: (context, model, child) {
          List favoriteBooks = model.favoriteBooks;
          return Scaffold(
            appBar: NewGradientAppBar(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.lightBlue.shade200],
              ),
              elevation: 0.0,
            ),
            body: Stack(
              children: [
                // 本
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
                Container(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    child: favoriteBooks.contains(bookInfo)
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
                      favoriteBooks.contains(bookInfo)
                          ? await BookFirestore.removeFavoriteBook(bookInfo)
                          : await BookFirestore.getFavoriteBook(
                              bookInfo, bookImg, bookName, author);
                    },
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
                              width: 300,
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
                            // 借りるボタン
                            GestureDetector(
                              child: Center(
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                    vertical: size.height * 0.1,
                                  ),
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
                                    '返却する',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.width * 0.05,
                                      letterSpacing: 2.0,
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () async {
                                EasyLoading.show(status: 'loading...');
                                var result =
                                    await BookFirestore.returnMyBook(bookInfo);
                                EasyLoading.showSuccess('返却しました');
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
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
