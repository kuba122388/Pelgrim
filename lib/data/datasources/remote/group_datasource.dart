import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pelgrim/core/const/firebase_constants.dart';
import 'package:pelgrim/data/models/group_model.dart';

class GroupDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createGroup(GroupModel groupModel) async {
    await _db
        .collection(FirebaseConstants.groupsCollection)
        .doc(groupModel.id)
        .set(groupModel.toMap());
  }

  Future<GroupModel> getGroup(String groupId) async {
    DocumentSnapshot docSnap =
        await _db.collection(FirebaseConstants.groupsCollection).doc(groupId).get();

    // NOTE: ZMIENIĆ MIEJSCE USTAWIEŃ W FIREBASE

    return GroupModel.fromMap(docSnap.data() as Map<String, dynamic>);
  }

  Future<List<String>> getAllGroupNames() async {
    final querySnapshot = await _db.collection(FirebaseConstants.groupsCollection).get();

    return querySnapshot.docs.map((doc) {
      return doc.id;
    }).toList();
  }

  Future<void> joinUserToGroup(String groupId, String userId, bool isAdmin) async {
    final batch = _db.batch();

    final globalUserRef = _db.collection(FirebaseConstants.globalUsersCollection).doc(userId);

    final groupUserRef = _db
        .collection(FirebaseConstants.groupsCollection)
        .doc(groupId)
        .collection(FirebaseConstants.usersCollection)
        .doc(userId);

    batch.set(
      globalUserRef,
      {
        "groupName": groupId,
        "isAdmin": isAdmin,
      },
      SetOptions(merge: true),
    );

    batch.set(groupUserRef, {
      "isAdmin": isAdmin,
    });

    await batch.commit();
  }

  Future<void> setAdminStatus(String groupId, String userId, bool isAdmin) async {
    final batch = _db.batch();

    final globalUserRef = _db.collection(FirebaseConstants.globalUsersCollection).doc(userId);

    final groupUserRef = _db
        .collection(FirebaseConstants.groupsCollection)
        .doc(groupId)
        .collection(FirebaseConstants.usersCollection)
        .doc(userId);

    batch.update(globalUserRef, {
      "isAdmin": isAdmin,
    });

    batch.update(groupUserRef, {
      "isAdmin": isAdmin,
    });

    await batch.commit();
  }

  Future<void> deleteGroup(String groupId) async {
    await _db.collection(FirebaseConstants.groupsCollection).doc(groupId).delete();
  }
}
