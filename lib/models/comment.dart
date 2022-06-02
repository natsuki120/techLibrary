import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  Comment({
    this.id = '',
    this.authorId = '',
    this.author = '',
    this.authorImage = '',
    this.text = '',
    required this.createdAt,
  });
  String id;
  String authorId;
  String author;
  String authorImage;
  String text;
  Timestamp? createdAt;
}
