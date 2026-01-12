import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pelgrim/core/const/firebase_constants.dart';
import 'package:pelgrim/data/models/duty_model.dart';
import 'package:pelgrim/data/models/duty_volunteer_model.dart';

class DutyDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addDuty(String groupId, DutyModel dutyModel) async {
    try {
      await _db
          .collection(FirebaseConstants.groupsCollection)
          .doc(groupId)
          .collection(FirebaseConstants.dutiesCollection)
          .add(dutyModel.toMap());
    } catch (e) {
      print('Nie udało się dodać dyżuru: $e');
      rethrow;
    }
  }

  Future<void> deleteDuty(String groupId, String dutyId) async {
    try {
      await _db
          .collection(FirebaseConstants.groupsCollection)
          .doc(groupId)
          .collection(FirebaseConstants.dutiesCollection)
          .doc(dutyId)
          .delete();
    } catch (e) {
      print('Nie udało się usunąć dyżuru: $e');
      rethrow;
    }
  }

  Stream<List<DutyModel>> getDutiesStream(String group) {
    return _db
        .collection(FirebaseConstants.groupsCollection)
        .doc(group)
        .collection(FirebaseConstants.dutiesCollection)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) => DutyModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  Future<void> addVolunteer(
    String groupId,
    String dutyId,
    DutyVolunteerModel volunteer,
  ) async {
    try {
      final dutyRef = _db
          .collection(FirebaseConstants.groupsCollection)
          .doc(groupId)
          .collection(FirebaseConstants.dutiesCollection)
          .doc(dutyId);

      dutyRef.update({
        "volunteers": FieldValue.arrayUnion([volunteer.toMap()]),
      });
    } catch (e) {
      print('Błąd podczas dodawania wolontariusza: $e');
      rethrow;
    }
  }

  Future<void> removeVolunteer(
    String groupId,
    String dutyId,
    DutyVolunteerModel volunteer,
  ) async {
    try {
      final dutyRef = _db
          .collection(FirebaseConstants.groupsCollection)
          .doc(groupId)
          .collection(FirebaseConstants.dutiesCollection)
          .doc(dutyId);

      await dutyRef.update({
        "volunteers": FieldValue.arrayRemove([volunteer.toMap()]),
      });
    } catch (e) {
      print('Błąd podczas usuwania wolontariusza: $e');
      rethrow;
    }
  }
}
