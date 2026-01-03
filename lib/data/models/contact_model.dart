import 'package:pelgrim/domain/entities/contact.dart';

class ContactModel {
  final String description;

  ContactModel({required this.description});

  factory ContactModel.fromMap(Map<String, dynamic> json) {
    return ContactModel(
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
    };
  }

  factory ContactModel.fromEntity(Contact contact) {
    return ContactModel(description: contact.description);
  }

  Contact toEntity() {
    return Contact(description: description);
  }
}
