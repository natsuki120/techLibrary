import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:tech_library/view/book_list/book_list_model.dart';
import 'package:tech_library/view/search/search_model.dart';
import '../book_detail/borrow_book_page.dart';
import '../book_detail/checked_out_book_page.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchModel>(
        create: (_) => SearchModel()..searchBookName,
        child: Scaffold(
            appBar: NewGradientAppBar(
              title: Text(
                '検索',
                style: TextStyle(color: Colors.white.withOpacity(0.8)),
              ),
              elevation: 0,
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.lightBlue.shade200],
              ),
            ),
            body: Consumer<SearchModel>(builder: (context, model, child) {
              return Column(
                children: [
                  TextField(
                    onChanged: (text) {
                      model.text = text;
                      model.searchBookName(text);
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: "名前で調べる...",
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: model.searchResultList.toSet().length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('book')
                                  .where('title',
                                      isEqualTo: model.searchResultList[index])
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  // 赤画面を消すため
                                  return Container();
                                }
                                return Column(
                                    children: snapshot.data!.docs
                                        .map((DocumentSnapshot document) {
                                  Map<String, dynamic> data =
                                      document.data()! as Map<String, dynamic>;
                                  return ChangeNotifierProvider<BookListModel>(
                                      create: (_) => BookListModel()
                                        ..fetchBorrowBookList(),
                                      child: Consumer<BookListModel>(
                                          builder: (context, model, child) {
                                        List borrowBook = model.borrowBooks;
                                        return GestureDetector(
                                          child: Text(data['title']),
                                          onTap: () {
                                            borrowBook.contains(document.id)
                                                ? Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            CheckedOutBookPage(
                                                              bookImg: data[
                                                                  'imgURL'],
                                                              bookId:
                                                                  document.id,
                                                              bookName:
                                                                  data['title'],
                                                            )))
                                                : Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            BorrowBookPage(
                                                                bookImg: data[
                                                                    'imgURL'],
                                                                bookId:
                                                                    document.id,
                                                                bookName: data[
                                                                    'title'],
                                                                author: data[
                                                                    'author'])));
                                          },
                                        );
                                      }));
                                }).toList());
                              }),
                          // 候補リストのListTileを生成
                        );
                      },
                    ),
                  ),
                ],
              );
            })));
  }
}
