import 'package:pelgrim/domain/repositories/group_repository.dart';

class GetAllGroupNamesUseCase {
  final GroupRepository _groupRepository;

  GetAllGroupNamesUseCase(this._groupRepository);

  Future<List<String>> execute() async {
    return await _groupRepository.getAllGroupNames();
  }
}
