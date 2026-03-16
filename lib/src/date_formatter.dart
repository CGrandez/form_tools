import 'package:flutter/services.dart';

/// Formateador de texto para fechas que inserta separadores automáticamente.
class FormToolsDateFormatter extends TextInputFormatter {
  /// El patrón de formato (ej. 'DD/MM/YYYY', 'YYYY-MM-DD', 'MM/YY').
  final String pattern;
  
  /// El separador extraído del patrón (ej. '/' o '-').
  final String separator;

  /// Crea un [FormToolsDateFormatter] con un [pattern] específico.
  FormToolsDateFormatter({required this.pattern}) 
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
