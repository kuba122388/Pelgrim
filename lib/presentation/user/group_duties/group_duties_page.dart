import 'package:flutter/material.dart';
import 'package:pelgrim/domain/entities/duty.dart';
import 'package:pelgrim/domain/entities/group_info.dart';
import 'package:pelgrim/domain/entities/my_user.dart';
import 'package:pelgrim/presentation/widgets/duty_box.dart';
import 'package:pelgrim/providers/user_provider.dart';
import 'package:provider/provider.dart';

class GroupDutiesPage extends StatefulWidget {
  const GroupDutiesPage({super.key});

  @override
  State<GroupDutiesPage> createState() => _GroupDutiesPageState();
}

class _GroupDutiesPageState extends State<GroupDutiesPage> {
  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = context.read<UserProvider>();

    final GroupInfo groupInfo = userProvider.groupInfo!;
    final MyUser myUser = userProvider.user!;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: FutureBuilder<List<Duty>>(
            future: Duty.loadDuties(groupInfo.groupName),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("Brak służb."));
              }

              final data = snapshot.data!;

              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return DutyBox(
                    duty: data[index],
                    currentUser: myUser,
                    group: groupInfo.groupName,
                    onRefresh: _refresh,
                  );
                },
              );
            },
          ),
        ),
        if (myUser.admin)
          Positioned(
            bottom: 16,
            right: 16,
            child: ElevatedButton.icon(
              onPressed: () => _showAddDutyDialog(context, groupInfo.groupName),
              icon: const Icon(Icons.add),
              label: const Text("Dodaj zadanie"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showAddDutyDialog(BuildContext context, String groupName) {
    final titleController = TextEditingController();
    int maxPeople = 1;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nowe zadanie'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Tytuł zadania'),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text('Maksymalna liczba osób:'),
                  const SizedBox(width: 10),
                  DropdownButton<int>(
                    value: maxPeople,
                    items: List.generate(16, (index) => index + 1)
                        .map((val) => DropdownMenuItem(
                              value: val,
                              child: Text(val.toString()),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        maxPeople = val;
                        (context as Element).markNeedsBuild();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Anuluj'),
            ),
            ElevatedButton(
              onPressed: () async {
                final title = titleController.text.trim();
                if (title.isEmpty) return;

                final newDuty = Duty(
                  title: title,
                  maxVolunteers: maxPeople,
                );
                await newDuty.addDuty(groupName);
                Navigator.of(context).pop();
                setState(() {});
              },
              child: const Text('Dodaj'),
            ),
          ],
        );
      },
    );
  }
}
