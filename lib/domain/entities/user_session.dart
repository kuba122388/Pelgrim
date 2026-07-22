import 'package:pelgrim/domain/entities/group.dart';
import 'package:pelgrim/domain/entities/user.dart';

class UserSession {
  final User user;
  final Group group;

  const UserSession({
    required this.user,
    required this.group,
  });
}
