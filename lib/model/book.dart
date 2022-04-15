import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  Book({this.name = '', this.imgURL = '', this.id = ''});
  String name;
  String imgURL;
  String id;
}
