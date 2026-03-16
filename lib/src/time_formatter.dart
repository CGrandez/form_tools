import 'package:flutter/services.dart';

/// Formateador de texto para horas que inserta separadores automáticamente.
class FormToolsTimeFormatter extends TextInputFormatter {
  /// El patrón de formato (ej. 'HH:MM', 'HH:MM:SS').
  final String pattern;
  
  /// El separador extraído del patrón (ej. ':').
  final String separator;

  /// Crea un [FormToolsTimeFormatter] con un [pattern] específico.
  FormToolsTimeFormatter({this.pattern = 'HH:MM'}) 
      : separator = pattern.replaceAll(RegExp(r'[a-zA-Z]'), '')[0];

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;
    if (newValue.text.length < oldValue.text.length) return newValue;

    String cleanText = newValue.text.replaceAll(separator, '');
    String cleanPattern = pattern.replaceAll(separator, '');
    
    if (cleanText.length > cleanPattern.length) {
      return oldValue;
    }

    StringBuffer buffer = StringBuffer();
    int textIndex = 0;

    for (int i = 0; i < pattern.length; i++) {
      if (textIndex >= cleanText.length) break;

      if (pattern[i] == separator) {
        buffer.write(separator);
      } else {
        buffer.write(cleanText[textIndex]);
        textIndex++;
      }
    }

    final resultText = buffer.toString();
    
    // Autocompletar el separador si el usuario justo terminó de escribir un bloque
    if (resultText.length < pattern.length && pattern[resultText.length] == separator) {
      buffer.write(separator);
    }

    final finalText = buffer.toString();

    return TextEditingValue(
      text: finalText,
      selection: TextSelection.collapsed(offset: finalText.length),
    );
  }
}
