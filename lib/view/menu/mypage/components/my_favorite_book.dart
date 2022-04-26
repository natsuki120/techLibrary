import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils/firestore/book_ex.dart';
import '../../../book_detail/borrow_book_page.dart';
import '../../../book_detail/checked_out_book_page.dart';
import '../../../book_list/book_list_model.dart';
import '../account/account_model.dart';
import '../all_my_book_page.dart';

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
                      builder: (context) => const AllMyBookPage(
                        title: 'お気に入り本一覧',
                        collection: 'my_book',
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
              final List borrowBook = model.borrowBooks;
              return ChangeNotifierProvider(
                create: (_) => AccountModel()..getMyFavoriteBook(),
                child: Consumer<AccountModel>(
                  builder: (context, model, child) {
                    final List? usersFavoriteBook = model.usersFavoriteBook;
                    if (usersFavoriteBook == null) {
                      return const Text('お気に入りの本はありません');
                    }
                    final List<Widget> widgets = usersFavoriteBook.map((book) {
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
                                image: NetworkImage(
                                  book.imgURL,
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                            onTap: () async {
                              var result =
                                  await BookFirestore.getBook('favorite');
                              if (result is List) {
                                borrowBook.contains(book.id)
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CheckedOutBookPage(
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
                    }).toList();
                    return SizedBox(
                      height: size.height * 0.3,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: widgets),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
