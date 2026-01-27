import 'package:flutter/material.dart';
import 'package:pelgrim/core/const/app_consts.dart';
import 'package:pelgrim/core/const/app_styles.dart';

class AddAnnouncementDialog extends StatefulWidget {
  final Future<void> Function({
    required String content,
    required bool isImportant,
    required bool isAnonymous,
  }) onConfirm;

  const AddAnnouncementDialog({
    super.key,
    required this.onConfirm,
  });

  @override
  State<AddAnnouncementDialog> createState() => _AddAnnouncementDialogState();
}

class _AddAnnouncementDialogState extends State<AddAnnouncementDialog> {
  final TextEditingController _controller = TextEditingController();
  bool _isImportant = false;
  bool _isAnonymous = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Dodaj ogłoszenie'),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Image.asset(
              './images/close.png',
              width: 28,
              color: Colors.white.withValues(alpha: 0.2),
              colorBlendMode: BlendMode.lighten,
            ),
          ),
        ],
      ),
      titleTextStyle: const TextStyle(
        fontSize: FONT_SIZE_BIG,
        color: FONT_BLACK_COLOR,
        fontFamily: 'Lexend',
        fontWeight: FontWeight.bold,
        shadows: [APP_TEXT_SHADOW],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Treść', style: AppStyles.labelStyle),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 20),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: BACKGROUND_CONTAINERS_COLOR,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(border: InputBorder.none),
                textCapitalization: TextCapitalization.sentences,
                style: const TextStyle(fontSize: FONT_SIZE_SMALL),
                maxLines: 8,
              ),
            ),
            _buildCheckboxes(),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _checkboxWithLabel(
          label: 'Oznacz jako ważne',
          value: _isImportant,
          onChanged: (v) => setState(() => _isImportant = v!),
        ),
        _checkboxWithLabel(
          label: 'Post anonimowy',
          value: _isAnonymous,
          onChanged: (v) => setState(() => _isAnonymous = v!),
        ),
      ],
    );
  }

  Widget _checkboxWithLabel({
    required String label,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 30,
          height: 24,
          child: Checkbox(
            activeColor: Colors.grey,
            value: value,
            onChanged: onChanged,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontFamily: 'Lexend',
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: ElevatedButton(
            onPressed: _isProcessing ? null : _handleConfirm,
            child: _isProcessing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'Opublikuj',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleConfirm() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() => _isProcessing = true);

    try {
      await widget.onConfirm(
        content: _controller.text.trim(),
        isImportant: _isImportant,
        isAnonymous: _isAnonymous,
      );

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nie udało się dodać ogłoszenia')),
        );
      }
    }
  }
}
