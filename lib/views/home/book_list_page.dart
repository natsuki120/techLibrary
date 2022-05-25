import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_library/view_models/book/book_list_model.dart';
import 'package:tech_library/views/book_detail/borrow_book_page.dart';
import 'package:tech_library/views/book_detail/checked_out_book_page.dart';
import 'all_books_page.dart';

class BookListPage extends StatelessWidget {
  const BookListPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 20, left: 25),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.blue.withOpacity(0.5),
                  decorationThickness: 5,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, right: 10),
              child: ElevatedButton(
                child: const Text('More'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.lightBlueAccent.withOpacity(0.9),
                  onPrimary: Colors.white,
                  shape: const StadiumBorder(),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllBookPage(
                        genre: title,
                        collection: 'book',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        ChangeNotifierProvider(
          create: (_) => BookListModel()..fetchBorrowBookList(),
          child: Consumer<BookListModel>(
            builder: (context, model, child) {
              model.fetchGenreBook(title);
              final List<Widget> widgets = model.genreBooks
                  .map(
                    (book) => Stack(
                      children: [
                        GestureDetector(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: size.width * 0.02,
                              vertical: size.height * 0.025,
                            ),
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
                                      builder: (context) =>
                                          CheckedOutBookPage(book: book),
                                    ),
                                  )
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          BorrowBookPage(book: book),
                                    ),
                                  );
                          },
                        ),
                        model.borrowBooks.contains(book.id)
                            ? Container(
                                height: size.height * 0.07,
                                width: size.width * 0.06,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                              )
                            : Container()
                      ],
                    ),
                  )
                  .toList();
              return SizedBox(
                height: size.height * 0.3,
                child: SizedBox(
                  width: size.width,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(children: widgets),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
