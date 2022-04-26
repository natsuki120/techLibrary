import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils/firestore/users.dart';
import '../../../book_detail/return_book.dart';
import '../account/account_model.dart';
import '../all_my_book_page.dart';

class MyBook extends StatelessWidget {
  const MyBook({Key? key}) : super(key: key);

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
                '借りた本',
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
                        title: '借りた本一覧',
                        collection: 'my_book',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        ChangeNotifierProvider<AccountModel>(
          create: (_) => AccountModel()..getMyBook(),
          child: Consumer<AccountModel>(
            builder: (context, model, child) {
              final List? usersBook = model.usersBook;
              if (usersBook == null) {
                return const Text('借りている本はありません');
              }
              final List<Widget> widgets = usersBook.map((book) {
                return GestureDetector(
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
                      image: NetworkImage(book.imgURL),
                      fit: BoxFit.fill,
                    ),
                  ),
                  onTap: () async {
                    UserFirestore.getMyBook();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReturnBook(
                          bookInfo: book.id,
                          bookImg: book.imgURL,
                          bookName: book.title,
                          author: book.author,
                        ),
                      ),
                    );
                  },
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
        )
      ],
    );
  }
}
