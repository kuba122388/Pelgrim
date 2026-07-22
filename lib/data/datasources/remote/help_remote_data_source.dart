import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/help_request.dart';

class HelpDataSource {
  final FirebaseFirestore _db;

  HelpDataSource(this._db);

  Future<void> sendHelpRequest(HelpRequest request) async {
    final emailKey = request.userEmail.replaceAll(RegExp(r'[@.]'), '_');

    await _db.collection('problems').doc(request.groupId).collection(emailKey).add({
      'title': request.title,
      'content': request.content,
      'solved': false,
    });
  }
}
