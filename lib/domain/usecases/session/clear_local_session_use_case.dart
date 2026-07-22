import 'package:pelgrim/domain/repositories/user_session_repository.dart';

class ClearLocalSessionUseCase {
  final UserSessionRepository _sessionRepository;

  ClearLocalSessionUseCase(this._sessionRepository);

  Future<void> execute() async {
    _sessionRepository.clearLocalSession();
  }
}
