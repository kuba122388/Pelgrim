import 'package:flutter/material.dart';
import 'package:pelgrim/core/di/service_locator.dart';
import 'package:pelgrim/domain/entities/duty.dart';
import 'package:pelgrim/domain/entities/group.dart';
import 'package:pelgrim/domain/entities/user.dart';
import 'package:pelgrim/domain/usecases/duty/add_duty_use_case.dart';
import 'package:pelgrim/domain/usecases/duty/get_duties_use_case.dart';
import 'package:pelgrim/presentation/providers/user_provider.dart';
import 'package:pelgrim/presentation/user/duties/widgets/add_duty_dialog.dart';
import 'package:pelgrim/presentation/widgets/duty_box.dart';
import 'package:provider/provider.dart';

class GroupDutiesPage extends StatefulWidget {
  const GroupDutiesPage({super.key});

  @override
  State<GroupDutiesPage> createState() => _GroupDutiesPageState();
}

class _GroupDutiesPageState extends State<GroupDutiesPage> {
  final AddDutyUseCase _addDutyUseCase = sl<AddDutyUseCase>();
  final GetDutiesUseCase _getDutiesUseCase = sl<GetDutiesUseCase>();

  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = context.read<UserProvider>();

    final Group groupInfo = userProvider.groupInfo!;
    final User myUser = userProvider.user!;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: StreamBuilder<List<Duty>>(
            stream: _getDutiesUseCase.execute(groupInfo.id),
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
                    group: groupInfo.id,
                    onRefresh: _refresh,
                  );
                },
              );
            },
          ),
        ),
        if (myUser.isAdmin)
          Positioned(
            bottom: 16,
            right: 16,
            child: ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AddDutyDialog(
                    onConfirm: (groupId, newDuty) async {
                      await _addDutyUseCase.execute(groupId, newDuty);
                      setState(() {});
                    },
                  ),
                );

                Navigator.of(context).pop();
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
