import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  const TextInput({super.key, this.value, this.onChanged});

  final String? value;
  final void Function(String?)? onChanged;

  @override
  State<TextInput> createState() =>
      _TextInputState();
}

class _TextInputState extends State<TextInput> {
  late final TextEditingController _controller;
  String? _prevValue;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TextInput oldWidget) {
    if (_prevValue != widget.value) {
      _prevValue = widget.value;
      _controller.value = TextEditingValue(text: widget.value ?? "");
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: widget.onChanged,
      controller: _controller,
    );
  }
}
