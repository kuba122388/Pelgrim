import 'package:pelgrim/domain/entities/group.dart';
import 'package:pelgrim/domain/repositories/group_repository.dart';

class GetGroupUseCase {
  final GroupRepository _groupRepository;

  GetGroupUseCase(this._groupRepository);

  Future<Group> execute(String groupName) async {
    return await _groupRepository.getGroup(groupName);
  }
}
