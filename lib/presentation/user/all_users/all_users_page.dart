import 'package:flutter/material.dart';
import 'package:pelgrim/core/const/consts.dart';
import 'package:pelgrim/domain/entities/my_user.dart';
import 'package:pelgrim/providers/user_provider.dart';
import 'package:pelgrim/data/sources/user_service.dart';
import 'package:pelgrim/core/di/service_locator.dart';
import 'package:provider/provider.dart';

class AllUsersPage extends StatefulWidget {
  const AllUsersPage({super.key});

  @override
  State<AllUsersPage> createState() => _AllUsersPageState();
}

class _AllUsersPageState extends State<AllUsersPage> {
  final UserService _userService = sl<UserService>();

  List<MyUser> users = [];
  List<MyUser> filteredUsers = [];
  TextEditingController searchEngineController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    _userService.getAllUsersByGroup(userProvider.groupInfo!.groupName).then((allUsers) {
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
    final myUser = Provider.of<UserProvider>(context, listen: false).user!;
    final groupName = Provider.of<UserProvider>(context, listen: false).groupInfo!.groupName;

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
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              fillColor: Colors.white,
              label: Text(
                'Wyszukaj użytkownika',
                style: TextStyle(color: Colors.black.withOpacity(0.4), fontSize: 14),
              ),
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
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
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
                                        if (user.email == myUser.email) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Center(
                                                child: Text('Nie możesz zabrać sobie uprawnień!'),
                                              ),
                                            ),
                                          );
                                          return;
                                        }
                                        if (user.admin) {
                                          await _userService.grantAdmin(
                                              false, user.email, groupName);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Center(
                                                child: Text(
                                                    'Pomyślnie przyznano uprawnienia użytkownika!'),
                                              ),
                                            ),
                                          );
                                        }
                                        Navigator.of(ctx).pop(false);
                                      },
                                      child: const Text('Użytkownik'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        if (!user.admin) {
                                          await _userService.grantAdmin(
                                              true, user.email, groupName);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Center(
                                                child: Text(
                                                    'Pomyślnie przyznano uprawnienia administratora!'),
                                              ),
                                            ),
                                          );
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
                              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.25),
                                    blurRadius: 4,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                              width: screenWidth * 0.8,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                child: userInfo(user),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
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
