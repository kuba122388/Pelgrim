import 'package:pelgrim/domain/entities/contact.dart';
import 'package:pelgrim/domain/repositories/contact_repository.dart';

class GetContactInfoUseCase {
  final ContactRepository _contactRepository;

  GetContactInfoUseCase(this._contactRepository);

  Future<Contact> execute(String groupName) async {
    return _contactRepository.getContactInfo(groupName);
  }
}
