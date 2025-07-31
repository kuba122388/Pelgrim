import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  late final String? group;
  bool admin;
  final String? groupColor;
  final String? secondColor;
  final String? groupCity;
  final String? color;

  MyUser(
      {this.groupColor,
      this.secondColor,
      this.groupCity,
      this.color,
      this.group,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.phone,
      required this.admin});

  String _groupName() {
    return groupColor == null ? group! : '$groupColor - $groupCity';
  }

  Map<String, dynamic> necessaryToExist() {
    return {'exists': true};
  }

  Map<String, dynamic> toMapUser() {
    return {
      'FirstName': firstName,
      'LastName': lastName,
      'Email': email,
      'Phone': phone,
      'Admin': admin
    };
  }

  Map<String, dynamic> toMapSettings() {
    return {
      'groupColor': groupColor,
      'groupCity': groupCity,
      'secondColor': secondColor,
      'color': color
    };
  }

  Future<void> createUser() async {
    try {
      await FirebaseFirestore.instance
          .collection('Pelgrim Groups')
          .doc(group)
          .collection('Users')
          .doc(email)
          .set(toMapUser());
    } catch (e) {
      print('Wystąpił błąd: $e');
    }
  }

  Future<void> createUserAndGroup() async {
    try {
      await FirebaseFirestore.instance
          .collection('Pelgrim Groups')
          .doc(group)
          .set(necessaryToExist());
      await FirebaseFirestore.instance
          .collection('Pelgrim Groups')
          .doc(group)
          .collection('Settings')
          .add(toMapSettings());
      await FirebaseFirestore.instance
          .collection('Pelgrim Groups')
          .doc(group)
          .collection('Users')
          .doc(_groupName())
          .set(toMapUser());
    } catch (e) {
      print('Wystąpił błąd: $e');
    }
  }

  factory MyUser.fromMap(Map<String, dynamic> map) {
    return MyUser(
        admin: map['Admin'],
        email: map['Email'],
        firstName: map['FirstName'],
        lastName: map['LastName'],
        phone: map['Phone']);
  }

  static Future<MyUser?> getUserData(String email, String group) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Pelgrim Groups')
          .doc(group)
          .collection('Users')
          .doc(email.toLowerCase())
          .get();
      if (doc.exists) {
        return MyUser.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        print('Użytkownik nie został znaleziony');
        return null;
      }
    } catch (e) {
      print('Problem z załadowaniem danych użytkownika: $e');
      return null;
    }
  }

  static Future<List<MyUser>> getAllUsers(String group) async {
    try {
      QuerySnapshot allUsersSnapshot = await FirebaseFirestore.instance
          .collection('Pelgrim Groups')
          .doc(group)
          .collection('Users')
          .get();

      List<MyUser> allUsers = allUsersSnapshot.docs.map((doc) {
        return MyUser.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      return allUsers;
    } catch (e) {
      print('Błąd przy pobieraniu użytkowników: $e');
      return [];
    }
  }

  Future<void> grantAdmin(bool grant, String group) async{
    admin = grant;
    try{
      print(toMapUser());
      await FirebaseFirestore.instance
          .collection('Pelgrim Groups')
          .doc(group)
          .collection('Users')
          .doc(email)
          .set(toMapUser());
    } catch (e) {
      print("Problem z podnoszeniem uprawnień");
    }
  }

}
