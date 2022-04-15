import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_library/utils/firestore/books.dart';
import 'package:tech_library/view/bottom_nav/home/all_books_page.dart';
import 'book_list_model.dart';
import '../book_detail/borrow_book_page.dart';
import '../book_detail/checked_out_book_page.dart';

class BookGalley extends StatefulWidget {
  const BookGalley({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<BookGalley> createState() => _BookGalleyState();
}

class _BookGalleyState extends State<BookGalley> {
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
              child: Text(widget.title,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.blue.withOpacity(0.5),
                      decorationThickness: 5)),
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
                      ));
                },
              ),
            ),
          ],
        ),
        ChangeNotifierProvider<BookListModel>(
            create: (_) => BookListModel()..fetchBorrowBookList(),
            child: Consumer<BookListModel>(builder: (context, model, child) {
              final List borrowBook = model.borrowBooks;
              return SizedBox(
                height: size.height * 0.3,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('book')
                      .where('genre', isEqualTo: widget.title)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return SizedBox(
                          height: size.height,
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
                                        margin: const EdgeInsets.all(10),
                                        height: 200,
                                        width: size.width * 0.35,
                                        decoration: BoxDecoration(boxShadow: [
                                          BoxShadow(
                                            blurRadius: 10,
                                            color:
                                                Colors.black.withOpacity(0.5),
                                          )
                                        ]),
                                        child: Image(
                                            image: NetworkImage(data['imgURL']),
                                            fit: BoxFit.fill),
                                      ),
                                      onTap: () async {
                                        var result =
                                            await BookFirestore.getBook(
                                                widget.title);
                                        if (result is List) {
                                          borrowBook.contains(document.id)
                                              ? Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CheckedOutBookPage(
                                                            bookImg:
                                                                data['imgURL'],
                                                            bookId: document.id,
                                                            bookName:
                                                                data['name'],
                                                          )))
                                              : Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          BorrowBookPage(
                                                            bookImg:
                                                                data['imgURL'],
                                                            bookId: document.id,
                                                            bookName:
                                                                data['title'],
                                                            author:
                                                                data['author'],
                                                          )));
                                        }
                                      },
                                    ),
                                    borrowBook.contains(document.id)
                                        ? Container(
                                            margin:
                                                const EdgeInsets.only(left: 5),
                                            height: 20,
                                            width: 20,
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.red),
                                          )
                                        : Container()
                                  ],
                                );
                              }).toList(),
                            ),
                          ));
                    } else {
                      return const Text('something went wrong');
                    }
                  },
                ),
              );
            }))
      ],
    );
  }
}
