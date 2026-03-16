import 'package:flutter/services.dart';

/// Tipos de capitalización disponibles para [FormToolsCapitalizationFormatter].
enum CapitalizationType {
  /// Convierte todo el texto a mayúsculas.
  allUpper,
  /// Convierte todo el texto a minúsculas.
  allLower,
  /// Convierte solo la primera letra de todo el campo a mayúscula.
  firstLetterOnly,
  /// Convierte la primera letra de cada palabra a mayúscula.
  words,
}

/// Formateador de texto inteligente para manejar la capitalización de cadenas.
class FormToolsCapitalizationFormatter extends TextInputFormatter {
  /// El tipo de capitalización a aplicar.
  final CapitalizationType type;

  /// Crea un [FormToolsCapitalizationFormatter] con el [type] especificado.
  FormToolsCapitalizationFormatter({required this.type});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    String formattedText = newValue.text;

    switch (type) {
      case CapitalizationType.allUpper:
        formattedText = newValue.text.toUpperCase();
        break;
      case CapitalizationType.allLower:
        formattedText = newValue.text.toLowerCase();
        break;
      case CapitalizationType.firstLetterOnly:
        formattedText = _capitalizeFirstLetter(newValue.text);
        break;
      case CapitalizationType.words:
        formattedText = _capitalizeWords(newValue.text);
        break;
    }

    return TextEditingValue(
      text: formattedText,
      selection: newValue.selection,
    );
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  String _capitalizeWords(String text) {
    if (text.isEmpty) return text;
    final parts = text.split(' ');
    for (int i = 0; i < parts.length; i++) {
      if (parts[i].isNotEmpty) {
        parts[i] = parts[i][0].toUpperCase() + parts[i].substring(1).toLowerCase();
      }
    }
    return parts.join(' ');
  }
}
