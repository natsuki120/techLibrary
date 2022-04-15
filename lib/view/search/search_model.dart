import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchModel extends ChangeNotifier {
  String text = '';
  var searchList = <dynamic>{};
  var searchResultList = [];

  //　isEqualtoクエリだと部分一致ができない

  void searchBookName(String bookName) async {
    FirebaseFirestore.instance
        .collection('book')
        .get()
        .then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        searchList.add(doc.get('title'));
      }
      if (text.isNotEmpty) {
        // 何か文字が入力された実行する
        searchResultList.clear();
        // ここから検索処理
        for (var element in searchList) {
          if (element.contains(text)) {
            // .contains で文字列の部分一致を判定できる
            searchResultList.add(element);
          }
        }
      } else {
        searchResultList.clear();
      }
      notifyListeners();
    });
  }
}
