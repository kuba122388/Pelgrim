import 'package:pelgrim/domain/entities/user.dart';

abstract class UserRepository {
  Future<void> createUser(User user);

  Future<User> getUserById(String userId);

  Future<void> updateUser(User user);

  Future<List<User>> getAllUsersByGroup(String groupId);
}
