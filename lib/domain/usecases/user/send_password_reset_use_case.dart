import 'package:pelgrim/domain/repositories/auth_repository.dart';

class SendPasswordResetUseCase {
  final AuthRepository _authRepository;

  const SendPasswordResetUseCase(this._authRepository);

  Future<void> execute(String email) async {
    _authRepository.sendPasswordReset(email);
  }
}
