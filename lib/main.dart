import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_library/model/book_model.dart';
import 'package:tech_library/view/menu/mypage/account_model.dart';
import 'package:tech_library/view/start_up/sign_in/sign_in_model.dart';
import 'package:tech_library/view/start_up/sign_up/sign_up_model.dart';
import 'view/start_up/sign_in/sign_in_page.dart';

final signupProvider = ChangeNotifierProvider(((ref) => SignUpModel()));
final signinProvider = ChangeNotifierProvider(((ref) => SignInModel()));
final bookModelProvider = ChangeNotifierProvider(((ref) => BookModel()));
final accountProvider = ChangeNotifierProvider(((ref) => AccountModel()));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SignInPage(),
      builder: EasyLoading.init(),
    );
  }
}
