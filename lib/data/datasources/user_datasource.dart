import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pelgrim/core/const/firebase_constants.dart';
import 'package:pelgrim/data/models/group_model.dart';
import 'package:pelgrim/data/models/user_model.dart';

class UserDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> registerAdminWithGroup(UserModel user, GroupModel group) async {
    final batch = _db.batch();

    try {
      final groupRef = _db.collection(FirebaseConstants.groupsCollection).doc(group.groupName);
      batch.set(groupRef, {
        'exists': true,
        'createdAt': FieldValue.serverTimestamp(),
      });

      final settingsRef =
          groupRef.collection(FirebaseConstants.settingsCollection).doc('main_settings');
      batch.set(settingsRef, group.toMap());

      final userRef = groupRef.collection('Users').doc(user.email);
      batch.set(userRef, user.toMap());

      // NOTE: Stworzyć w FirebaseAuth uzytkownika i z uid stworzyć główna kolekcje

      await batch.commit();
    } catch (e) {
      throw Exception('Błąd podczas tworzenia grupy i użytkownika: $e');
    }
  }

  Future<void> registerAndJoinGroup(UserModel user, String groupName) async {
    try {
      await _db
          .collection(FirebaseConstants.groupsCollection)
          .doc(groupName)
          .collection(FirebaseConstants.usersCollection)
          .doc(user.email)
          .set(user.toMap());
    } catch (e) {
      throw Exception('Błąd podczas tworzenia użytkownika: $e');
    }
  }

  Future<UserModel?> getUserData(String email, String group) async {
    try {
      DocumentSnapshot doc = await _db
          .collection(FirebaseConstants.groupsCollection)
          .doc(group)
          .collection(FirebaseConstants.usersCollection)
          .doc(email.toLowerCase())
          .get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        print('Użytkownik nie został znaleziony');
        return null;
      }
    } catch (e) {
      print('Problem z załadowaniem danych użytkownika: $e');
      return null;
    }
  }

  Future<List<UserModel>> getAllUsersByGroup(String groupName) async {
    try {
      QuerySnapshot allUsersSnapshot = await _db
          .collection(FirebaseConstants.groupsCollection)
          .doc(groupName)
          .collection(FirebaseConstants.usersCollection)
          .get();

      List<UserModel> allUsers = allUsersSnapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      return allUsers;
    } catch (e) {
      print('Błąd przy pobieraniu użytkowników: $e');
      return [];
    }
  }
}
