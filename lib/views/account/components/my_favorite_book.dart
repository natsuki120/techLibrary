import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_library/view_models/book/book_list_model.dart';
import 'package:tech_library/views/book_detail/borrow_book_page.dart';
import 'package:tech_library/views/book_detail/checked_out_book_page.dart';
import '../all_my_favorite_book.dart';

class MyFavoriteBook extends StatelessWidget {
  const MyFavoriteBook({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(
                top: size.height * 0.03,
                left: size.width * 0.06,
              ),
              child: Text(
                'お気に入り本',
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
              margin: EdgeInsets.only(
                top: size.height * 0.03,
                right: size.width * 0.04,
              ),
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
                      builder: (context) => const AllMyFavoriteBookPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        ChangeNotifierProvider(
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
                            horizontal: size.width * 0.02,
                            vertical: size.height * 0.025,
                          ),
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
                                    builder: (context) => CheckedOutBookPage(
                                      book: favoriteBook,
                                      model: model,
                                    ),
                                  ),
                                )
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BorrowBookPage(
                                      book: favoriteBook,
                                      model: model,
                                    ),
                                  ),
                                );
                        },
                      ),
                      model.borrowBooks.contains(favoriteBook.id)
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
                  );
                },
              ).toList();
              return SizedBox(
                height: size.height * 0.3,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: widgets),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
