import 'package:pelgrim/domain/entities/contact.dart';

abstract class ContactRepository {
  Future<Contact> getContactInfo(String groupName);

  Future<void> setContactInfo(String groupName, Contact contact);
}
