import 'package:flutter/material.dart';
import 'package:pelgrim/core/const/app_consts.dart';
import 'package:pelgrim/domain/entities/announcement.dart';

class DeleteAnnouncementDialog extends StatefulWidget {
  final Announcement announcement;
  final Future<void> Function() onConfirm;

  const DeleteAnnouncementDialog({
    super.key,
    required this.announcement,
    required this.onConfirm,
  });

  @override
  State<DeleteAnnouncementDialog> createState() => _DeleteAnnouncementDialogState();
}

class _DeleteAnnouncementDialogState extends State<DeleteAnnouncementDialog> {
  bool _processing = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return AlertDialog(
      title: const Text(
        'Czy na pewno chcesz usunąć ten wpis?',
        textAlign: TextAlign.center,
      ),
      titleTextStyle: const TextStyle(
        fontSize: 18,
        color: Colors.black,
        fontFamily: 'Lexend',
      ),
      content: Container(
        constraints: BoxConstraints(minHeight: screenHeight * 0.15),
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  '"${widget.announcement.content}"',
                  style: const TextStyle(
                    fontFamily: 'Lexend',
                    fontSize: 14,
                  ),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _actionButton(
                    text: 'Anuluj',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  _actionButton(
                    text: 'Usuń',
                    isDestructive: true,
                    onPressed: _processing
                        ? null
                        : () async {
                            setState(() => _processing = true);
                            widget.onConfirm();
                            if (mounted) {
                              Navigator.of(context).pop();
                            }
                          },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButton({
    required String text,
    required VoidCallback? onPressed,
    bool isDestructive = false,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all<Color>(
          isDestructive ? Colors.white : FONT_BLACK_COLOR,
        ),
        backgroundColor: WidgetStateProperty.all<Color>(
          isDestructive ? Colors.red : Colors.white,
        ),
        padding: WidgetStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(horizontal: 20),
        ),
        textStyle: WidgetStateProperty.all<TextStyle>(
          const TextStyle(fontFamily: 'Lexend'),
        ),
      ),
      child: SizedBox(
        width: 60,
        child: Center(child: Text(text)),
      ),
    );
  }
}
