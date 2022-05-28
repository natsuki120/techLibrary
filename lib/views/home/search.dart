import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search_page/search_page.dart';
import 'package:tech_library/models/book.dart';
import 'package:tech_library/view_models/book/book_list_model.dart';
import 'package:tech_library/views/book_detail/borrow_book_page.dart';
import 'package:tech_library/views/book_detail/checked_out_book_page.dart';

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
      create: (_) => BookListModel(),
      child: Consumer<BookListModel>(
        builder: (context, model, child) {
          model.fetchBook();
          model.fetchBorrowBook();
          return GestureDetector(
            child: Container(
              alignment: Alignment.center,
              margin:
                  EdgeInsets.only(top: size.height * 0.13, left: 20, right: 20),
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
              showSearch(
                context: context,
                delegate: SearchPage<Book>(
                  items: model.books,
                  searchLabel: '本の名前を入力してください',
                  suggestion: const Center(
                    child: Text('ここにタイトルが表示されます'),
                  ),
                  failure: const Center(
                    child: Text('該当する本がありませんでした'),
                  ),
                  // 検索結果
                  filter: (books) => [books.title],
                  builder: (book) {
                    return GestureDetector(
                      child: ListTile(
                        title: Text(book.title),
                      ),
                      onTap: () {
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
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
