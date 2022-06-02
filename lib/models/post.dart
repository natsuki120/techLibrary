import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  Post({
    this.id = '',
    this.author = '',
    this.authorId = '',
    this.authorImage = '',
    this.bookImage = '',
    this.text = '',
    required this.createdAt,
  });
  String id;
  String author;
  String authorId;
  String authorImage;
  String? bookImage;
  String text;
  Timestamp? createdAt;
}
