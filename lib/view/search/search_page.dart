import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:search_page/search_page.dart';
import 'package:tech_library/main.dart';
import '../book_detail/borrow_book_page.dart';
import '../book_detail/checked_out_book_page.dart';

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer(
      builder: (context, ref, child) {
        final List searchBookList = ref.watch(bookModelProvider).searchBookList;
        final List borrowBooks = ref.watch(bookModelProvider).borrowBooks;
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
            final List<Widget> widgets = searchBookList
                .map(
                  (book) => GestureDetector(
                    child: ListTile(
                      title: Text(book.title),
                    ),
                    onTap: () {
                      borrowBooks.contains(book.id)
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckedOutBookPage(
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
                    },
                  ),
                )
                .toList();
            showSearch(
              context: context,
              delegate: SearchPage(
                items: searchBookList,
                searchLabel: '本の名前を入力してください',
                suggestion: const Center(
                  child: Text('ここにタイトルが表示されます'),
                ),
                failure: const Center(
                  child: Text('該当する本がありませんでした'),
                ),
                // 検索結果
                filter: (person) => [person.toString()],
                builder: (person) {
                  ref.watch(bookModelProvider).searchBookName(
                        person.toString(),
                      );
                  return Column(
                    children: widgets,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
