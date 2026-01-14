import '../../domain/entities/help_request.dart';
import '../../domain/repositories/help_repository.dart';
import '../datasources/remote/help_remote_data_source.dart';

class HelpRepositoryImpl implements HelpRepository {
  final HelpDataSource _helpDataSource;

  HelpRepositoryImpl(this._helpDataSource);

  @override
  Future<void> sendHelpRequest(HelpRequest request) {
    return _helpDataSource.sendHelpRequest(request);
  }
}
