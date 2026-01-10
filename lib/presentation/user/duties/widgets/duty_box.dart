import 'package:flutter/material.dart';
import 'package:pelgrim/domain/entities/duty.dart';
import 'package:pelgrim/presentation/providers/duty_provider.dart';
import 'package:pelgrim/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';

class DutyBox extends StatelessWidget {
  final Duty duty;

  const DutyBox({
    super.key,
    required this.duty,
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final dutyProvider = context.read<DutyProvider>();

    final currentUser = userProvider.user;

    if (currentUser == null) return const SizedBox.shrink();

    final bool isUserSignedUp = duty.volunteers.any((v) => v.userId == currentUser.id);
    final int filled = duty.volunteers.length;
    final int total = duty.maxVolunteers;

    final String slots = List.generate(
      total,
      (i) => i < filled ? 'X' : '-',
    ).join(' ');

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    duty.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    maxLines: null,
                  ),
                ),
                const SizedBox(width: 10),
                if (currentUser.isAdmin)
                  GestureDetector(
                    onTap: () => _showDeleteDialog(context, dutyProvider, userProvider.userGroupId),
                    child: Image.asset("./images/trash.png", width: 20, height: 20),
                  )
              ],
            ),
            const SizedBox(height: 8),
            Text('Slots: $slots'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => dutyProvider.toggleSignup(
                groupId: userProvider.userGroupId,
                duty: duty,
                user: userProvider.user!,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isUserSignedUp ? Colors.red : Colors.green,
              ),
              child: Text(
                isUserSignedUp ? "Zrezygnuj" : "Dołącz",
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 8),
            if (duty.volunteers.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Osoby zapisane:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...duty.volunteers.map((u) => Text(u.fullName)),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, DutyProvider provider, String groupId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Usuń zadanie'),
        content: const Text('Czy na pewno chcesz usunąć tę służbę?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Anuluj')),
          ElevatedButton(
            onPressed: () {
              provider.deleteDuty(groupId, duty.id!);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Usuń', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
