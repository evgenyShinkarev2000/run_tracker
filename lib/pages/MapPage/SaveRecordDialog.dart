import 'package:flutter/material.dart';
import 'package:run_tracker/helpers/extensions/BuildContextExtension.dart';

class SaveRecordDialog extends StatefulWidget {
  final Function(String title) onSave;
  final String titleInitial;

  const SaveRecordDialog({super.key, required this.onSave, required this.titleInitial});

  @override
  State<SaveRecordDialog> createState() => _SaveRecordDialogState();
}

class _SaveRecordDialogState extends State<SaveRecordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  @override
  void initState() {
    _titleController.text = widget.titleInitial;
    Future(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final saveLabel = context.appLocalization.verbSave;
    final titleValidatorMessage = context.appLocalization.saveRecordDialogTitleValidatorMessage(1);

    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: _formKey,
            child: TextFormField(
              validator: (value) => value != null && value.trim().isNotEmpty ? null : titleValidatorMessage,
              controller: _titleController,
              onChanged: (_) => setState(() {}),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _formKey.currentState?.validate() ?? false ? () => widget.onSave(_titleController.text) : null,
          child: Text(saveLabel),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}
