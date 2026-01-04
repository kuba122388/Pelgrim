import 'package:pelgrim/domain/entities/user.dart';

abstract class UserRepository {
  Future<void> createUser(User user);

  Future<User?> getUser(String uid);

  Future<void> updateUser(User user);
}
