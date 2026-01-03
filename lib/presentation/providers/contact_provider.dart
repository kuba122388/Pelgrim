import 'package:flutter/material.dart';
import 'package:pelgrim/core/const/app_strings.dart';
import 'package:pelgrim/domain/entities/contact.dart';
import 'package:pelgrim/domain/usecases/contact/get_contact_info_usecase.dart';
import 'package:pelgrim/domain/usecases/contact/save_contact_info_usecase.dart';

class ContactProvider extends ChangeNotifier {
  final GetContactInfoUseCase _getContactInfoUseCase;
  final SaveContactInfoUseCase _saveContactInfoUseCase;

  ContactProvider(this._getContactInfoUseCase, this._saveContactInfoUseCase);

  Contact _contact = Contact(description: AppStrings.contactInfo);
  bool _isLoading = false;

  Contact get contact => _contact;

  String get contactDescription => _contact.description;

  bool get isLoading => _isLoading;

  Future<void> fetchContactInfo({required String groupName}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _contact = await _getContactInfoUseCase.execute(groupName);
    } catch (e) {
      debugPrint("Error fetching contact info: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveContactInfo({required String groupName, required Contact contact}) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _saveContactInfoUseCase.execute(groupName, contact);
      _contact = contact;
    } catch (e) {
      debugPrint("Error fetching contact info: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
