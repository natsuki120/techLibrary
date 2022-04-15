import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:tech_library/view/book_detail/return_book.dart';
import '../../../utils/authentication.dart';
import '../../../utils/firestore/users.dart';

class AllMyBookPage extends StatelessWidget {
  const AllMyBookPage({Key? key, required this.collection, required this.title})
      : super(key: key);
  final String collection;
  final String title;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: NewGradientAppBar(
          title: Text(
            title,
            style: TextStyle(color: Colors.white.withOpacity(0.8)),
          ),
          elevation: 0,
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.lightBlue.shade200],
          ),
        ),
        body: SizedBox(
          height: size.height,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(Authentication.myAccount!.id)
                .collection(collection)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
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
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 30),
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
                              ),
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
        ));
  }
}
