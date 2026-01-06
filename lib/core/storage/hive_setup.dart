import 'package:hive_flutter/hive_flutter.dart';
import 'package:pelgrim/data/models/group_model.dart';
import 'package:pelgrim/data/models/song_model.dart';
import 'package:pelgrim/data/models/user_model.dart';
import 'package:pelgrim/data/models/user_session_model.dart';

class HiveSetup {
  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(UserModelAdapter()); // ID: 0
    Hive.registerAdapter(GroupModelAdapter()); // ID: 1
    Hive.registerAdapter(UserSessionModelAdapter()); // ID: 2
    Hive.registerAdapter(SongModelAdapter()); // ID: 3
  }
}
