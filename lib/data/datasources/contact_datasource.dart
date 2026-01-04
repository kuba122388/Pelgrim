import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pelgrim/core/const/firebase_constants.dart';
import 'package:pelgrim/data/models/contact_model.dart';

class ContactDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<ContactModel> getContactInfo(String groupName) async {
    try {
      DocumentSnapshot doc = await _db
          .collection(FirebaseConstants.groupsCollection)
          .doc(groupName)
          .collection(FirebaseConstants.contactsCollection)
          .doc('MainContact')
          .get();

      if (!doc.exists) throw Exception("No contact found.");

      final data = doc.data() as Map<String, dynamic>;

      return ContactModel.fromMap(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setContactInfo(String groupName, ContactModel contactModel) async {
    try {
      await _db
          .collection(FirebaseConstants.groupsCollection)
          .doc(groupName)
          .collection(FirebaseConstants.contactsCollection)
          .doc('MainContact')
          .set(contactModel.toMap());
    } catch (e) {
      rethrow;
    }
  }
}
