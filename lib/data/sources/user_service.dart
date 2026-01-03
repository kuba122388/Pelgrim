import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pelgrim/core/const/firebase_constants.dart';
import 'package:pelgrim/data/models/my_user_model.dart';

import 'package:pelgrim/domain/entities/my_user.dart';
import 'package:pelgrim/domain/entities/group_info.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> registerAdminWithGroup(MyUserModel user, GroupInfo group) async {
    final batch = _db.batch();

    try {
      final groupRef = _db.collection(FirebaseConstants.groupsCollection).doc(group.groupName);
      batch.set(groupRef, {
        'exists': true,
        'createdAt': FieldValue.serverTimestamp(),
      });

      final settingsRef = groupRef.collection('Settings').doc('main_settings');
      batch.set(settingsRef, group.toMap());

      final userRef = groupRef.collection('Users').doc(user.email);
      batch.set(userRef, user.toMap());

      await batch.commit();
    } catch (e) {
      throw Exception('Błąd podczas tworzenia grupy i użytkownika: $e');
    }
  }

  Future<void> registerAndJoinGroup(MyUserModel user, String groupName) async {
    try {
      await FirebaseFirestore.instance
          .collection(FirebaseConstants.groupsCollection)
          .doc(groupName)
          .collection(FirebaseConstants.usersCollection)
          .doc(user.email)
          .set(user.toMap());
    } catch (e) {
      throw Exception('Błąd podczas tworzenia użytkownika: $e');
    }
  }

  Future<MyUserModel?> getUserData(String email, String group) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection(FirebaseConstants.groupsCollection)
          .doc(group)
          .collection(FirebaseConstants.usersCollection)
          .doc(email.toLowerCase())
          .get();
      if (doc.exists) {
        return MyUserModel.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        print('Użytkownik nie został znaleziony');
        return null;
      }
    } catch (e) {
      print('Problem z załadowaniem danych użytkownika: $e');
      return null;
    }
  }

  Future<String> getUserGroup(String email) async {
    try {
      QuerySnapshot groupsSnapshot = await _db.collection(FirebaseConstants.groupsCollection).get();

      for (QueryDocumentSnapshot groupDoc in groupsSnapshot.docs) {
        DocumentReference userDocRef = groupDoc.reference.collection('Users').doc(email);
        DocumentSnapshot userDoc = await userDocRef.get();

        if (userDoc.exists) {
          return groupDoc.id;
        }
      }

      throw Exception("Nie znaleziono grupy dla podanego adresu e-mail.");
    } on FirebaseException catch (e) {
      throw Exception("Błąd bazy danych: ${e.message}");
    } catch (e) {
      throw Exception("Wystąpił nieoczekiwany błąd podczas szukania grupy.");
    }
  }

  Future<List<MyUserModel>> getAllUsersByGroup(String group) async {
    try {
      QuerySnapshot allUsersSnapshot = await FirebaseFirestore.instance
          .collection(FirebaseConstants.groupsCollection)
          .doc(group)
          .collection(FirebaseConstants.usersCollection)
          .get();

      List<MyUserModel> allUsers = allUsersSnapshot.docs.map((doc) {
        return MyUserModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      return allUsers;
    } catch (e) {
      print('Błąd przy pobieraniu użytkowników: $e');
      return [];
    }
  }

  Future<void> grantAdmin(bool grant, String email, String group) async {
    try {
      await FirebaseFirestore.instance
          .collection(FirebaseConstants.groupsCollection)
          .doc(group)
          .collection(FirebaseConstants.usersCollection)
          .doc(email)
          .update({"Admin": grant});
    } catch (e) {
      print("Problem z podnoszeniem uprawnień");
    }
  }
}
