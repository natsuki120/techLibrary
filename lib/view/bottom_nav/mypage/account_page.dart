import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:tech_library/model/account.dart';
import 'package:tech_library/utils/authentication.dart';
import 'package:tech_library/utils/firestore/users.dart';
import 'package:tech_library/view/bottom_nav/mypage/all_my_book_page.dart';
import 'package:tech_library/view/book_detail/return_book.dart';
import '../../../utils/firestore/books.dart';
import '../../book_list/book_list_model.dart';
import '../../book_detail/borrow_book_page.dart';
import '../../book_detail/checked_out_book_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Account myAccount = Authentication.myAccount!;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: NewGradientAppBar(
        elevation: 0,
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.lightBlue.shade200],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // プロフィール蘭
            Stack(
              children: [
                Container(
                  height: size.height * 0.3,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.blue, Colors.lightBlue.shade200])),
                  child: Column(
                    children: [
                      Container(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              SizedBox(
                                height: size.height * 0.2,
                                width: size.width * 0.3,
                                child: CircleAvatar(
                                  foregroundImage:
                                      NetworkImage(myAccount.imagePath),
                                ),
                              ),
                            ],
                          )),
                      Text(myAccount.name,
                          style: TextStyle(
                              fontSize: size.height * 0.04,
                              color: Colors.white.withOpacity(0.9)))
                    ],
                  ),
                ),
              ],
            ),
            // 借りている本
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 20, left: 25),
                      child: Text('借りた本',
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
                                builder: (context) => const AllMyBookPage(
                                  title: '借りた本一覧',
                                  collection: 'my_book',
                                ),
                              ));
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.3,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(Authentication.myAccount!.id)
                          .collection('my_book')
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                Map<String, dynamic> data =
                                    document.data()! as Map<String, dynamic>;
                                return GestureDetector(
                                  child: Container(
                                    margin: const EdgeInsets.all(10),
                                    height: 200,
                                    width: size.width * 0.35,
                                    decoration: BoxDecoration(boxShadow: [
                                      BoxShadow(
                                        blurRadius: 10,
                                        color: Colors.black.withOpacity(0.5),
                                      )
                                    ]),
                                    child: Image(
                                        image: NetworkImage(data['imgURL']),
                                        fit: BoxFit.fill),
                                  ),
                                  onTap: () async {
                                    UserFirestore.getMyBook();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ReturnBook(
                                                  bookInfo: document.id,
                                                  bookImg: data['imgURL'],
                                                  bookName: data['name'],
                                                )));
                                  },
                                );
                              }).toList(),
                            ),
                          );
                        } else {
                          return Container(
                              height: size.height * 0.1,
                              alignment: Alignment.center,
                              child: const Text('借りている本はありません'));
                        }
                      }),
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 20, left: 25),
                      child: Text('お気に入り',
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
                                builder: (context) => const AllMyBookPage(
                                  title: 'お気に入り一覧',
                                  collection: 'favorite',
                                ),
                              ));
                        },
                      ),
                    ),
                  ],
                ),
                // お気に入り本
                ChangeNotifierProvider<BookListModel>.value(
                    value: BookListModel(),
                    child: Consumer<BookListModel>(
                        builder: (context, model, child) {
                      final List borrowBook = model.borrowBooks;
                      return SizedBox(
                        height: size.height * 0.3,
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(Authentication.myAccount!.id)
                              .collection('favorite')
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: snapshot.data!.docs
                                      .map((DocumentSnapshot document) {
                                    Map<String, dynamic> data = document.data()!
                                        as Map<String, dynamic>;
                                    return Stack(
                                      children: [
                                        GestureDetector(
                                          child: Container(
                                            margin: const EdgeInsets.all(10),
                                            height: 200,
                                            width: size.width * 0.35,
                                            decoration:
                                                BoxDecoration(boxShadow: [
                                              BoxShadow(
                                                blurRadius: 10,
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                              )
                                            ]),
                                            child: Image(
                                                image: NetworkImage(
                                                    data['imgURL']),
                                                fit: BoxFit.fill),
                                          ),
                                          onTap: () async {
                                            var result =
                                                await BookFirestore.getBook(
                                                    'favorite');
                                            if (result is List) {
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
                                                                bookName: data[
                                                                    'name'],
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
                                                                    'name'],
                                                                author: data[
                                                                    'author'],
                                                              )));
                                            }
                                          },
                                        ),
                                        borrowBook.contains(document.id)
                                            ? Container(
                                                margin: const EdgeInsets.only(
                                                    left: 5),
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
                              );
                            } else {
                              return const Text('something went wrong');
                            }
                          },
                        ),
                      );
                    }))
              ],
            )
          ],
        ),
      ),
    );
  }
}
