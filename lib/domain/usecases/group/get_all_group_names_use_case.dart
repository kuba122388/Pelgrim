import 'package:pelgrim/domain/entities/group.dart';
import 'package:pelgrim/domain/repositories/group_repository.dart';

class GetAllGroupNamesUseCase {
  final GroupRepository _groupRepository;

  GetAllGroupNamesUseCase(this._groupRepository);

  Future<List<Group>> execute() async {
    return _groupRepository.getAllGroups();
  }
}
