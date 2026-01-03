import 'package:pelgrim/data/models/contact_model.dart';
import 'package:pelgrim/data/sources/contact_service.dart';
import 'package:pelgrim/domain/entities/contact.dart';
import 'package:pelgrim/domain/repositories/contact_repository.dart';

class ContactRepositoryImpl implements ContactRepository {
  final ContactService _contactService;

  ContactRepositoryImpl(this._contactService);

  @override
  Future<Contact> getContactInfo(String groupName) async {
    try {
      final model = await _contactService.getContactInfo(groupName);
      return model.toEntity();
    } catch (e) {
      throw Exception('Nie udało się pobrać danych kontaktowych: $e');
    }
  }

  @override
  Future<void> setContactInfo(String groupName, Contact contact) async {
    try {
      final model = ContactModel.fromEntity(contact);
      await _contactService.setContactInfo(groupName, model);
    } catch (e) {
      throw Exception('Błąd podczas zapisywania kontaktu: $e');
    }
  }
}
