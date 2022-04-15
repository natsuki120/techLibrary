import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_library/utils/firestore/books.dart';
import '../book_list/book_list_model.dart';

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
    return ChangeNotifierProvider<BookListModel>(
        create: (_) => BookListModel()..fetchFavoriteBookList(),
        child: Consumer<BookListModel>(builder: (context, model, child) {
          List favoriteBooks = model.favoriteBooks;
          return Scaffold(
            body: Stack(
              children: [
                // 背景
                Container(
                  height: size.height * 0.45,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.blue, Colors.lightBlue.shade200]),
                  ),
                  // 本
                  child: SizedBox(
                    height: size.height * 0.3,
                    child: Image.network(bookImg),
                  ),
                ),
                // 詳細部分
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: size.height * 0.52,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            Text(author),
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
                                  width: 300,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      Colors.blue,
                                      Colors.lightBlue.shade100
                                    ]),
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
                                var result = await BookFirestore.borrowBook(
                                    bookId, bookImg, bookName);
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
                  child:
                      Consumer<BookListModel>(builder: (context, model, child) {
                    return GestureDetector(
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
                                bookId, bookImg, bookName);
                      },
                    );
                  }),
                ),
              ],
            ),
          );
        }));
  }
}
