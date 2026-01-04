import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pelgrim/core/const/firebase_constants.dart';
import 'package:pelgrim/data/models/group_model.dart';

class GroupDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<GroupModel> getGroupInfo(String groupID) async {
    QuerySnapshot settings = await _db
        .collection(FirebaseConstants.groupsCollection)
        .doc(groupID)
        .collection(FirebaseConstants.settingsCollection)
        .get();

    if (settings.docs.isNotEmpty) {
      DocumentSnapshot docSnap = settings.docs.first;
      return GroupModel.fromMap(docSnap.data() as Map<String, dynamic>);
    } else {
      throw Exception('Missing Settings in $groupID group');
    }
  }

  Future<void> grantAdmin(String groupName, String userId, bool isAdmin) async {
    try {
      await _db
          .collection(FirebaseConstants.groupsCollection)
          .doc(groupName)
          .collection(FirebaseConstants.usersCollection)
          .doc(userId)
          .update({"Admin": isAdmin});
    } catch (e) {
      print("Problem z podnoszeniem uprawnień");
    }
  }
}
