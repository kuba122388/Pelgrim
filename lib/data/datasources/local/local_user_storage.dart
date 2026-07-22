import 'package:hive/hive.dart';
import 'package:pelgrim/data/models/user_session_model.dart';

class LocalUserStorage {
  static const String _boxName = 'sessionBox';
  static const String _sessionKey = 'active_session';

  Future<void> saveSession(UserSessionModel session) async {
    final box = await Hive.openBox<UserSessionModel>(_boxName);
    await box.put(_sessionKey, session);
  }

  Future<UserSessionModel?> loadSession() async {
    final box = await Hive.openBox<UserSessionModel>(_boxName);
    return box.get(_sessionKey);
  }

  Future<void> clear() async {
    final box = await Hive.openBox<UserSessionModel>(_boxName);
    await box.delete(_sessionKey);
  }
}
