import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pelgrim/domain/entities/announcement.dart';

import '../../domain/usecases/announcement/add_announcement_use_case.dart';
import '../../domain/usecases/announcement/delete_announcement_use_case.dart';
import '../../domain/usecases/announcement/get_announcements_stream_use_case.dart';

class AnnouncementProvider extends ChangeNotifier {
  final AddAnnouncementUseCase _addAnnouncementUseCase;
  final DeleteAnnouncementUseCase _deleteAnnouncementUseCase;
  final GetAnnouncementsStreamUseCase _getAnnouncementsStreamUseCase;

  AnnouncementProvider(
    this._addAnnouncementUseCase,
    this._deleteAnnouncementUseCase,
    this._getAnnouncementsStreamUseCase,
  );

  StreamSubscription? _sub;

  List<Announcement> _announcementList = [];

  bool _isSubmitting = false;
  bool _isInitialLoading = true;

  bool get isSubmitting => _isSubmitting;

  bool get isInitialLoading => _isInitialLoading;

  List<Announcement> get announcementList => _announcementList;

  Future<void> deleteAnnouncement(String groupId, String announcementId) async {
    _isSubmitting = true;
    notifyListeners();
    try {
      await _deleteAnnouncementUseCase.execute(groupId, announcementId);
    } catch (_) {
      rethrow;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> addAnnouncement(String groupId, Announcement announcement) async {
    _isSubmitting = true;
    notifyListeners();
    try {
      await _addAnnouncementUseCase.execute(groupId, announcement);
    } catch (_) {
      rethrow;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  void startAnnouncementStream(String groupId) {
    _isInitialLoading = true;
    notifyListeners();

    _sub?.cancel();
    _sub = _getAnnouncementsStreamUseCase.execute(groupId).listen((list) {
      _announcementList = list;
      _isInitialLoading = false;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
