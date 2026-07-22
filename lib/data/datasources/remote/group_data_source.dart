import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pelgrim/core/const/firebase_constants.dart';
import 'package:pelgrim/data/models/group_model.dart';
import 'package:pelgrim/data/models/user_model.dart';

class GroupDataSource {
  final FirebaseFirestore _firestore;

  const GroupDataSource(this._firestore);

  Future<void> createGroup(GroupModel groupModel) async {
    await _firestore
        .collection(FirebaseConstants.groupsCollection)
        .doc(groupModel.id)
        .set(groupModel.toMap());
  }

  Future<GroupModel> getGroupById(String groupId) async {
    DocumentSnapshot docSnap =
        await _firestore.collection(FirebaseConstants.groupsCollection).doc(groupId).get();

    final data = docSnap.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception("Document not found");
    }

    return GroupModel.fromMap(data).copyWith(id: docSnap.id);
  }

  Future<List<GroupModel>> getAllGroups() async {
    final querySnapshot = await _firestore.collection(FirebaseConstants.groupsCollection).get();

    return querySnapshot.docs.map((doc) {
      return GroupModel.fromMap(doc.data()).copyWith(id: doc.id);
    }).toList();
  }

  Future<void> joinUserToGroup(String groupId, UserModel user) async {
    final batch = _firestore.batch();

    final globalUserRef =
        _firestore.collection(FirebaseConstants.globalUsersCollection).doc(user.id);

    final groupUserRef = _firestore
        .collection(FirebaseConstants.groupsCollection)
        .doc(groupId)
        .collection(FirebaseConstants.usersCollection)
        .doc(user.id);

    batch.set(globalUserRef, user.toMap());

    batch.set(
      groupUserRef,
      {
        "id": user.id,
        "is_admin": user.isAdmin,
        "first_name": user.firstName,
        "last_name": user.lastName,
      },
      SetOptions(merge: true),
    );

    await batch.commit();
  }

  Future<void> setAdminStatus(String groupId, UserModel user, bool isAdmin) async {
    final batch = _firestore.batch();

    final groupUserRef = _firestore
        .collection(FirebaseConstants.groupsCollection)
        .doc(groupId)
        .collection(FirebaseConstants.usersCollection)
        .doc(user.id);

    final globalUserRef =
        _firestore.collection(FirebaseConstants.globalUsersCollection).doc(user.id);

    batch.update(groupUserRef, {
      "id": user.id,
      "is_admin": isAdmin,
      "first_name": user.firstName,
      "last_name": user.lastName,
    });

    batch.update(globalUserRef, {
      "is_admin": isAdmin,
    });

    await batch.commit();
  }

  Future<void> deleteGroup(String groupId) async {
    await _firestore.collection(FirebaseConstants.groupsCollection).doc(groupId).delete();
  }
}
