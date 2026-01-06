import 'package:flutter/material.dart';
import 'package:pelgrim/core/const/app_consts.dart';
import 'package:pelgrim/core/di/service_locator.dart';
import 'package:pelgrim/data/datasources/remote/user_datasource.dart';
import 'package:pelgrim/domain/entities/user.dart';
import 'package:pelgrim/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AllUsersPage extends StatefulWidget {
  const AllUsersPage({super.key});

  @override
  State<AllUsersPage> createState() => _AllUsersPageState();
}

class _AllUsersPageState extends State<AllUsersPage> {
  final UserDataSource _userService = sl<UserDataSource>();

  List<User> users = [];
  List<User> filteredUsers = [];
  TextEditingController searchEngineController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    _userService.getAllUsersByGroupId(userProvider.groupInfo!.id).then((allUsers) {
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
        filteredUsers = users.where((user) => user.isAdmin).toList();
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
    final groupName = Provider.of<UserProvider>(context, listen: false).groupInfo!.id;

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
                style: TextStyle(
                  color: Colors.black.withValues(alpha: 0.4),
                  fontSize: 14,
                ),
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
                                        if (user.isAdmin) {
                                          await _userService.setAdminStatus(
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
                                        if (!user.isAdmin) {
                                          await _userService.setAdminStatus(
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
                                    color: Colors.black.withValues(alpha: 0.25),
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

  Column userInfo(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${user.firstName.trimRight()} ${user.lastName.trimRight()} ${user.isAdmin ? '- Admin' : ''}",
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
