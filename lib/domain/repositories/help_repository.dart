import '../entities/help_request.dart';

abstract class HelpRepository {
  Future<void> sendHelpRequest(HelpRequest request);
}
