import 'package:cloud_firestore/cloud_firestore.dart';

class Song {
  String title;
  String lyrics;
  String? docId;

  Song({required this.title, required this.lyrics, this.docId});

  Map<String, dynamic> toMap(){
    return {
      'Title': title,
      'Lyrics': lyrics
    };
  }

  Future<void> addSong(group) async {
    try {
      await FirebaseFirestore.instance.collection('Pelgrim Groups')
          .doc(group)
          .collection('Songs')
          .add(toMap());
    }
    catch(e){
      print('Problem with adding a song: $e}');
    }
  }

  factory Song.fromMap(Map<String, dynamic> map, docId){
    return Song(
        title: map['Title'] ?? '',
        lyrics: map['Lyrics'] ?? '',
        docId: docId
    );
  }

  static Future<List<Song>> loadSongs (String group) async{
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Pelgrim Groups')
          .doc(group)
          .collection('Songs')
          .orderBy('Title', descending: false)
          .get();
      return querySnapshot.docs.map((doc) {
        return Song.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    }
    catch (e){
      print('Problem z załadowaniem ogłoszeń: $e');
      return [];
    }
  }

  Future<void> requestSong(group) async {
    try {
      await FirebaseFirestore.instance.collection('Pelgrim Groups')
          .doc(group)
          .collection('Playing-now')
          .doc('playing')
          .set(toMap());
    }
    catch(e){
      print('Problem with adding a song: $e}');
    }
  }

  static Stream<Song> getPlayingNow(group) {
    return FirebaseFirestore.instance
        .collection('Pelgrim Groups')
        .doc(group)
        .collection('Playing-now')
        .doc('playing')
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return Song.fromMap(snapshot.data() as Map<String, dynamic>, snapshot.id);
      } else {
        return Song(title: 'Brak danych', lyrics: '');
      }
    });
  }

  Future<void> refreshSong(group) async{
    try{
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('Pelgrim Groups')
          .doc(group)
          .collection('Songs')
          .doc(docId)
          .get();
      if(documentSnapshot.exists){
        Song song = Song.fromMap(documentSnapshot.data() as Map<String, dynamic>, docId);
        title = song.title;
        lyrics = song.lyrics;
      }
    }
    catch(e){
      print('Problem reloading song encountered: $e');
    }
  }

  Future<void> editSong(group) async{
    try {
      print(docId);
      await FirebaseFirestore.instance.collection('Pelgrim Groups')
          .doc(group)
          .collection('Songs')
          .doc(docId)
          .set(toMap());
    }
    catch(e){
      print('Problem with editing song: $e}');
    }
  }

  Future<void> deleteSong(group) async{
    try {
      print(docId);
      await FirebaseFirestore.instance.collection('Pelgrim Groups')
          .doc(group)
          .collection('Songs')
          .doc(docId)
          .delete();
    }
    catch(e){
      print('Problem with deleting song: $e}');
    }
  }

  static Future<Song> playingNow(group) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('Pelgrim Groups')
          .doc(group)
          .collection('Playing-now')
          .doc('playing')
          .get();
      return Song.fromMap(snapshot.data() as Map<String, dynamic>, snapshot.id);
    }
    catch(e){
      print('Problem with adding a song: $e}');
    }
    return Song(title: '', lyrics: '');
  }

}