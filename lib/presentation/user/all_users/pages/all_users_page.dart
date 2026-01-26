import 'package:flutter/material.dart';
import 'package:pelgrim/core/const/app_consts.dart';
import 'package:pelgrim/domain/entities/user.dart';
import 'package:pelgrim/presentation/providers/all_users_provider.dart';
import 'package:pelgrim/presentation/providers/user_provider.dart';
import 'package:pelgrim/presentation/user/all_users/widgets/user_info_card.dart';
import 'package:provider/provider.dart';

class AllUsersPage extends StatefulWidget {
  const AllUsersPage({super.key});

  @override
  State<AllUsersPage> createState() => _AllUsersPageState();
}

class _AllUsersPageState extends State<AllUsersPage> {
  late final UserProvider _userProvider;
  late final AllUsersProvider _allUsersProvider;
  late final User _user;

  final TextEditingController _searchEngineController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _userProvider = context.read<UserProvider>();
    _allUsersProvider = context.read<AllUsersProvider>();
    _user = _userProvider.user!;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _allUsersProvider.loadUsers(_userProvider.groupInfo!.id!);
    });
  }

  List<User> _filterUsers(List<User> users) {
    final query = _searchEngineController.text.toLowerCase().trim();

    if (query.isEmpty) return users;

    if (query == 'admin') {
      return users.where((u) => u.isAdmin).toList();
    }

    return users
        .where((u) => "${u.firstName} ${u.lastName}".toLowerCase().contains(query))
        .toList();
  }

  @override
  void dispose() {
    _searchEngineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final allUsersProvider = context.watch<AllUsersProvider>();
    final users = _filterUsers(allUsersProvider.users);

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
            controller: _searchEngineController,
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
          child: allUsersProvider.isLoading
              ? const Center(child: Text("Ładowanie..."))
              : users.isEmpty
                  ? const Center(child: Text('Brak użytkowników'))
                  : Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                      child: ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final chosenUser = users[index];

                          return GestureDetector(
                            onTap: () async {
                              User userFullInfo = await _allUsersProvider.getUser(chosenUser.id);

                              await showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Informacje'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${chosenUser.fullName}\nTelefon: ${userFullInfo.phone}\nE-mail: ${userFullInfo.email}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    const Text("Jakie uprawnienia chciałbyś nadać?"),
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            final messenger = ScaffoldMessenger.of(context);

                                            if (chosenUser.id == _user.id) {
                                              Navigator.of(ctx).pop(false);
                                              messenger.showSnackBar(
                                                const SnackBar(
                                                  content: Center(
                                                    child:
                                                        Text('Nie możesz zabrać sobie uprawnień!'),
                                                  ),
                                                ),
                                              );
                                              return;
                                            }
                                            if (chosenUser.isAdmin) {
                                              await allUsersProvider.changeAdminStatus(
                                                currentUserId: _user.id,
                                                groupId: _user.groupId,
                                                isAdmin: false,
                                                targetUser: chosenUser,
                                              );

                                              Navigator.of(ctx).pop(false);
                                              messenger.showSnackBar(
                                                const SnackBar(
                                                  content: Center(
                                                    child: Text(
                                                      'Pomyślnie przyznano uprawnienia użytkownika!',
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          style: const ButtonStyle(
                                            padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
                                              EdgeInsetsGeometry.symmetric(horizontal: 15),
                                            ),
                                          ),
                                          child: const Text('Użytkownik'),
                                        ),
                                        const SizedBox(
                                          width: 10.0,
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            final messenger = ScaffoldMessenger.of(context);

                                            if (chosenUser.isAdmin) {
                                              await allUsersProvider.changeAdminStatus(
                                                currentUserId: _user.id,
                                                groupId: _user.groupId,
                                                isAdmin: true,
                                                targetUser: chosenUser,
                                              );

                                              Navigator.of(ctx).pop(true);
                                              messenger.showSnackBar(
                                                const SnackBar(
                                                  content: Center(
                                                    child: Text(
                                                        'Pomyślnie przyznano uprawnienia użytkownika!'),
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          style: const ButtonStyle(
                                            padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
                                              EdgeInsetsGeometry.symmetric(horizontal: 15),
                                            ),
                                          ),
                                          child: const Text('Administrator'),
                                        ),
                                      ],
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
                                child: UserInfoCard(
                                  fullName: chosenUser.fullName,
                                  isAdmin: chosenUser.isAdmin,
                                ),
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
}
