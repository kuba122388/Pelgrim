import 'package:flutter/cupertino.dart';

import '../../domain/entities/help_request.dart';
import '../../domain/usecases/help/send_help_request_use_case.dart';

class HelpProvider extends ChangeNotifier {
  final SendHelpRequestUseCase _sendHelpRequestUseCase;

  bool _isProcessing = false;

  bool get isProcessing => _isProcessing;

  HelpProvider(this._sendHelpRequestUseCase);

  Future<void> send({
    required String title,
    required String content,
    required String groupId,
    required String userEmail,
  }) async {
    if (_isProcessing) return;

    _isProcessing = true;
    notifyListeners();

    try {
      await _sendHelpRequestUseCase.execute(
        HelpRequest(
          title: title,
          content: content,
          groupId: groupId,
          userEmail: userEmail,
        ),
      );
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }
}
