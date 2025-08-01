import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  final String description;

  Contact({required this.description});

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
    };
  }

  static Future<Contact?> get(String group) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('Pelgrim Groups')
        .doc(group)
        .collection('Contacts')
        .doc('MainContact')
        .get();

    if (!doc.exists) return null;

    final data = doc.data() as Map<String, dynamic>;
    return Contact.fromMap(data);
  }


  Future<void> save(String group) async {
    await FirebaseFirestore.instance
        .collection('Pelgrim Groups')
        .doc(group)
        .collection('Contacts')
        .doc('MainContact')
        .set(toMap());
  }

}
