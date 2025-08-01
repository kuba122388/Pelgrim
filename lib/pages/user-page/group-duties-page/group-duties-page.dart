import 'package:flutter/material.dart';
import 'package:pelgrim/models/Duty.dart';
import 'package:pelgrim/models/MyUser.dart';
import 'package:pelgrim/pages/widgets/DutyBox.dart';

class GroupDutiesPage extends StatefulWidget {
  final Map<String, dynamic> settings;
  final MyUser myUser;

  const GroupDutiesPage({
    super.key,
    required this.settings,
    required this.myUser,
  });

  @override
  State<GroupDutiesPage> createState() => _GroupDutiesPageState();
}

class _GroupDutiesPageState extends State<GroupDutiesPage> {
  late String group =
      '${widget.settings['groupColor']} - ${widget.settings['groupCity']}';

  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: FutureBuilder<List<Duty>>(
            future: Duty.loadDuties(group),
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
                    currentUser: widget.myUser,
                    group: group,
                    onRefresh: _refresh,
                  );
                },
              );
            },
          ),
        ),
        if (widget.myUser.admin)
          Positioned(
            bottom: 16,
            right: 16,
            child: ElevatedButton.icon(
              onPressed: () => _showAddDutyDialog(context),
              icon: const Icon(Icons.add),
              label: const Text("Dodaj zadanie"),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showAddDutyDialog(BuildContext context) {
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
                await newDuty.addDuty(group);
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