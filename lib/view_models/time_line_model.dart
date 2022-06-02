import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tech_library/models/comment.dart';
import 'package:tech_library/models/post.dart';
import 'package:tech_library/utils/authentication.dart';
import '../models/book.dart';

class TimeLineModel extends ChangeNotifier {
  List<Book> postBook = [];
  List<Post> posts = [];
  List<Comment> postComments = [];
  Book? postBooks;
  final picker = ImagePicker();
  TextEditingController postsCommentController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  static final _firestoreInstance = FirebaseFirestore.instance;

  void fetchPostBook() {
    final Stream<QuerySnapshot> snapshots =
        _firestoreInstance.collection('book').snapshots();

    snapshots.listen((QuerySnapshot snapshot) {
      final postBook = snapshot.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        return Book(title: data['title'], imgURL: data['imgURL']);
      }).toList();
      this.postBook = postBook;
    });
  }

  void setPost() async {
    final postDoc = _firestoreInstance.collection('posts').doc();
    final usersPostDoc = _firestoreInstance
        .collection('users')
        .doc(Authentication.myAccount!.id)
        .collection('usersPosts')
        .doc();

    await postDoc.set({
      'id': postDoc.id,
      'author': Authentication.myAccount!.name,
      'authorId': Authentication.myAccount!.id,
      'authorImage': Authentication.myAccount!.imagePath,
      'bookImage': postBooks?.imgURL,
      'text': postsCommentController.text,
      'createdAt': Timestamp.now(),
    });

    await usersPostDoc.set({
      'postsId': postDoc.id,
    });

    postsCommentController.clear();
    notifyListeners();
  }

  void fetchPost() {
    final Stream<QuerySnapshot> snapshots = _firestoreInstance
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots();

    snapshots.listen((QuerySnapshot snapshot) {
      final List<Post> posts = snapshot.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        return Post(
          id: data['id'],
          author: data['author'],
          authorId: data['authorId'],
          authorImage: data['authorImage'],
          bookImage: data['bookImage'],
          text: data['text'],
          createdAt: data['createdAt'],
        );
      }).toList();
      this.posts = posts;
      notifyListeners();
    });
  }

  void deletePost(Post post) {
    final DocumentReference snapshot =
        _firestoreInstance.collection('posts').doc(post.id);
    snapshot.delete();
    final usersPostDoc = _firestoreInstance
        .collection('users')
        .doc(Authentication.myAccount!.id)
        .collection('usersPosts')
        .doc();
    usersPostDoc.delete();
  }

  void setComment(Post post) async {
    final postCommentDoc = _firestoreInstance
        .collection('posts')
        .doc(post.id)
        .collection('postsComments')
        .doc();

    await postCommentDoc.set({
      'id': postCommentDoc.id,
      'authorId': Authentication.myAccount!.id,
      'author': Authentication.myAccount!.name,
      'author_image': Authentication.myAccount!.imagePath,
      'text': commentController.text,
      'createdAt': Timestamp.now(),
    });
    commentController.clear();
    notifyListeners();
  }

  void fetchPostComment(Post post) {
    final Stream<QuerySnapshot> snapshots = _firestoreInstance
        .collection('posts')
        .doc(post.id)
        .collection('postsComments')
        .orderBy('createdAt', descending: false)
        .snapshots();

    snapshots.listen((QuerySnapshot snapshot) {
      final List<Comment> comments =
          snapshot.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        return Comment(
          id: data['id'],
          author: data['author'],
          authorId: data['authorId'],
          authorImage: data['author_image'],
          text: data['text'],
          createdAt: data['createdAt'],
        );
      }).toList();
      postComments = comments;
      notifyListeners();
    });
  }

  deleteComment(Post post, String postCommentId) {
    final CollectionReference comment = _firestoreInstance
        .collection('posts')
        .doc(post.id)
        .collection('postsComments');
    comment.doc(postCommentId).delete();
  }
}
