import 'package:pelgrim/domain/entities/contact.dart';
import 'package:pelgrim/domain/repositories/contact_repository.dart';

class SaveContactInfoUseCase {
  final ContactRepository _contactRepository;

  SaveContactInfoUseCase(this._contactRepository);

  Future<void> execute(String groupName, Contact contact) async {
    return await _contactRepository.setContactInfo(groupName, contact);
  }
}
