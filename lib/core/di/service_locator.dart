import 'package:get_it/get_it.dart';
import 'package:pelgrim/data/sources/user_service.dart';
import 'package:pelgrim/data/sources/auth_service.dart';
import 'package:pelgrim/data/sources/group_service.dart';

final sl = GetIt.instance;

void setupLocator() {
  sl.registerLazySingleton<AuthService>(() => AuthService());
  sl.registerLazySingleton<GroupService>(() => GroupService());
  sl.registerLazySingleton<UserService>(() => UserService());
}
