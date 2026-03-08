import 'package:pelgrim/domain/entities/group.dart';
import 'package:pelgrim/domain/repositories/group_repository.dart';

class GetGroupByIdUseCase {
  final GroupRepository _groupRepository;

  GetGroupByIdUseCase(this._groupRepository);

  Future<Group> execute(String groupId) async {
    return _groupRepository.getGroupById(groupId);
  }
}
