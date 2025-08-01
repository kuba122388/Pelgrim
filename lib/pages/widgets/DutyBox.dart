import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pelgrim/models/Duty.dart';
import 'package:pelgrim/models/MyUser.dart';

class DutyBox extends StatefulWidget {
  final Duty duty;
  final MyUser currentUser;
  final String group;
  final VoidCallback onRefresh;

  const DutyBox({
    super.key,
    required this.duty,
    required this.currentUser,
    required this.group,
    required this.onRefresh,
  });

  @override
  State<DutyBox> createState() => _DutyBoxState();
}

class _DutyBoxState extends State<DutyBox> {
  late Duty duty;

  @override
  void initState() {
    super.initState();
    duty = widget.duty;
  }

  bool get isUserSignedUp {
    return duty.volunteers
        .any((user) => user.email == widget.currentUser.email);
  }

  Future<void> _toggleSignup() async {
    final isSignedUp = isUserSignedUp;

    if (!isSignedUp && duty.volunteers.length >= duty.maxVolunteers) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Brak wolnych miejsc")),
      );
      return;
    }

    setState(() {
      if (isSignedUp) {
        duty.volunteers
            .removeWhere((user) => user.email == widget.currentUser.email);
      } else {
        duty.volunteers.add(widget.currentUser);
      }
    });

    await FirebaseFirestore.instance
        .collection('Pelgrim Groups')
        .doc(widget.group)
        .collection('Duties')
        .doc(duty.id)
        .update({
      'Volunteers': duty.volunteers.map((u) => u.toMapUser()).toList(),
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    maxLines: null,
                  ),
                ),
                const SizedBox(width: 10),
                if (widget.currentUser.admin) GestureDetector(
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Potwierdzenie'),
                        content: const Text('Czy na pewno chcesz usunąć to zadanie?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(false),
                            child: const Text('Anuluj'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.of(ctx).pop(true),
                            child: const Text('Usuń'),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await FirebaseFirestore.instance
                          .collection('Pelgrim Groups')
                          .doc(widget.group)
                          .collection('Duties')
                          .doc(duty.id)
                          .delete();

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Zadanie zostało usunięte.')),
                        );
                        widget.onRefresh();
                      }
                    }
                  },
                  child: Image.asset("./images/trash.png", width: 20, height: 20),
                )

              ],
            ),
            const SizedBox(height: 8),
            Text('Slots: $slots'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _toggleSignup,
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
                  ...duty.volunteers
                      .map((u) => Text('${u.firstName} ${u.lastName}')),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
