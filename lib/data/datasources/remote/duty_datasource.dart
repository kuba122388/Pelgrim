import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pelgrim/core/const/firebase_constants.dart';
import 'package:pelgrim/data/models/duty_model.dart';

class DutyDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addDuty(String group, DutyModel dutyModel) async {
    try {
      await _db
          .collection(FirebaseConstants.groupsCollection)
          .doc(group)
          .collection(FirebaseConstants.dutiesCollection)
          .add(dutyModel.toMap());
    } catch (e) {
      print('Nie udało się dodać dyżuru: $e');
      rethrow;
    }
  }

  Future<void> deleteDuty(String group, String dutyId) async {
    try {
      await _db
          .collection(FirebaseConstants.groupsCollection)
          .doc(group)
          .collection(FirebaseConstants.dutiesCollection)
          .doc(dutyId)
          .delete();
    } catch (e) {
      print('Nie udało się usunąć dyżuru: $e');
      rethrow;
    }
  }

  Stream<List<DutyModel>> getDutiesStream(String group) {
    try {
      return _db
          .collection(FirebaseConstants.groupsCollection)
          .doc(group)
          .collection(FirebaseConstants.dutiesCollection)
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) => DutyModel.fromMap(doc.data(), doc.id)).toList();
      });
    } catch (e) {
      print('Problem z pobraniem listy dyżurów: $e');
      rethrow;
    }
  }
}
