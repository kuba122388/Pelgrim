import 'package:flutter/material.dart';
import 'package:pelgrim/presentation/providers/duty_provider.dart';
import 'package:pelgrim/presentation/providers/user_provider.dart';
import 'package:pelgrim/presentation/user/duties/widgets/add_duty_dialog.dart';
import 'package:pelgrim/presentation/user/duties/widgets/duty_box.dart';
import 'package:provider/provider.dart';

class GroupDutiesPage extends StatefulWidget {
  const GroupDutiesPage({super.key});

  @override
  State<GroupDutiesPage> createState() => _GroupDutiesPageState();
}

class _GroupDutiesPageState extends State<GroupDutiesPage> {
  late final String _groupId;

  @override
  void initState() {
    super.initState();
    _groupId = context.read<UserProvider>().userGroupId;
    context.read<DutyProvider>().start(_groupId);
  }

  @override
  Widget build(BuildContext context) {
    final duties = context.watch<DutyProvider>().duties;
    final user = context.watch<UserProvider>().user!;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: duties.isEmpty
              ? const Center(
                  child: Text("Brak służb."),
                )
              : ListView.builder(
                  itemCount: duties.length,
                  itemBuilder: (context, index) {
                    return DutyBox(
                      duty: duties[index],
                    );
                  },
                ),
        ),
        if (user.isAdmin)
          Positioned(
            bottom: 16,
            right: 16,
            child: ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AddDutyDialog(
                    onConfirm: (newDuty) async {
                      await context.read<DutyProvider>().addDuty(_groupId, newDuty);
                    },
                  ),
                );
              },
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
}
