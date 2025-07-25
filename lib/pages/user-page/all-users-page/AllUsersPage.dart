import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pelgrim/dbfeatures/User.dart';

class AllUsersPage extends StatefulWidget {
  final Map<String, dynamic> settings;

  const AllUsersPage({super.key, required this.settings});

  @override
  State<AllUsersPage> createState() => _AllUsersPageState();
}

class _AllUsersPageState extends State<AllUsersPage> {
  @override
  Widget build(BuildContext context) {
    final group =
        '${widget.settings['groupColor']} - ${widget.settings['groupCity']}';
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.all(20),
      width: screenWidth,
      height: screenHeight,
      child: FutureBuilder<List<MyUser>>(
        future: MyUser.getAllUsers(group),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Błąd: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Brak użytkowników'));
          } else {
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    title: Row(children: [Text('${user.firstName}${user.lastName}'), Text(' - ${user.admin}')]),
                    subtitle: Text(user.email),
                    trailing: user.admin
                        ? Image.asset("./images/information.png", height: 30)
                        : null,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}