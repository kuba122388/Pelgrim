import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pelgrim/domain/models/group_info.dart';

class GroupService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<GroupInfo> getGroupInfo(String groupID) async {
    QuerySnapshot settings =
        await _db.collection('Pelgrim Groups').doc(groupID).collection('Settings').get();

    if (settings.docs.isNotEmpty) {
      DocumentSnapshot docSnap = settings.docs.first;
      return GroupInfo.fromJson(docSnap.data() as Map<String, dynamic>);
    } else {
      throw Exception('Missing Settings in $groupID group');
    }
  }
}
