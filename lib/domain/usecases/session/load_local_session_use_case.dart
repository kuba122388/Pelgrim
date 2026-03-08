import 'package:pelgrim/domain/entities/user_session.dart';
import 'package:pelgrim/domain/repositories/user_session_repository.dart';

class LoadLocalSessionUseCase {
  final UserSessionRepository _sessionRepository;

  LoadLocalSessionUseCase(this._sessionRepository);

  Future<UserSession?> execute() async {
    return _sessionRepository.getLocalSession();
  }
}
