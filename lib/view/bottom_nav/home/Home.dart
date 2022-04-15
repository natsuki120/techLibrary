import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:tech_library/view/contents.dart';
import '../../search/search_box.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: NewGradientAppBar(
        elevation: 0,
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.lightBlue.shade200],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                // 上の検索窓の背景
                Container(
                  height: size.height * 0.15,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(36),
                        bottomLeft: Radius.circular(36),
                      ),
                      gradient: LinearGradient(
                          colors: [Colors.blue, Colors.lightBlue.shade200])),
                ),
                // 検索窓
                const SearchBox(),
              ],
            ),
            // 本の表示
            const Contents(),
          ],
        ),
      ),
    );
  }
}
