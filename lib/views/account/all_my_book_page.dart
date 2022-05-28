import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:tech_library/view_models/account_model.dart';
import 'package:tech_library/views/book_detail/return_book.dart';

class AllMyBookPage extends StatelessWidget {
  const AllMyBookPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: NewGradientAppBar(
        title: Text(
          '借りた本一覧',
          style: TextStyle(color: Colors.white.withOpacity(0.8)),
        ),
        elevation: 0,
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.lightBlue.shade200],
        ),
      ),
      body: ChangeNotifierProvider(
        create: (_) => AccountModel(),
        child: Consumer<AccountModel>(
          builder: (context, model, child) {
            model.fetchMyBook();
            final List<Widget> widgets = model.usersBook
                .map(
                  (myBook) => Stack(
                    children: [
                      GestureDetector(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 30,
                          ),
                          height: 200,
                          width: size.width * 0.35,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.5),
                              )
                            ],
                          ),
                          child: Image(
                            image: NetworkImage(myBook.imgURL),
                            fit: BoxFit.fill,
                          ),
                        ),
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReturnBook(book: myBook),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
                .toList();
            return SizedBox(
              height: size.height,
              child: SizedBox(
                height: size.height,
                width: size.width,
                child: SingleChildScrollView(
                  child: Wrap(children: widgets),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
