import '../../entities/help_request.dart';
import '../../repositories/help_repository.dart';

class SendHelpRequestUseCase {
  final HelpRepository _helpRepository;

  SendHelpRequestUseCase(this._helpRepository);

  Future<void> execute(HelpRequest request) {
    if (request.title.isEmpty || request.content.isEmpty) {
      throw Exception('Fill in title and content.');
    }
    return _helpRepository.sendHelpRequest(request);
  }
}
