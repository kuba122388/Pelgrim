import 'package:flutter/material.dart';
import 'package:pelgrim/domain/entities/duty.dart';

class AddDutyDialog extends StatefulWidget {
  final Future<void> Function(
    Duty newDuty,
  ) onConfirm;

  const AddDutyDialog({super.key, required this.onConfirm});

  @override
  State<AddDutyDialog> createState() => _AddDutyDialogState();
}

class _AddDutyDialogState extends State<AddDutyDialog> {
  late final TextEditingController _titleController;

  int _maxVolunteers = 1;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nowe zadanie'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Tytuł zadania'),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('Maksymalna liczba osób:'),
              const SizedBox(width: 10),
              DropdownButton<int>(
                value: _maxVolunteers,
                items: List.generate(16, (index) => index + 1)
                    .map(
                      (val) => DropdownMenuItem(
                        value: val,
                        child: Text(val.toString()),
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _maxVolunteers = val);
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
            final title = _titleController.text.trim();
            if (title.isEmpty) return;

            final newDuty = Duty(
              title: title,
              maxVolunteers: _maxVolunteers,
              createdAt: DateTime.now(),
            );

            await widget.onConfirm(newDuty);

            Navigator.of(context).pop();
          },
          child: const Text('Dodaj'),
        ),
      ],
    );
  }
}
