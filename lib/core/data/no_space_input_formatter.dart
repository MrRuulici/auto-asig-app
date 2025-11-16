import 'package:flutter/services.dart';

class NoSpaceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove any whitespace from the new value
    final newText = newValue.text.replaceAll(RegExp(r'\s+'), '');
    
    // Calculate how many spaces were removed before the cursor
    final spacesBeforeCursor = newValue.text
        .substring(0, newValue.selection.baseOffset)
        .replaceAll(RegExp(r'[^\s]'), '')
        .length;
    
    // Adjust the cursor position by subtracting the number of removed spaces
    final newOffset = (newValue.selection.baseOffset - spacesBeforeCursor)
        .clamp(0, newText.length);
    
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newOffset),
    );
  }
}