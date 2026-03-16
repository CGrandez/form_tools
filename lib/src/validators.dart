/// Clase utilitaria con métodos estáticos para validaciones comunes dentro de la aplicación.
class FormToolsValidators {
  FormToolsValidators._(); // Constructor privado para evitar la instanciación de la clase utilitaria

  /// Valida si un texto es un correo electrónico con formato válido usando una
  /// Expresión Regular profesional y robusta (basada en el estándar RFC 5322).
  ///
  /// Retorna `true` si el [email] es válido y cumple la expresión regular, 
  /// de lo contrario retorna `false`.
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    
    // Regex estándar y robusta para correos electrónicos
    final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
    );
    
    return emailRegex.hasMatch(email);
  }

  /// Valida la fuerza de una contraseña para asegurar la protección del usuario.
  /// 
  /// Permite configurar los requisitos:
  /// - [minLength]: Longitud mínima requerida (por defecto 8).
  /// - [requireUppercase]: Si debe incluir al menos una mayúscula (por defecto true).
  /// - [requireLowercase]: Si debe incluir al menos una minúscula (por defecto true).
  /// - [requireDigits]: Si debe incluir al menos un número (por defecto true).
  /// - [requireSpecialChar]: Si debe incluir al menos un carácter especial (por defecto true).
  ///
  /// Retorna `true` si la [password] cumple los requisitos configurados, de lo contrario `false`.
  static bool isStrongPassword(
    String password, {
    int minLength = 8,
    bool requireUppercase = true,
    bool requireLowercase = true,
    bool requireDigits = true,
    bool requireSpecialChar = true,
  }) {
    if (password.length < minLength) return false;

    if (requireUppercase && !password.contains(RegExp(r'[A-Z]'))) return false;
    if (requireLowercase && !password.contains(RegExp(r'[a-z]'))) return false;
    if (requireDigits && !password.contains(RegExp(r'[0-9]'))) return false;
    if (requireSpecialChar && !password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>\-_]'))) return false;

    return true;
  }

  /// Valida si una cadena [value] corresponde a una fecha lógicamente posible 
  /// según el [pattern] especificado (ej. 'DD/MM/YYYY', 'MM/YY').
  ///
  /// Si [futureDateOnly] es true, validará que la fecha ingresada sea estrictamente
  /// mayor a la fecha de hoy.
  static bool isValidDate(String value, String pattern, {bool futureDateOnly = false}) {
    if (value.length != pattern.length) return false;

    final separator = pattern.replaceAll(RegExp(r'[a-zA-Z]'), '')[0];
    final parts = value.split(separator);
    final patternParts = pattern.split(separator);

    if (parts.length != patternParts.length) return false;

    int? day, month, year;
    int yearLength = 4;

    for (int i = 0; i < parts.length; i++) {
      int? numValue = int.tryParse(parts[i]);
      if (numValue == null) return false;

      final p = patternParts[i].toLowerCase();
      if (p.contains('d')) {
        day = numValue;
      } else if (p.contains('m')) {
        month = numValue;
      } else if (p.contains('y')) {
        year = numValue;
        yearLength = p.length;
      }
    }

    if (month != null && (month < 1 || month > 12)) return false;

    if (year != null) {
      if (yearLength == 2) {
        if (year < 0 || year > 99) return false;
      } else {
        if (year < 1000 || year > 9999) return false;
      }
    }

    if (day != null && month != null) {
      int fullYear = 2000; // Base year for leap year calculation if year is omitted
      if (year != null) {
         fullYear = yearLength == 2 ? 2000 + year : year;
      }
      
      final daysInMonth = [
        31, (fullYear % 4 == 0 && (fullYear % 100 != 0 || fullYear % 400 == 0)) ? 29 : 28, 
        31, 30, 31, 30, 31, 31, 30, 31, 30, 31
      ];

      if (day < 1 || day > daysInMonth[month - 1]) return false;
    }

    if (futureDateOnly) {
      final now = DateTime.now();
      if (day != null && month != null && year != null) {
        final fullYearCalculated = yearLength == 2 ? 2000 + year : year;
        final inputDate = DateTime(fullYearCalculated, month, day);
        final today = DateTime(now.year, now.month, now.day);
        if (!inputDate.isAfter(today)) return false; 
      } else if (month != null && year != null) {
        final fullYearCalculated = yearLength == 2 ? 2000 + year : year;
        final inputDate = DateTime(fullYearCalculated, month);
        final todayMonth = DateTime(now.year, now.month);
        if (!inputDate.isAfter(todayMonth)) return false; 
      }
    }

    return true;
  }

  /// Valida si una cadena [value] corresponde a una hora lógicamente posible 
  /// según el [pattern] especificado (ej. 'HH:MM', 'HH:MM:SS').
  static bool isValidTime(String value, String pattern) {
    if (value.length != pattern.length) return false;

    final separator = pattern.replaceAll(RegExp(r'[a-zA-Z]'), '')[0];
    final parts = value.split(separator);
    final patternParts = pattern.split(separator);

    if (parts.length != patternParts.length) return false;

    int? hour, minute, second;

    for (int i = 0; i < parts.length; i++) {
      int? numValue = int.tryParse(parts[i]);
      if (numValue == null) return false;

      if (patternParts[i].toUpperCase().contains('H')) {
        hour = numValue;
      } else if (patternParts[i].toUpperCase().contains('M')) {
        minute = numValue;
      } else if (patternParts[i].toUpperCase().contains('S')) {
        second = numValue;
      }
    }

    if (hour != null && (hour < 0 || hour > 23)) return false;
    if (minute != null && (minute < 0 || minute > 59)) return false;
    if (second != null && (second < 0 || second > 59)) return false;

    return true;
  }
}
