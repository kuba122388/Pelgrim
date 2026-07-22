import 'package:pelgrim/domain/entities/user_session.dart';
import 'package:pelgrim/domain/repositories/user_session_repository.dart';

class SaveLocalSessionUseCase {
  final UserSessionRepository _sessionRepository;

  SaveLocalSessionUseCase(this._sessionRepository);

  Future<void> execute(UserSession userSession) async {
    _sessionRepository.saveLocalSession(userSession);
  }
}
