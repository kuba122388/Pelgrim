import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pelgrim/core/const/firebase_constants.dart';
import 'package:pelgrim/data/models/song_model.dart';

class SongDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<SongModel>> watchSongs(String groupId) {
    return _db
        .collection(FirebaseConstants.groupsCollection)
        .doc(groupId)
        .collection(FirebaseConstants.songsCollection)
        .orderBy('title')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((d) => SongModel.fromMap(d.data(), d.id)).toList());
  }

  Future<void> streamSong(String groupId, SongModel song) async {
    await _db.collection(FirebaseConstants.groupsCollection).doc(groupId).update({
      'playingNow': song.toMap(),
    });
  }

  Stream<SongModel?> getPlayingNowStream(String groupId) {
    return _db
        .collection(FirebaseConstants.groupsCollection)
        .doc(groupId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) return null;

      final data = snapshot.data();
      if (data == null) return null;

      if (data['playingNow'] == null) return null;

      return SongModel.fromMap(
        data['playingNow'] as Map<String, dynamic>,
        null,
      );
    });
  }

  Future<void> addSong(String groupId, SongModel song) async {
    await _db
        .collection(FirebaseConstants.groupsCollection)
        .doc(groupId)
        .collection(FirebaseConstants.songsCollection)
        .add(song.toMap());
  }

  Future<void> editSong(String groupId, SongModel song) async {
    await _db
        .collection(FirebaseConstants.groupsCollection)
        .doc(groupId)
        .collection(FirebaseConstants.songsCollection)
        .doc(song.id)
        .set(song.toMap());
  }

  Future<SongModel?> getSong(String groupId, String songId) async {
    final DocumentSnapshot<Map<String, dynamic>> docSnap = await _db
        .collection(FirebaseConstants.groupsCollection)
        .doc(groupId)
        .collection(FirebaseConstants.songsCollection)
        .doc(songId)
        .get();

    if (!docSnap.exists || docSnap.data() == null) {
      return null;
    }

    return SongModel.fromMap(
      docSnap.data()!,
      songId,
    );
  }

  Future<void> deleteSong(String groupId, String songId) async {
    _db
        .collection(FirebaseConstants.groupsCollection)
        .doc(groupId)
        .collection(FirebaseConstants.songsCollection)
        .doc(songId)
        .delete();
  }
}
