import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  final String? id;
  final String author;
  final String content;
  final DateTime date;
  final bool important;
  final bool anonymous;

  Announcement(
      {this.id,
      required this.author,
      required this.content,
      required this.date,
      required this.important,
      required this.anonymous});

  Map<String, dynamic> toMap() {
    return {
      'Author': author,
      'Content': content,
      'Date': date,
      'Important': important,
      'Anonymous': anonymous
    };
  }

  Future<void> save(String group) async {
    FirebaseFirestore.instance
        .collection('Pelgrim Groups')
        .doc(group)
        .collection('Announcements')
        .add(toMap());
  }

  Future<void> delete(String group) async {
    await FirebaseFirestore.instance
        .collection('Pelgrim Groups')
        .doc(group)
        .collection('Announcements')
        .doc(id)
        .delete();
  }

  factory Announcement.fromJson(Map<String, dynamic> json, String docId) {
    return Announcement(
        id: docId,
        author: (json['Author'] ?? '').replaceAll(RegExp(r'\s+'), ' ').trim(),
        content: json['Content'] ?? '',
        date: json['Date'].toDate() ?? '',
        important: json['Important'],
        anonymous: json['Anonymous']);
  }

  static Stream<List<Announcement>> loadAnnouncementsAsStream(String group) {
    try {
      return FirebaseFirestore.instance
          .collection('Pelgrim Groups')
          .doc(group)
          .collection('Announcements')
          .orderBy('Date', descending: true)
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return Announcement.fromJson(doc.data(), doc.id);
        }).toList();
      });
    } catch (e) {
      print('Problem z załadowaniem ogłoszeń: $e');
      return Stream.value([]);
    }
  }
}
