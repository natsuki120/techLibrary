import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:tech_library/view_models/book/book_list_model.dart';
import 'package:tech_library/views/book_detail/borrow_book_page.dart';
import 'package:tech_library/views/book_detail/checked_out_book_page.dart';

class AllMyFavoriteBookPage extends StatelessWidget {
  const AllMyFavoriteBookPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: NewGradientAppBar(
        title: Text(
          'お気に入り本一覧',
          style: TextStyle(color: Colors.white.withOpacity(0.8)),
        ),
        elevation: 0,
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.lightBlue.shade200],
        ),
      ),
      body: ChangeNotifierProvider(
        create: (_) => BookListModel(),
        child: Consumer<BookListModel>(
          builder: (context, model, child) {
            model.fetchBorrowBook();
            model.fetchMyFavoriteBook();
            final List<Widget> widgets = model.usersFavoriteBook.map(
              (favoriteBook) {
                return Stack(
                  children: [
                    GestureDetector(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          vertical: size.height * 0.03,
                          horizontal: size.width * 0.07,
                        ),
                        height: size.height * 0.3,
                        width: size.width * 0.35,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.5),
                            )
                          ],
                        ),
                        child: Image(
                          image: NetworkImage(favoriteBook.imgURL),
                          fit: BoxFit.fill,
                        ),
                      ),
                      onTap: () async {
                        model.borrowBooks.contains(favoriteBook.id)
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CheckedOutBookPage(book: favoriteBook),
                                ),
                              )
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BorrowBookPage(book: favoriteBook),
                                ),
                              );
                      },
                    ),
                    model.borrowBooks.contains(favoriteBook.id)
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
            return SizedBox(
              height: size.height,
              child: SizedBox(
                height: size.height,
                width: size.width,
                child: SingleChildScrollView(
                  child: Wrap(children: widgets),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
