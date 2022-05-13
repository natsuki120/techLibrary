import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:tech_library/main.dart';
import 'package:tech_library/view/book_detail/borrow_book_page.dart';
import '../../../utils/firestore/books.dart';
import '../../book_detail/checked_out_book_page.dart';

class AllBookPage extends StatelessWidget {
  const AllBookPage({
    Key? key,
    required this.genre,
    required this.collection,
  }) : super(key: key);
  final String genre;
  final String collection;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: NewGradientAppBar(
        title: Text(
          genre,
          style: TextStyle(color: Colors.white.withOpacity(0.8)),
        ),
        elevation: 0,
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.lightBlue.shade200],
        ),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          ref.read(bookModelProvider).fetchBook(genre);
          ref.read(bookModelProvider).fetchBorrowBookList();
          final List genreBookList = ref.watch(bookModelProvider).books;
          final List borrowBook = ref.watch(bookModelProvider).borrowBooks;
          final List<Widget> widgets = genreBookList
              .map((book) => Stack(
                    children: [
                      GestureDetector(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: size.height * 0.03,
                          ),
                          height: size.width * 0.5,
                          width: size.width * 0.35,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.5),
                              )
                            ],
                          ),
                          child: CachedNetworkImage(
                            imageUrl: book.imgURL,
                            fit: BoxFit.fill,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        onTap: () async {
                          var result = await BookFirestore.getBook(genre);
                          if (result is List) {
                            borrowBook.contains(book.id)
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CheckedOutBookPage(
                                        bookImg: book.imgURL,
                                        bookId: book.id,
                                        bookName: book.title,
                                        author: book.author,
                                      ),
                                    ),
                                  )
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BorrowBookPage(
                                        bookImg: book.imgURL,
                                        bookId: book.id,
                                        bookName: book.title,
                                        author: book.author,
                                      ),
                                    ),
                                  );
                          }
                        },
                      ),
                      borrowBook.contains(book.id)
                          ? Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                              height: 20,
                              width: 20,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                            )
                          : Container(
                              margin: const EdgeInsets.only(left: 5),
                              height: 20,
                              width: 20,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                              ),
                            ),
                      //  親要素
                    ],
                  ))
              .toList();
          return SizedBox(
            height: size.height,
            child: SizedBox(
              height: size.height,
              width: size.width,
              child: SingleChildScrollView(
                child: Wrap(
                  children: widgets,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
