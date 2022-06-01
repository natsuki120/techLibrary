import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:tech_library/models/book.dart';
import 'package:tech_library/view_models/time_line_model.dart';
import 'package:tech_library/views/time_line/post_page.dart';

class PostBookImagePage extends StatelessWidget {
  const PostBookImagePage({Key? key, required this.postBook}) : super(key: key);
  final Book postBook;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
      create: (_) => TimeLineModel(),
      child: Consumer<TimeLineModel>(builder: (context, model, child) {
        return Scaffold(
          appBar: NewGradientAppBar(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlue.shade200],
            ),
            elevation: 0.0,
          ),
          body: Stack(
            children: [
              Container(
                height: size.height * 0.35,
                padding: EdgeInsets.only(bottom: size.height * 0.04),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.blue, Colors.lightBlue.shade200]),
                ),
                child: SizedBox(
                  child: Image.network(postBook.imgURL),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: size.height * 0.49,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // 本の名前
                          Container(
                            alignment: Alignment.center,
                            width: size.width * 0.7,
                            child: Text(
                              postBook.title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: size.height * 0.035,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                          Container(
                            height: size.height * 0.1,
                          ),
                          GestureDetector(
                            child: Center(
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 30),
                                alignment: Alignment.center,
                                width: size.width * 0.8,
                                height: size.height * 0.15,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue,
                                      Colors.lightBlue.shade100
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  'この本の画像を使う',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.width * 0.05,
                                      letterSpacing: 2.0),
                                ),
                              ),
                            ),
                            onTap: () async {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => PostPage(postBook: postBook),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
