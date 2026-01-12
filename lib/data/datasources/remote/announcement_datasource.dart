import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pelgrim/core/const/firebase_constants.dart';
import 'package:pelgrim/data/models/announcement_model.dart';

class AnnouncementDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addAnnouncement(String groupName, AnnouncementModel announcement) async {
    try {
      await _db
          .collection(FirebaseConstants.groupsCollection)
          .doc(groupName)
          .collection(FirebaseConstants.announcementsCollection)
          .add(announcement.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAnnouncement(String groupName, String announcementId) async {
    try {
      await _db
          .collection(FirebaseConstants.groupsCollection)
          .doc(groupName)
          .collection(FirebaseConstants.announcementsCollection)
          .doc(announcementId)
          .delete();
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<AnnouncementModel>> getAnnouncementsStream(String groupName) {
    return _db
        .collection(FirebaseConstants.groupsCollection)
        .doc(groupName)
        .collection(FirebaseConstants.announcementsCollection)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return AnnouncementModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }
}
