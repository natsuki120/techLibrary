import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_library/utils/firestore/books.dart';
import 'package:tech_library/view/menu/home/all_books_page.dart';
import 'book_list_model.dart';
import '../book_detail/borrow_book_page.dart';
import '../book_detail/checked_out_book_page.dart';

class BookListPage extends StatefulWidget {
  const BookListPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
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
                widget.title,
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
                        genre: widget.title,
                        collection: 'book',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        ChangeNotifierProvider<BookListModel>(
          create: (_) => BookListModel()..fetchBorrowBookList(),
          child: Consumer<BookListModel>(
            builder: (context, model, child) {
              final List borrowBook = model.borrowBooks;
              return SizedBox(
                height: size.height * 0.3,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('book')
                      .where('genre', isEqualTo: widget.title)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    }
                    return SizedBox(
                      width: size.width,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;
                            return Stack(
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
                                      imageUrl: data['imgURL'],
                                      fit: BoxFit.fill,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                  onTap: () async {
                                    var result = await BookFirestore.getBook(
                                        widget.title);
                                    if (result is List) {
                                      borrowBook.contains(document.id)
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CheckedOutBookPage(
                                                  bookImg: data['imgURL'],
                                                  bookId: document.id,
                                                  bookName: data['title'],
                                                  author: data['author'],
                                                ),
                                              ),
                                            )
                                          : Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    BorrowBookPage(
                                                  bookImg: data['imgURL'],
                                                  bookId: document.id,
                                                  bookName: data['title'],
                                                  author: data['author'],
                                                ),
                                              ),
                                            );
                                    }
                                  },
                                ),
                                borrowBook.contains(document.id)
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
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
