import 'package:flutter/material.dart';
import 'package:pelgrim/core/const/app_consts.dart';
import 'package:pelgrim/core/utils/app_snack_bars.dart';
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
  final TextEditingController _searchEngineController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final userProvider = context.read<UserProvider>();
    final allUsersProvider = context.read<AllUsersProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await allUsersProvider.loadUsers(userProvider.groupInfo!.id!);
      } catch (e) {
        if (!mounted) return;
        AppSnackBars.error(context, e.toString());
      }
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
            boxShadow: const [BOX_SHADOW_CONTAINER],
          ),
          width: screenWidth * 0.72,
          margin: const EdgeInsets.only(top: 30, bottom: 15),
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: TextField(
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            onChanged: (_) => setState(() {}),
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
                              final allUsersProvider = context.read<AllUsersProvider>();

                              try {
                                User userFullInfo = await allUsersProvider.getUser(chosenUser.id);

                                if (!context.mounted) return;

                                await showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Informacje'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SelectableText(
                                          "${chosenUser.fullName}\n"
                                          "Telefon: ${userFullInfo.phone}\n"
                                          "E-mail: ${userFullInfo.email}",
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
                                              final User currentUser =
                                                  context.read<UserProvider>().user!;

                                              if (chosenUser.id == currentUser.id) {
                                                Navigator.of(ctx).pop(false);
                                                AppSnackBars.error(
                                                    context, 'Nie możesz zabrać sobie uprawnień!');
                                                return;
                                              }
                                              if (currentUser.isAdmin) {
                                                await allUsersProvider.changeAdminStatus(
                                                  currentUserId: currentUser.id,
                                                  groupId: currentUser.groupId,
                                                  isAdmin: false,
                                                  targetUser: chosenUser,
                                                );

                                                if (!ctx.mounted) return;
                                                Navigator.of(ctx).pop(false);

                                                AppSnackBars.success(
                                                  ctx,
                                                  'Pomyślnie przyznano uprawnienia użytkownika!',
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
                                              final User currentUser =
                                                  context.read<UserProvider>().user!;

                                              try {
                                                if (currentUser.isAdmin) {
                                                  await allUsersProvider.changeAdminStatus(
                                                    currentUserId: currentUser.id,
                                                    groupId: currentUser.groupId,
                                                    isAdmin: true,
                                                    targetUser: chosenUser,
                                                  );

                                                  if (!ctx.mounted) return;
                                                  Navigator.of(ctx).pop(true);

                                                  AppSnackBars.success(ctx,
                                                      'Pomyślnie przyznano uprawnienia administratora!');
                                                }
                                              } catch (e) {
                                                AppSnackBars.error(context,
                                                    "Wystąpił błąd podczas nadawania uprawnień");
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
                              } catch (e) {
                                if (!context.mounted) return;
                                AppSnackBars.error(
                                    context, "Nie udało się pobrać informacji o użytkowniku");
                              }
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
