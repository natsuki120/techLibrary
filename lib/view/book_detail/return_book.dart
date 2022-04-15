import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_library/utils/firestore/books.dart';
import 'package:tech_library/view/book_list/book_list_model.dart';

class ReturnBook extends StatelessWidget {
  const ReturnBook({
    Key? key,
    required this.bookInfo,
    required this.bookImg,
    required this.bookName,
  }) : super(key: key);
  final String bookInfo;
  final String bookImg;
  final String bookName;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ChangeNotifierProvider<BookListModel>(
        create: (_) => BookListModel()..fetchFavoriteBookList(),
        child: Consumer<BookListModel>(builder: (context, model, child) {
          List favoriteBooks = model.favoriteBooks;
          return Scaffold(
            body: Stack(
              children: [
                // 本
                Container(
                  height: size.height * 0.45,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.blue, Colors.lightBlue.shade200]),
                  ),
                  child: SizedBox(
                    height: size.height * 0.3,
                    child: Image.network(bookImg),
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
                              bookInfo, bookImg, bookName);
                    },
                  ),
                ),
                // 詳細部分
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: size.height * 0.52,
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
                                    letterSpacing: 1.0),
                              ),
                            ),
                            // 著者
                            const Text('石井幸次'),
                            // 本の説明
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              height: 150,
                              width: 350,
                              child: const SingleChildScrollView(
                                child: Text(
                                  'テストテストてすと',
                                  style: TextStyle(letterSpacing: 1.0),
                                ),
                              ),
                            ),
                            // 借りるボタン
                            GestureDetector(
                              child: Center(
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 30),
                                  alignment: Alignment.center,
                                  width: 300,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      Colors.blue,
                                      Colors.lightBlue.shade100
                                    ]),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Text(
                                    '返却する',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: size.width * 0.05,
                                        letterSpacing: 2.0),
                                  ),
                                ),
                              ),
                              onTap: () async {
                                var result =
                                    await BookFirestore.returnMyBook(bookInfo);
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
        }));
  }
}
