import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:tech_library/models/post.dart';
import 'package:tech_library/utils/authentication.dart';
import 'package:tech_library/view_models/time_line_model.dart';
import 'package:tech_library/views/time_line/edit_post_page.dart';

class PostDetailPage extends StatelessWidget {
  PostDetailPage({Key? key, required this.post}) : super(key: key);
  Post post;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ChangeNotifierProvider.value(
      value: TimeLineModel()..fetchPostComment(post),
      child: Scaffold(
        appBar: NewGradientAppBar(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.lightBlue.shade200],
          ),
          elevation: 0.0,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Consumer<TimeLineModel>(
            builder: (context, model, child) {
              final comments = model.postComments
                  .map(
                    (comment) => comment.authorId ==
                            Authentication.myAccount!.id
                        ? Slidable(
                            endActionPane: ActionPane(
                              motion: const DrawerMotion(),
                              children: [
                                SlidableAction(
                                  label: '削除',
                                  backgroundColor: Colors.red,
                                  icon: Icons.delete,
                                  onPressed: (context) async {
                                    await model.deleteComment(post, comment.id);
                                  },
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  height: size.height * 0.1,
                                ),
                                CircleAvatar(
                                  foregroundImage:
                                      NetworkImage(comment.authorImage),
                                ),
                                SizedBox(
                                  width: size.width * 0.02,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(comment.author),
                                    Text(comment.text),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Row(
                            children: [
                              SizedBox(
                                height: size.height * 0.1,
                              ),
                              CircleAvatar(
                                foregroundImage:
                                    NetworkImage(comment.authorImage),
                              ),
                              SizedBox(
                                width: size.width * 0.02,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(comment.author),
                                  Text(comment.text),
                                ],
                              ),
                            ],
                          ),
                  )
                  .toList();
              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(post.author),
                                    Text(post.text),
                                  ],
                                ),
                              ],
                            ),
                            post.authorId == Authentication.myAccount!.id
                                ? Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditPostPage(post: post),
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.edit),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (_) {
                                              return AlertDialog(
                                                content: const Text("削除しますか？"),
                                                actions: [
                                                  TextButton(
                                                    child: const Text("いいえ"),
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                  ),
                                                  TextButton(
                                                    child: const Text("はい"),
                                                    onPressed: () async {
                                                      model.deletePost(post);
                                                      Navigator.of(context)
                                                          .popUntil((route) =>
                                                              route.isFirst);
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        icon: const Icon(Icons.delete),
                                      ),
                                    ],
                                  )
                                : Container(),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        post.bookImage != null
                            ? SizedBox(
                                width: size.width * 0.4,
                                height: size.height * 0.3,
                                child: Image.network(
                                  post.bookImage!,
                                  fit: BoxFit.fill,
                                ),
                              )
                            : const SizedBox(),
                        SizedBox(
                          height: size.height * 0.06,
                        ),
                        Column(
                          children: comments,
                        ),
                        SizedBox(
                          height: size.height * 0.2,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                        top: size.height * 0.13,
                      ),
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
                      child: TextField(
                        controller: model.commentController,
                        decoration: InputDecoration(
                          hintText: 'コメントを書いてみましょう！',
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => model.setComment(post),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
