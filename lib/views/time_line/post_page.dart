import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:search_page/search_page.dart';
import 'package:tech_library/error/show_error_dialog.dart';
import 'package:tech_library/models/book.dart';
import 'package:tech_library/view_models/time_line_model.dart';
import 'package:tech_library/views/time_line/post_book_image_page.dart';

class PostPage extends StatelessWidget {
  PostPage({Key? key, required this.postBook}) : super(key: key);
  Book? postBook;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: NewGradientAppBar(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.lightBlue.shade200],
        ),
        elevation: 0.0,
      ),
      body: ChangeNotifierProvider(
        create: (_) => TimeLineModel()..fetchPostBook(),
        child: Consumer<TimeLineModel>(
          builder: (context, model, child) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  GestureDetector(
                    child: SizedBox(
                      width: size.width * 0.35,
                      height: size.height * 0.28,
                      child: postBook != null
                          ? Image.network(
                              postBook!.imgURL,
                              fit: BoxFit.fill,
                            )
                          : Container(
                              color: Colors.grey,
                            ),
                    ),
                    onTap: () async {
                      showSearch(
                        context: context,
                        delegate: SearchPage<Book>(
                          items: model.postBook,
                          searchLabel: '本の名前を入力してください',
                          suggestion: const Center(
                            child: Text('ここにタイトルが表示されます'),
                          ),
                          failure: const Center(
                            child: Text('該当する本がありませんでした'),
                          ),
                          filter: (books) => [books.title],
                          builder: (book) {
                            return GestureDetector(
                              child: ListTile(
                                title: Text(book.title),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PostBookImagePage(postBook: book),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: model.postsCommentController,
                      decoration: InputDecoration(
                        hintText: 'コメントを入力してください',
                        hintStyle: TextStyle(
                          color: Colors.black.withOpacity(0.2),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (model.postsCommentController.text.isNotEmpty) {
                        model.postBooks = postBook;
                        model.setPost();
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      } else {
                        EasyLoading.dismiss();
                        showErrorDialog(context, 'コメントを入力してください');
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: size.height * 0.05),
                      width: size.width * 0.4,
                      height: size.height * 0.06,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue, Colors.lightBlue.shade100],
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        '投稿する',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.width * 0.04,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
