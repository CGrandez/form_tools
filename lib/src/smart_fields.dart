import 'package:flutter/material.dart';
import 'package:form_tools/src/date_formatter.dart';
import 'package:form_tools/src/time_formatter.dart';
import 'package:form_tools/src/validators.dart';
import 'package:form_tools/src/cap_formatter.dart';

/// Campo de texto listo para usar con autocompletado y validación de fechas.
class FormToolsDateField extends StatelessWidget {
  final String pattern;
  final String? errorMessage;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final InputDecoration? decoration;
  final bool futureDateOnly;

  const FormToolsDateField({
    super.key,
    this.pattern = 'DD/MM/YYYY',
    this.errorMessage = 'Invalid date',
    this.controller,
    this.onChanged,
    this.onSaved,
    this.decoration,
    this.futureDateOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      onChanged: onChanged,
      onSaved: onSaved,
      inputFormatters: [FormToolsDateFormatter(pattern: pattern)],
      validator: (value) {
        if (value == null || value.isEmpty) return null;
        if (!FormToolsValidators.isValidDate(
          value, 
          pattern, 
          futureDateOnly: futureDateOnly,
        )) {
          return errorMessage;
        }
        return null;
      },
      decoration: decoration ?? InputDecoration(
        labelText: 'Fecha',
        hintText: pattern,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

/// Campo de texto listo para usar con autocompletado y validación de horas.
class FormToolsTimeField extends StatelessWidget {
  final String pattern;
  final String? errorMessage;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final InputDecoration? decoration;

  const FormToolsTimeField({
    super.key,
    this.pattern = 'HH:MM',
    this.errorMessage = 'Invalid time',
    this.controller,
    this.onChanged,
    this.onSaved,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      onChanged: onChanged,
      onSaved: onSaved,
      inputFormatters: [FormToolsTimeFormatter(pattern: pattern)],
      validator: (value) {
        if (value == null || value.isEmpty) return null;
        if (!FormToolsValidators.isValidTime(value, pattern)) {
          return errorMessage;
        }
        return null;
      },
      decoration: decoration ?? InputDecoration(
        labelText: 'Hora',
        hintText: pattern,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

/// Campo de texto listo para usar con validación de correo electrónico.
class FormToolsEmailField extends StatelessWidget {
  final String? errorMessage;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final InputDecoration? decoration;
  final bool isRequired;

  const FormToolsEmailField({
    super.key,
    this.errorMessage = 'Invalid email address',
    this.controller,
    this.onChanged,
    this.onSaved,
    this.decoration,
    this.isRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      onChanged: onChanged,
      onSaved: onSaved,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return isRequired ? 'This field is required' : null;
        }
        if (!FormToolsValidators.isValidEmail(value)) {
          return errorMessage;
        }
        return null;
      },
      decoration: decoration ?? const InputDecoration(
        labelText: 'Correo Electrónico',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.email),
      ),
    );
  }
}

/// Campo de texto listo para usar con validación de contraseña fuerte y botón para mostrar/ocultar.
class FormToolsPasswordField extends StatefulWidget {
  final String? errorMessage;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final InputDecoration? decoration;
  final bool isRequired;

  // Configuraciones de validación
  final int minLength;
  final bool requireUppercase;
  final bool requireLowercase;
  final bool requireDigits;
  final bool requireSpecialChar;

  const FormToolsPasswordField({
    super.key,
    this.errorMessage = 'Weak password',
    this.controller,
    this.onChanged,
    this.onSaved,
    this.decoration,
    this.isRequired = true,
    this.minLength = 8,
    this.requireUppercase = true,
    this.requireLowercase = true,
    this.requireDigits = true,
    this.requireSpecialChar = true,
  });

  @override
  State<FormToolsPasswordField> createState() => _FormToolsPasswordFieldState();
}

class _FormToolsPasswordFieldState extends State<FormToolsPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      onChanged: widget.onChanged,
      onSaved: widget.onSaved,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return widget.isRequired ? 'This field is required' : null;
        }
        if (!FormToolsValidators.isStrongPassword(
          value,
          minLength: widget.minLength,
          requireUppercase: widget.requireUppercase,
          requireLowercase: widget.requireLowercase,
          requireDigits: widget.requireDigits,
          requireSpecialChar: widget.requireSpecialChar,
        )) {
          return widget.errorMessage;
        }
        return null;
      },
      decoration: widget.decoration ?? InputDecoration(
        labelText: 'Contraseña',
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }
}

/// Campo de texto con auto-capitalización.
class FormToolsCapitalizationField extends StatelessWidget {
  final CapitalizationType type;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final InputDecoration? decoration;
  final String labelText;

  const FormToolsCapitalizationField({
    super.key,
    this.type = CapitalizationType.words,
    this.controller,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.decoration,
    this.labelText = 'Texto',
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      onSaved: onSaved,
      validator: validator,
      inputFormatters: [FormToolsCapitalizationFormatter(type: type)],
      decoration: decoration ?? InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
