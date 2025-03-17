import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pelgrim/consts.dart';
import 'package:pelgrim/dbfeatures/Contact.dart';

class ContactPage extends StatelessWidget {
  Map<String, dynamic> settings;

  ContactPage({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    final group = '${settings['groupColor']} - ${settings['groupCity']}';
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
        padding: const EdgeInsets.all(20),
        width: screenWidth,
        height: screenHeight,
        child: FutureBuilder<List<Contact>>(
          future: Contact.getContacts(group),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Błąd: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                  child: Text('Brak danych',
                      style: TextStyle(
                          fontFamily: 'Lexend', color: FONT_BLACK_COLOR)));
            } else {
              List<Contact> contacts = snapshot.data!;

              return SingleChildScrollView(
                child: Column(
                  children: contacts.map((contact) {
                    return Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        width: screenWidth * 0.75,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [BOX_SHADOW_CONTAINER]),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Text(contact.role,
                                      style: const TextStyle(
                                          fontFamily: 'Lexend', fontSize: 16)),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(contact.description,
                                    style: const TextStyle(
                                        fontFamily: 'Lexend', fontSize: 14)),
                              ],
                            ),
                          ],
                        ));
                  }).toList(),
                ),
              );
            }
          },
        ));
  }
}
