import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:provider/provider.dart';
import '../../error/show_error_dialog.dart';
import '../../models/post.dart';
import '../../view_models/time_line_model.dart';

class EditPostPage extends StatelessWidget {
  EditPostPage({Key? key, required this.post}) : super(key: key);
  Post? post;

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
        create: (_) => TimeLineModel()
          ..fetchPostBook()
          ..fetchPostText(post!),
        child: Consumer<TimeLineModel>(
          builder: (context, model, child) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  const Text('画像は変更できません'),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  SizedBox(
                    width: size.width * 0.35,
                    height: size.height * 0.28,
                    child: post!.bookImage != null
                        ? Image.network(
                            post!.bookImage!,
                            fit: BoxFit.fill,
                          )
                        : Container(
                            color: Colors.grey,
                          ),
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: model.editController,
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
                      if (model.editController.text.isNotEmpty) {
                        model.update(post!);
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
                        '更新する',
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
