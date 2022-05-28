import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:tech_library/models/book.dart';
import 'package:tech_library/utils/firestore/books.dart';
import 'package:tech_library/view_models/book/book_list_model.dart';

class CheckedOutBookPage extends StatelessWidget {
  const CheckedOutBookPage({Key? key, required this.book}) : super(key: key);
  final Book book;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                colors: [Colors.blue, Colors.lightBlue.shade200],
              ),
            ),
            child: SizedBox(
              height: size.height * 0.3,
              child: SizedBox(
                height: size.height * 0.3,
                child: Image.network(book.imgURL),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: size.height * 0.49,
                width: size.width,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: size.width * 0.7,
                        child: Text(
                          book.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: size.height * 0.035,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(vertical: size.height * 0.1),
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
          ChangeNotifierProvider(
            create: (_) => BookListModel(),
            child: Consumer<BookListModel>(
              builder: (context, model, child) {
                model.fetchFavoriteBook();
                List favoriteBooks = model.favoriteBooks;
                return Container(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    child: favoriteBooks.contains(book.id)
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
                      favoriteBooks.contains(book.id)
                          ? await BookFirestore.removeFavoriteBook(book.id)
                          : await BookFirestore.fetchFavoriteBook(book);
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
