import 'package:flutter/services.dart';

class NumberRangeTextInputFormatter extends TextInputFormatter {
  final int minValue;
  final int maxValue;

  NumberRangeTextInputFormatter(this.minValue, this.maxValue);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    int? number = int.tryParse(newValue.text);
    if (number == null || number < minValue || number > maxValue) {
      // Invalid input, return old value
      return oldValue;
    }
    return newValue;
  }
}