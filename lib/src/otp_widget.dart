import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Define el estilo de la decoración de los campos OTP.
enum OtpDecorationStyle {
  /// Bordes cuadrados o rectangulares (OutlineInputBorder).
  square,
  /// Bordes completamente redondeados.
  circular,
  /// Solo línea inferior (UnderlineInputBorder).
  underlined,
}

/// Un widget dinámico y personalizable para ingresar códigos OTP (One Time Password).
class DynamicOTPWidget extends StatefulWidget {
  /// Cantidad de dígitos/campos del código OTP.
  final int length;

  /// Callback que se llama cuando se ha ingresado el código completo.
  final ValueChanged<String> onCompleted;

  /// Estilo de decoración de cada campo.
  final OtpDecorationStyle decorationStyle;

  /// Color del borde del campo.
  final Color borderColor;

  /// Crea un [DynamicOTPWidget].
  const DynamicOTPWidget({
    super.key,
    required this.length,
    required this.onCompleted,
    this.decorationStyle = OtpDecorationStyle.square,
    this.borderColor = Colors.blue,
  });

  @override
  State<DynamicOTPWidget> createState() => _DynamicOTPWidgetState();
}

class _DynamicOTPWidgetState extends State<DynamicOTPWidget> {
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (index) => TextEditingController());
    _focusNodes = List.generate(widget.length, (index) {
      final node = FocusNode();
      // Escuchar eventos de teclado crudo para detectar retroceso en campos vacíos
      node.onKeyEvent = (node, event) {
        if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.backspace) {
          if (_controllers[index].text.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
            _controllers[index - 1].clear();
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      };
      return node;
    });
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        _checkCompletion();
      }
    }
  }

  void _checkCompletion() {
    String code = '';
    for (var controller in _controllers) {
      if (controller.text.isEmpty) return;
      code += controller.text;
    }
    if (code.length == widget.length) {
      widget.onCompleted(code);
    }
  }

  InputBorder _getBorder() {
    switch (widget.decorationStyle) {
      case OtpDecorationStyle.square:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: widget.borderColor),
        );
      case OtpDecorationStyle.circular:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.0),
          borderSide: BorderSide(color: widget.borderColor),
        );
      case OtpDecorationStyle.underlined:
        return UnderlineInputBorder(
          borderSide: BorderSide(color: widget.borderColor, width: 2.0),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(widget.length, (index) {
        return SizedBox(
          width: 50,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            onChanged: (value) => _onChanged(value, index),
            decoration: InputDecoration(
              counterText: '',
              enabledBorder: _getBorder(),
              focusedBorder: _getBorder(),
            ),
          ),
        );
      }),
    );
  }
}
