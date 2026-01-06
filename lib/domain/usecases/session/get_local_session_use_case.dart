import 'package:pelgrim/domain/entities/user_session.dart';
import 'package:pelgrim/domain/repositories/user_session_repository.dart';

class GetLocalSessionUseCase {
  final UserSessionRepository _sessionRepository;

  GetLocalSessionUseCase(this._sessionRepository);

  Future<UserSession?> execute() async {
    return await _sessionRepository.getLocalSession();
  }
}
