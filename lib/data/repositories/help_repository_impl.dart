import 'package:pelgrim/core/errors/repository_exception.dart';

import '../../domain/entities/help_request.dart';
import '../../domain/repositories/help_repository.dart';
import '../datasources/remote/help_remote_data_source.dart';

class HelpRepositoryImpl implements HelpRepository {
  final HelpDataSource _helpDataSource;

  HelpRepositoryImpl(this._helpDataSource);

  @override
  Future<void> sendHelpRequest(HelpRequest request) async {
    try {
      return await _helpDataSource.sendHelpRequest(request);
    } catch (e) {
      throw RepositoryException("Wystąpił problem z przesyłaniem.");
    }
  }
}
