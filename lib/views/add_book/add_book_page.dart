import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:tech_library/error/show_error_dialog.dart';
import 'package:tech_library/view_models/book/add_book_model.dart';

class AddBookPage extends StatefulWidget {
  const AddBookPage({Key? key}) : super(key: key);

  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
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
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ),
          elevation: 0,
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.lightBlue.shade200],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Consumer<AddBookModel>(
            builder: (context, model, child) {
              return SingleChildScrollView(
                child: Form(
                  key: model.formKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        child: SizedBox(
                          width: size.width * 0.35,
                          height: size.height * 0.25,
                          child: model.imageFile != null
                              ? Image.file(model.imageFile!)
                              : Container(
                                  color: Colors.grey,
                                ),
                        ),
                        onTap: () {
                          model.pickImage();
                        },
                      ),
                      TextFormField(
                        controller: model.titleController,
                        decoration: const InputDecoration(
                          hintText: "タイトル",
                        ),
                        onChanged: (text) {
                          model.title = text;
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: model.authorController,
                        decoration: const InputDecoration(
                          hintText: "著者",
                        ),
                        onChanged: (text) {
                          model.author = text;
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      DropdownButton(
                        hint: const Text('選択してください'),
                        value: model.selectedGenre,
                        items: model.genre.map((String item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (genre) {
                          model.setGenre(genre.toString());
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
                                colors: [
                                  Colors.blue,
                                  Colors.lightBlue.shade100
                                ],
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              '登録する',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.width * 0.05,
                              ),
                            ),
                          ),
                        ),
                        onTap: () async {
                          try {
                            EasyLoading.show(status: 'loading...');
                            await model.addBook();
                            EasyLoading.showSuccess('登録しました。');
                            EasyLoading.dismiss();
                          } catch (e) {
                            EasyLoading.dismiss();
                            showErrorDialog(context, '全て入力してください。');
                          }
                        },
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
