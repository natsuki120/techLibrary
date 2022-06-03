import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:tech_library/models/post.dart';
import 'package:tech_library/view_models/time_line_model.dart';
import 'package:tech_library/views/time_line/post_detail_page.dart';
import 'package:tech_library/views/time_line/post_page.dart';

class TimeLinePage extends StatelessWidget {
  const TimeLinePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ChangeNotifierProvider.value(
      value: TimeLineModel()..fetchPost(),
      child: Scaffold(
        appBar: NewGradientAppBar(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.lightBlue.shade200],
          ),
          elevation: 0.0,
        ),
        body: SizedBox(
          height: size.height,
          child: Consumer<TimeLineModel>(
            builder: (context, model, child) {
              return ListView.builder(
                itemCount: model.posts.length,
                itemBuilder: (context, index) {
                  Post post = model.posts[index];
                  return ChangeNotifierProvider.value(
                    value: TimeLineModel()..fetchPostComment(post),
                    child: Consumer<TimeLineModel>(
                      builder: (context, model, child) {
                        return GestureDetector(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            // 投稿のどこをタップしても遷移できるように設定
                            color: Colors.transparent,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      foregroundImage:
                                          NetworkImage(post.authorImage),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.02,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(post.author),
                                        Text(post.text),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                post.bookImage != null
                                    ? SizedBox(
                                        height: size.height * 0.3,
                                        child: Image.network(
                                          post.bookImage!,
                                          fit: BoxFit.fill,
                                          width: size.width * 0.4,
                                          height: size.height * 0.3,
                                        ),
                                      )
                                    : const SizedBox(),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                model.postComments.isNotEmpty
                                    ? Text('${model.postComments.length}件の返信')
                                    : const Text(''),
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PostDetailPage(post: post),
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
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostPage(postBook: null),
              ),
            );
          },
        ),
      ),
    );
  }
}
