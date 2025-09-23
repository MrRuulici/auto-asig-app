import 'package:flutter/services.dart';

class NoSpaceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove any whitespace from the new value
    final newText = newValue.text.replaceAll(RegExp(r'\s+'), '');
    return TextEditingValue(
      text: newText,
      selection: newValue.selection,
    );
  }
}
