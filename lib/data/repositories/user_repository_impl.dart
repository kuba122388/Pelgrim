import 'package:pelgrim/data/datasources/user_datasource.dart';
import 'package:pelgrim/domain/entities/user.dart';
import 'package:pelgrim/domain/repositories/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final UserDataSource _userDataSource;

  UserRepositoryImpl(this._userDataSource);

  @override
  Future<void> createUser(User user) async{
    try{
      _userDataSource
    }
  }

  @override
  Future<User?> getUser(String uid) {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  @override
  Future<void> updateUser(User user) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
}
