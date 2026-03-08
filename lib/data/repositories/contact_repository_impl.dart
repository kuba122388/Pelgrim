import 'package:pelgrim/data/datasources/remote/contact_data_source.dart';
import 'package:pelgrim/data/models/contact_model.dart';
import 'package:pelgrim/domain/entities/contact.dart';
import 'package:pelgrim/domain/repositories/contact_repository.dart';

class ContactRepositoryImpl implements ContactRepository {
  final ContactDataSource _contactDataSource;

  ContactRepositoryImpl(this._contactDataSource);

  @override
  Future<Contact> getContactInfo(String groupName) async {
    try {
      final model = await _contactDataSource.getContactInfo(groupName);
      return model.toEntity();
    } catch (e) {
      throw Exception('Nie udało się pobrać danych kontaktowych: $e');
    }
  }

  @override
  Future<void> setContactInfo(String groupName, Contact contact) async {
    try {
      final model = ContactModel.fromEntity(contact);
      await _contactDataSource.setContactInfo(groupName, model);
    } catch (e) {
      throw Exception('Błąd podczas zapisywania kontaktu: $e');
    }
  }
}
