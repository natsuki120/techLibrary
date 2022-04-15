import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:tech_library/view/bottom_nav/add_book/add_book_model.dart';

class AddBookPage extends StatefulWidget {
  const AddBookPage({Key? key}) : super(key: key);

  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  // 本のタイトル
  final titleKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  // 著者
  final authorKey = GlobalKey<FormState>();
  TextEditingController authorController = TextEditingController();

  List<String> genre = [
    'フロントエンド',
    'バックエンド',
    'ネイティブアプリ',
    'データサイエンス',
    '自己啓発',
    'その他'
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ChangeNotifierProvider<AddBookModel>(
      create: (_) => AddBookModel(),
      child: Scaffold(
        appBar: NewGradientAppBar(
          title: Center(
            child: Text(
              '新規投稿',
              style: TextStyle(color: Colors.white.withOpacity(0.8)),
            ),
          ),
          elevation: 0,
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.lightBlue.shade200],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Consumer<AddBookModel>(builder: (context, model, child) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    child: SizedBox(
                      width: size.width * 0.35,
                      height: size.height * 0.3,
                      child: model.imageFile != null
                          ? Image.file(model.imageFile!)
                          : Container(
                              color: Colors.grey,
                            ),
                    ),
                    onTap: () async {
                      await model.pickImage();
                    },
                  ),
                  Form(
                      key: titleKey,
                      child: TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          hintText: "タイトル",
                        ),
                        onChanged: (text) {
                          model.title = text;
                        },
                      )),
                  const SizedBox(
                    height: 8,
                  ),
                  Form(
                    key: authorKey,
                    child: TextFormField(
                      controller: authorController,
                      decoration: const InputDecoration(
                        hintText: "著者",
                      ),
                      onChanged: (text) {
                        model.author = text;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  DropdownButton(
                    hint: const Text('選択してください'),
                    value: model.selectedGenre,
                    items: genre.map((String item) {
                      return DropdownMenuItem(value: item, child: Text(item));
                    }).toList(),
                    onChanged: (genre) {
                      setState(() {
                        model.selectedGenre = genre as String;
                      });
                    },
                    isExpanded: true,
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    child: Center(
                      child: Container(
                        alignment: Alignment.center,
                        width: size.width * 0.5,
                        height: size.height * 0.1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.blue, Colors.lightBlue.shade100]),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          '登録する',
                          style: TextStyle(
                              color: Colors.white, fontSize: size.width * 0.05),
                        ),
                      ),
                    ),
                    onTap: () async {
                      if (titleKey.currentState!.validate() &&
                          authorKey.currentState!.validate() &&
                          model.imageFile != null) {
                        EasyLoading.show(status: 'loading...');
                        await model.addBook();
                        EasyLoading.dismiss();
                        authorController.clear();
                        titleController.clear();
                        model.imageFile!.delete;
                        return showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              title: const Text('登録しました'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () async {
                                    Navigator.pop(dialogContext);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        return showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              title: const Text('全て入力してください'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () async {
                                    Navigator.pop(dialogContext);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
