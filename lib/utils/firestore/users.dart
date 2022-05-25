import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tech_library/models/account.dart';
import '../authentication.dart';

class UserFirestore {
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference users =
      _firestoreInstance.collection('users');

  static Future<dynamic> setUser(Account newAccount) async {
    await users.doc(newAccount.id).set({
      'name': newAccount.name,
      'image_path': newAccount.imagePath,
    });
  }

  static Future<dynamic> fetchUser(String uid) async {
    DocumentSnapshot documentSnapshot = await users.doc(uid).get();
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    Account myAccount = Account(
      id: uid,
      name: data['name'],
      imagePath: data['image_path'],
    );
    Authentication.myAccount = myAccount;
  }
}
