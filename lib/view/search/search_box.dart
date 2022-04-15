import 'package:flutter/material.dart';
import 'package:tech_library/view/search/search_page.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 90, left: 20, right: 20),
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
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Text(
              'Search',
              style:
                  TextStyle(color: Colors.blue.withOpacity(0.5), fontSize: 16),
            )),
            Icon(
              Icons.search,
              color: Colors.blue.withOpacity(0.5),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.push((context),
            MaterialPageRoute(builder: (context) => const SearchPage()));
      },
    );
  }
}
