import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:tech_library/view/book_list/book_list_model.dart';
import 'package:tech_library/view/book_detail/borrow_book_page.dart';
import '../../../utils/firestore/books.dart';
import '../../book_detail/checked_out_book_page.dart';

class AllBookPage extends StatefulWidget {
  const AllBookPage({
    Key? key,
    required this.genre,
    required this.collection,
  }) : super(key: key);
  final String genre;
  final String collection;

  @override
  _AllBookPageState createState() => _AllBookPageState();
}

class _AllBookPageState extends State<AllBookPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: NewGradientAppBar(
        title: Text(
          widget.genre,
          style: TextStyle(color: Colors.white.withOpacity(0.8)),
        ),
        elevation: 0,
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.lightBlue.shade200],
        ),
      ),
      body: ChangeNotifierProvider<BookListModel>(
        create: (_) => BookListModel()..fetchBorrowBookList(),
        child: Consumer<BookListModel>(
          builder: (context, model, child) {
            final List borrowBook = model.borrowBooks;
            return SizedBox(
              height: size.height,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(widget.collection)
                    .where('genre', isEqualTo: widget.genre)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  }
                  return SizedBox(
                    height: size.height,
                    width: size.width,
                    child: SingleChildScrollView(
                      child: Wrap(
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          return Stack(
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
                                    imageUrl: data['imgURL'],
                                    fit: BoxFit.fill,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                                onTap: () async {
                                  var result =
                                      await BookFirestore.getBook(widget.genre);
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
                                    )
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
      ),
    );
  }
}
