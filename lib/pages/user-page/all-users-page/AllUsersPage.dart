import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pelgrim/consts.dart';
import 'package:pelgrim/dbfeatures/MyUser.dart';

class AllUsersPage extends StatefulWidget {
  final Map<String, dynamic> settings;
  final MyUser myUser;

  const AllUsersPage({super.key, required this.settings, required this.myUser});

  @override
  State<AllUsersPage> createState() => _AllUsersPageState();
}

class _AllUsersPageState extends State<AllUsersPage> {
  List<MyUser> users = [];
  List<MyUser> filteredUsers = [];
  TextEditingController searchEngineController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    final group =
        '${widget.settings['groupColor']} - ${widget.settings['groupCity']}';
    MyUser.getAllUsers(group).then((allUsers) {
      setState(() {
        users = allUsers;
        filterUsers();
        isLoading = false;
      });
    });
    searchEngineController.addListener(() {
      filterUsers();
    });
  }

  void filterUsers() {
    isLoading = true;
    String query = searchEngineController.text.toLowerCase().trimRight();
    setState(() {
      if (query == 'admin') {
        filteredUsers = users.where((user) => user.admin).toList();
      } else {
        filteredUsers = users.where((user) {
          return ("${user.firstName.trimRight()} ${user.lastName.trimRight()}")
              .toLowerCase()
              .contains(query);
        }).toList();
      }
    });
    isLoading = false;
  }

  @override
  void dispose() {
    searchEngineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final group =
        '${widget.settings['groupColor']} - ${widget.settings['groupCity']}';
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: const [BOX_SHADOW_CONTAINER]),
          width: screenWidth * 0.72,
          margin: const EdgeInsets.only(top: 30, bottom: 15),
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: TextField(
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            autofocus: false,
            controller: searchEngineController,
            decoration: InputDecoration(
              suffixIcon: Image.asset('./images/search.png', scale: 2),
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              fillColor: Colors.white,
              label: Text('Wyszukaj użytkownika',
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.4), fontSize: 14)),
              border: const OutlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
        ),
        Expanded(
          child: isLoading
              ? const Center(child: Text("Ładowanie..."))
              : filteredUsers.isEmpty
                  ? const Center(child: Text('Brak użytkowników'))
                  : Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 10),
                      child: ListView.builder(
                        itemCount: filteredUsers.length,
                        itemBuilder: (context, index) {
                          final user = filteredUsers[index];
                          return GestureDetector(
                              onTap: () async {
                                await showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Uprawnienia'),
                                    content: Text(
                                        'Jakie uprawnienia chcesz przydzielić użytkownikowi ${user.firstName}?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          if (user.email ==
                                              widget.myUser.email) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Center(
                                                        child: Text(
                                                            'Nie możesz zabrać sobie uprawnień!'))));
                                            return;
                                          }
                                          if (user.admin) {
                                            await user.grantAdmin(false, group);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Center(
                                              child: Text(
                                                  'Pomyślnie przyznano uprawnienia użytkownika!'),
                                            )));
                                          }
                                          Navigator.of(ctx).pop(false);
                                        },
                                        child: const Text('Użytkownik'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          if (!user.admin) {
                                            await user.grantAdmin(true, group);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Center(
                                              child: Text(
                                                  'Pomyślnie przyznano uprawnienia administratora!'),
                                            )));
                                          }
                                          Navigator.of(ctx).pop(true);
                                        },
                                        child: const Text('Administrator'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.25),
                                            blurRadius: 4,
                                            spreadRadius: 2,
                                            offset: const Offset(0, 0))
                                      ]),
                                  width: screenWidth * 0.8,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    child: userInfo(user),
                                  )));
                        },
                      )),
        ),
      ],
    );
  }

  Column userInfo(MyUser user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${user.firstName.trimRight()} ${user.lastName.trimRight()} ${user.admin ? '- Admin' : ''}",
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Lexend',
            color: FONT_BLACK_COLOR,
          ),
        ),
        Text(
          user.email,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Lexend',
            color: FONT_GREY_COLOR,
          ),
        ),
        Text(
          user.phone,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Lexend',
            color: FONT_GREY_COLOR,
          ),
        ),
      ],
    );
  }
}
