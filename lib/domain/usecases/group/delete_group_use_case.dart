import 'package:pelgrim/domain/repositories/group_repository.dart';

class DeleteGroupUseCase {
  final GroupRepository _groupRepository;

  DeleteGroupUseCase(this._groupRepository);

  Future<void> execute(String groupId) async {
    return _groupRepository.deleteGroup(groupId);
  }
}
