import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_library/utils/firestore/books.dart';
import '../book_list/book_list_model.dart';

class CheckedOutBookPage extends StatelessWidget {
  const CheckedOutBookPage({
    Key? key,
    required this.bookId,
    required this.bookImg,
    required this.bookName,
  }) : super(key: key);
  final String bookId;
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
                              bookId, bookImg, bookName);
                    },
                  ),
                ),
              ],
            ),
          );
        }));
  }
}
