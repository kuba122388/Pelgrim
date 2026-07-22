import 'package:pelgrim/domain/repositories/auth_repository.dart';

class IsUserAuthenticatedUseCase {
  final AuthRepository _repository;

  IsUserAuthenticatedUseCase(this._repository);

  String? execute() => _repository.getCurrentUserId();
}
