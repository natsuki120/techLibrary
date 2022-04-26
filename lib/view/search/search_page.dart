import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search_page/search_page.dart';
import 'package:tech_library/view/book_list/book_list_model.dart';
import 'package:tech_library/view/search/search_model.dart';

import '../book_detail/borrow_book_page.dart';
import '../book_detail/checked_out_book_page.dart';

class Search extends StatelessWidget {
  Search({Key? key}) : super(key: key);

  SearchModel search = SearchModel();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: size.height * 0.13, left: 20, right: 20),
        padding: const EdgeInsets.only(left: 20, right: 20),
        height: size.height * 0.07,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
              blurRadius: 1.0,
              color: Colors.black12,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Search',
                style: TextStyle(
                    color: Colors.blue.withOpacity(0.5), fontSize: 16),
              ),
            ),
            Icon(
              Icons.search,
              color: Colors.blue.withOpacity(0.5),
            )
          ],
        ),
      ),
      onTap: () {
        search.fetchBookName();
        showSearch(
          context: context,
          delegate: SearchPage(
            items: search.searchList,
            searchLabel: '本の名前を入力してください',
            suggestion: const Center(
              child: Text('ここにタイトルが表示されます'),
            ),
            failure: const Center(
              child: Text('該当する本がありませんでした'),
            ),
            // 検索結果
            filter: (person) => [person.toString()],
            builder: (person) => StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('book')
                  .where('title', isEqualTo: person)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // 赤画面を消すため
                  return Container();
                }
                return Column(
                  children: snapshot.data!.docs.map(
                    (DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return ChangeNotifierProvider<BookListModel>(
                        create: (_) => BookListModel()..fetchBorrowBookList(),
                        child: Consumer<BookListModel>(
                          builder: (context, model, child) {
                            final List borrowBook = model.borrowBooks;
                            return GestureDetector(
                              child: ListTile(
                                title: Text(data['title']),
                              ),
                              onTap: () {
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
                                          builder: (context) => BorrowBookPage(
                                            bookImg: data['imgURL'],
                                            bookId: document.id,
                                            bookName: data['title'],
                                            author: data['author'],
                                          ),
                                        ),
                                      );
                              },
                            );
                          },
                        ),
                      );
                    },
                  ).toList(),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
