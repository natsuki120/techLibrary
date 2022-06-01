import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:tech_library/view_models/book/book_list_model.dart';
import 'package:tech_library/views/book_detail/borrow_book_page.dart';
import 'package:tech_library/views/book_detail/checked_out_book_page.dart';

class AllBookPage extends StatelessWidget {
  const AllBookPage(
      {Key? key,
      required this.genre,
      required this.collection,
      required this.model})
      : super(key: key);
  final String genre;
  final String collection;
  final BookListModel model;

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
      body: ChangeNotifierProvider.value(
        value: BookListModel(),
        child: Consumer<BookListModel>(
          builder: (context, model, child) {
            model.fetchBorrowBook();
            model.fetchGenreBook(genre);
            final List<Widget> widgets = model.genreBooks.map(
              (book) {
                return Stack(
                  children: [
                    GestureDetector(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          vertical: size.height * 0.03,
                          horizontal: size.width * 0.07,
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
                        model.borrowBooks.contains(book.id)
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CheckedOutBookPage(
                                    book: book,
                                    model: model,
                                  ),
                                ),
                              )
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BorrowBookPage(book: book, model: model),
                                ),
                              );
                      },
                    ),
                    model.borrowBooks.contains(book.id)
                        ? Container(
                            height: size.height * 0.07,
                            width: size.width * 0.06,
                            margin: EdgeInsets.only(left: size.width * 0.04),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                          )
                        : Container(
                            height: size.height * 0.07,
                            width: size.width * 0.06,
                            margin: EdgeInsets.only(left: size.width * 0.04),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent,
                            ),
                          )
                  ],
                );
              },
            ).toList();
            return SingleChildScrollView(
              child: Wrap(
                children: widgets,
              ),
            );
          },
        ),
      ),
    );
  }
}
