import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pelgrim/core/const/firebase_constants.dart';
import 'package:pelgrim/data/models/user_model.dart';

class UserDataSource {
  final FirebaseFirestore _firestore;

  const UserDataSource(this._firestore);

  Future<void> createUser(UserModel userModel) async {
    await _firestore
        .collection(FirebaseConstants.globalUsersCollection)
        .doc(userModel.id)
        .set(userModel.toMap());
  }

  Future<UserModel?> getUserById(String userId) async {
    final doc =
        await _firestore.collection(FirebaseConstants.globalUsersCollection).doc(userId).get();
    final data = doc.data();

    return data != null ? UserModel.fromMap(data) : null;
  }

  Future<List<UserModel>> getAllUsersByGroupId(String groupName) async {
    final allUsersSnapshot = await _firestore
        .collection(FirebaseConstants.groupsCollection)
        .doc(groupName)
        .collection(FirebaseConstants.usersCollection)
        .get();

    List<UserModel> allUsers = allUsersSnapshot.docs.map((doc) {
      return UserModel.fromMap(doc.data());
    }).toList();

    return allUsers;
  }
}
