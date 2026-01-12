import 'package:flutter/material.dart';
import 'package:pelgrim/core/const/app_consts.dart';
import 'package:pelgrim/core/di/service_locator.dart';
import 'package:pelgrim/domain/entities/user.dart';
import 'package:pelgrim/domain/usecases/group/set_admin_status_use_case.dart';
import 'package:pelgrim/domain/usecases/user/get_all_users_by_group_use_case.dart';
import 'package:pelgrim/presentation/providers/user_provider.dart';
import 'package:pelgrim/presentation/user/all_users/widgets/user_info_card.dart';
import 'package:provider/provider.dart';

class AllUsersPage extends StatefulWidget {
  const AllUsersPage({super.key});

  @override
  State<AllUsersPage> createState() => _AllUsersPageState();
}

class _AllUsersPageState extends State<AllUsersPage> {
  final GetAllUsersByGroupUseCase _getAllUsersByGroupUseCase = sl<GetAllUsersByGroupUseCase>();
  final SetAdminStatusUseCase _setAdminStatusUseCase = sl<SetAdminStatusUseCase>();

  late final UserProvider _userProvider;
  late final User _user;

  List<User> _users = [];
  List<User> _filteredUsers = [];

  final TextEditingController _searchEngineController = TextEditingController();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _userProvider = context.read<UserProvider>();
    _user = _userProvider.user!;

    _loadUsers();

    _searchEngineController.addListener(() {
      filterUsers();
    });
  }

  Future<void> _loadUsers() async {
    try {
      final allUsers = await _getAllUsersByGroupUseCase.execute(_userProvider.groupInfo!.id!);

      if (!mounted) return;

      setState(() {
        _users = allUsers;
        filterUsers();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Błąd pobierania użytkowników')),
      );
    }
  }

  void filterUsers() {
    final query = _searchEngineController.text.toLowerCase().trim();

    final result = query == 'admin'
        ? _users.where((u) => u.isAdmin).toList()
        : _users
            .where((u) => "${u.firstName} ${u.lastName}".toLowerCase().contains(query))
            .toList();

    setState(() {
      _filteredUsers = result;
    });
  }

  @override
  void dispose() {
    _searchEngineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          child: _isLoading
              ? const Center(child: Text("Ładowanie..."))
              : _filteredUsers.isEmpty
                  ? const Center(child: Text('Brak użytkowników'))
                  : Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                      child: ListView.builder(
                        itemCount: _filteredUsers.length,
                        itemBuilder: (context, index) {
                          final chosenUser = _filteredUsers[index];
                          return GestureDetector(
                            onTap: () async {
                              await showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Uprawnienia'),
                                  content: Text(
                                      'Jakie uprawnienia chcesz przydzielić użytkownikowi ${chosenUser.fullName}?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        if (chosenUser.email == _user.email) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Center(
                                                child: Text('Nie możesz zabrać sobie uprawnień!'),
                                              ),
                                            ),
                                          );
                                          return;
                                        }
                                        if (chosenUser.isAdmin) {
                                          await _setAdminStatusUseCase.execute(
                                            currentUserId: _user.id,
                                            groupId: _user.groupId,
                                            isAdmin: false,
                                            targetUserId: chosenUser.id,
                                          );
                                          await _loadUsers();

                                          Navigator.of(ctx).pop(false);

                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Center(
                                                child: Text(
                                                    'Pomyślnie przyznano uprawnienia użytkownika!'),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text('Użytkownik'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        if (!chosenUser.isAdmin) {
                                          await _setAdminStatusUseCase.execute(
                                            currentUserId: _user.id,
                                            groupId: _user.groupId,
                                            isAdmin: true,
                                            targetUserId: chosenUser.id,
                                          );
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
                                child: UserInfoCard(
                                  fullName: chosenUser.fullName,
                                  userEmail: chosenUser.email,
                                  userPhone: chosenUser.phone,
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
