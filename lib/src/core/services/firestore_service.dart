import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/src/features/auth/models/user_model.dart';


class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String usersCollection = 'users';

  Future<void> createUser(UserModel user) async {
    final docRef = _db.collection(usersCollection).doc(user.uid);
    await docRef.set(user.toJson(), SetOptions(merge: true));
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _db.collection(usersCollection).doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromJson(doc.data()!);
  }

  Stream<UserModel?> streamUser(String uid) {
    return _db.collection(usersCollection).doc(uid).snapshots().map((snap) {
      if (!snap.exists) return null;
      return UserModel.fromJson(snap.data()!);
    });
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection(usersCollection).doc(uid).set(data, SetOptions(merge: true));
  }
}
