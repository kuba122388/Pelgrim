import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pelgrim/dbfeatures/MyUser.dart';

class Duty {
  String id;
  String title;
  int maxVolunteers;
  List<MyUser> volunteers;
  Timestamp createdAt;

  Duty({
    this.id = "",
    required this.title,
    required this.maxVolunteers,
    this.volunteers = const [],
    Timestamp? createdAt,
  }) : createdAt = createdAt ?? Timestamp.now();

  Map<String, dynamic> toMap() {
    return {
      'Title': title,
      'MaxVolunteers': maxVolunteers,
      'Volunteers': volunteers.map((v) => v.toMapUser()).toList(),
      'CreatedAt': createdAt,
    };
  }

  factory Duty.fromMap(Map<String, dynamic> map, String docId) {
    List<MyUser> parsedVolunteers = [];

    if (map["Volunteers"] != null) {
      parsedVolunteers = List<Map<String, dynamic>>.from(map["Volunteers"])
          .map((userMap) => MyUser.fromMap(userMap))
          .toList();
    }

    return Duty(
      id: docId,
      title: map["Title"] ?? "",
      maxVolunteers: map["MaxVolunteers"] ?? 0,
      volunteers: parsedVolunteers,
      createdAt: map["CreatedAt"] ?? Timestamp.now(),
    );
  }


  Future<void> addDuty(String group) async {
    try {
      await FirebaseFirestore.instance
          .collection('Pelgrim Groups')
          .doc(group)
          .collection('Duties')
          .add(toMap());
    } catch (e) {
      print('Problem with adding a duty: $e');
    }
  }

  static Future<List<Duty>> loadDuties(String group) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Pelgrim Groups')
          .doc(group)
          .collection('Duties')
          .get();

      return snapshot.docs
          .map((doc) => Duty.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Problem with loading duties: $e');
      return [];
    }
  }
}
