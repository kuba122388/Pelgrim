import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pelgrim/core/const/firebase_constants.dart';
import 'package:pelgrim/data/models/song_model.dart';

class SongDataSource {
  Future<List<SongModel>> loadSongs(String groupName) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(FirebaseConstants.groupsCollection)
          .doc(groupName)
          .collection(FirebaseConstants.songsCollection)
          .orderBy('Title', descending: false)
          .get();
      return querySnapshot.docs.map((doc) {
        return SongModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Problem z załadowaniem ogłoszeń: $e');
      return [];
    }
  }

  Future<void> requestSong(String groupName, SongModel song) async {
    try {
      await FirebaseFirestore.instance
          .collection(FirebaseConstants.groupsCollection)
          .doc(groupName)
          .update({
        'playingNow': song.toMap(),
      });
    } catch (e) {
      print('Problem z ustawieniem aktualnie granej piosenki: $e}');
    }
  }

  Stream<SongModel> watchPlayingNow(String groupName) {
    return FirebaseFirestore.instance
        .collection(FirebaseConstants.groupsCollection)
        .doc(groupName)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data() as Map<String, dynamic>;

        if (data.containsKey('playingNow') && data['playingNow'] != null) {
          return SongModel.fromMap(
            data['playingNow'] as Map<String, dynamic>,
            null,
          );
        }
      }

      return SongModel(title: 'Brak granej piosenki', lyrics: '');
    });
  }

  Future<void> addSong(String groupName, SongModel song) async {
    try {
      await FirebaseFirestore.instance
          .collection(FirebaseConstants.groupsCollection)
          .doc(groupName)
          .collection(FirebaseConstants.songsCollection)
          .add(song.toMap());
    } catch (e) {
      print('Problem with adding a song: $e}');
    }
  }

  Future<void> editSong(String groupName, SongModel song) async {
    try {
      await FirebaseFirestore.instance
          .collection(FirebaseConstants.groupsCollection)
          .doc(groupName)
          .collection(FirebaseConstants.songsCollection)
          .doc(song.id)
          .set(song.toMap());
    } catch (e) {
      print('Problem with editing song: $e}');
    }
  }

  Future<void> deleteSong(String groupName, String songId) async {
    try {
      await FirebaseFirestore.instance
          .collection(FirebaseConstants.groupsCollection)
          .doc(groupName)
          .collection(FirebaseConstants.songsCollection)
          .doc(songId)
          .delete();
    } catch (e) {
      print('Problem with deleting song: $e}');
    }
  }

// Future<SongModel> playingNow(group) async {
//   try {
//     DocumentSnapshot snapshot = await FirebaseFirestore.instance
//         .collection('Pelgrim Groups')
//         .doc(group)
//         .collection('Playing-now')
//         .doc('playing')
//         .get();
//     return SongModel.fromMap(snapshot.data() as Map<String, dynamic>, snapshot.id);
//   } catch (e) {
//     print('Problem with adding a song: $e}');
//   }
//   return SongModel(title: '', lyrics: '');
// }
}
