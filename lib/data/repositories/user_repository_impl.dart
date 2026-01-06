import 'package:pelgrim/core/errors/repository_exception.dart';
import 'package:pelgrim/data/datasources/remote/user_datasource.dart';
import 'package:pelgrim/data/models/user_model.dart';
import 'package:pelgrim/domain/entities/user.dart';
import 'package:pelgrim/domain/repositories/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final UserDataSource _userDataSource;

  UserRepositoryImpl(
    this._userDataSource,
  );

  @override
  Future<void> createUser(User user) async {
    try {
      _userDataSource.createUser(UserModel.fromEntity(user));
    } catch (e) {
      throw RepositoryException("Wystąpił problem przy tworzeniu użytkownika: $e");
    }
  }

  @override
  Future<User> getUserById(String userId) async {
    try {
      UserModel? userModel = await _userDataSource.getUser(userId);
      if (userModel == null) throw Exception("Nie znaleziono użytkownika o id: $userId");

      return userModel.toEntity();
    } catch (e) {
      throw RepositoryException("Wystąpił problem przy pobieraniu użytkownika: $e");
    }
  }

  @override
  Future<void> updateUser(User user) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }

  @override
  Future<List<User>> getAllUsersByGroup(String groupId) async {
    List<UserModel> list = await _userDataSource.getAllUsersByGroupId(groupId);
    return list.map((e) => e.toEntity()).toList();
  }
}
