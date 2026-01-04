import 'package:pelgrim/domain/entities/group.dart';
import 'package:pelgrim/domain/repositories/group_info_repository.dart';

class GetGroupInfoUseCase {
  final GroupRepository _groupInfoRepository;

  GetGroupInfoUseCase(this._groupInfoRepository);

  Future<Group> execute(String groupName) async {
    return await _groupInfoRepository.getGroup(groupName);
  }
}
