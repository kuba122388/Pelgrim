import 'package:cloud_firestore/cloud_firestore.dart';

class Contact{
  String? docId;
  final String role;
  final String description;

  Contact({required this.role, required this.description, this.docId});

  Map<String, dynamic> toMap(){
    return {
      'Role': role,
      'Description': description
    };
  }

  Future<void> addContact (String group) {
    return FirebaseFirestore.instance
        .collection('Pelgrim Groups')
        .doc(group)
        .collection('Contacts')
        .add(toMap());
  }

  Future<void> deleteContact (String group){
    return FirebaseFirestore.instance
        .collection('Pelgrim Groups')
        .doc(group)
        .collection('Contacts')
        .doc()
        .delete();
  }

  factory Contact.fromMap(Map<String, dynamic> map, docId){
    return Contact(
        docId: docId,
        role: map['Role'] ?? '',
        description: map['Description'] ?? '',

    );
  }

  static Future<List<Contact>> getContacts(String group) async{
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Pelgrim Groups')
        .doc(group)
        .collection('Contacts')
        .get();

    return querySnapshot.docs.map((doc) {
      return Contact.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();

  }

}