import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pelgrim/domain/entities/duty.dart';
import 'package:pelgrim/domain/entities/duty_volunteer.dart';
import 'package:pelgrim/domain/entities/user.dart';
import 'package:pelgrim/domain/usecases/duty/add_duty_use_case.dart';
import 'package:pelgrim/domain/usecases/duty/delete_duty_use_case.dart';
import 'package:pelgrim/domain/usecases/duty/get_duties_use_case.dart';
import 'package:pelgrim/domain/usecases/duty/toggle_duty_sign_up_use_case.dart';

class DutyProvider extends ChangeNotifier {
  final GetDutiesUseCase _getDutiesUseCase;
  final AddDutyUseCase _addDutyUseCase;
  final DeleteDutyUseCase _deleteDutyUseCase;
  final ToggleDutySignupUseCase _toggleDutySignupUseCase;

  StreamSubscription? _sub;
  List<Duty> _duties = [];

  List<Duty> get duties => _duties;

  DutyProvider(
    this._getDutiesUseCase,
    this._addDutyUseCase,
    this._deleteDutyUseCase,
    this._toggleDutySignupUseCase,
  );

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> addDuty(String groupId, Duty duty) async {
    _setLoading(true);

    try {
      await _addDutyUseCase.execute(groupId, duty);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> toggleSignup({
    required String groupId,
    required Duty duty,
    required User user,
  }) async {
    final volunteer = DutyVolunteer(
      fullName: user.fullName,
      userId: user.id,
    );

    try {
      await _toggleDutySignupUseCase.execute(groupId, duty, volunteer);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteDuty(String groupId, String dutyId) async {
    await _deleteDutyUseCase.execute(groupId, dutyId);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void start(String groupId) {
    _sub?.cancel();
    _sub = _getDutiesUseCase.execute(groupId).listen((data) {
      _duties = data;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
