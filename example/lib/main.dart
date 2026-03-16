import 'package:flutter/material.dart';
import 'package:form_tools/form_tools.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Tools Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatelessWidget {
  const ExampleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Form Tools Showcase'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.auto_awesome), text: 'Smart Fields'),
              Tab(
                icon: Icon(Icons.settings_input_component),
                text: 'Formatters',
              ),
              Tab(icon: Icon(Icons.password), text: 'OTP Widgets'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [SmartFieldsTab(), RawFormattersTab(), OtpWidgetsTab()],
        ),
      ),
    );
  }
}

/// TAB 1: Demonstrates the ready-to-use Smart Form Fields.
class SmartFieldsTab extends StatefulWidget {
  const SmartFieldsTab({super.key});

  @override
  State<SmartFieldsTab> createState() => _SmartFieldsTabState();
}

class _SmartFieldsTabState extends State<SmartFieldsTab> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All Smart Fields are valid!')),
      );
    } else {
      setState(() {
        _autovalidateMode = AutovalidateMode.always;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        autovalidateMode: _autovalidateMode,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Smart Fields (Plug & Play)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('No controllers or manual validation logic needed.'),
            const SizedBox(height: 24),

            const FormToolsDateField(
              pattern: 'DD/MM/YYYY',
              futureDateOnly: true,
              decoration: InputDecoration(
                labelText: 'Fecha Futura Obligatoria',
                hintText: 'DD/MM/YYYY',
                border: OutlineInputBorder(),
              ),
              errorMessage: 'Ingrese una fecha válida en el futuro',
            ),
            const SizedBox(height: 16),

            const FormToolsDateField(
              pattern: 'YYYY-MM-DD',
              decoration: InputDecoration(
                labelText: 'Fecha (YYYY-MM-DD)',
                hintText: 'YYYY-MM-DD',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            const FormToolsTimeField(pattern: 'HH:MM:SS'),
            const SizedBox(height: 16),

            const FormToolsCapitalizationField(
              labelText: 'Nombre Completo (Title Case)',
            ),
            const SizedBox(height: 16),

            const FormToolsEmailField(),
            const SizedBox(height: 16),

            const FormToolsPasswordField(
              minLength: 6,
              requireSpecialChar: false,
              errorMessage:
                  'Mínimo 6 chars, requiere mayúscula, minúscula y número',
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _submit,
              child: const Text('Validar Formulario Completo'),
            ),
          ],
        ),
      ),
    );
  }
}

/// TAB 2: Demonstrates how to use formatters on regular TextFields.
class RawFormattersTab extends StatefulWidget {
  const RawFormattersTab({super.key});

  @override
  State<RawFormattersTab> createState() => _RawFormattersTabState();
}

class _RawFormattersTabState extends State<RawFormattersTab> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _upperController = TextEditingController();
  final _lowerController = TextEditingController();
  bool _isValidDate = false;

  void _validate() {
    if (_formKey.currentState!.validate()) {
      bool dateValid = FormToolsValidators.isValidDate(
        _dateController.text,
        'MM/YY',
      );
      if (dateValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Raw Formatters Validated Correctly!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid date.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Text Input Formatters',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Attach these to any TextField formatters list.'),
            const SizedBox(height: 24),

            TextFormField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Date MM/YY',
                border: const OutlineInputBorder(),
                suffixIcon: Icon(
                  _isValidDate ? Icons.check_circle : Icons.error,
                  color: _isValidDate ? Colors.green : Colors.red,
                ),
              ),
              onChanged: (val) {
                setState(() {
                  _isValidDate = FormToolsValidators.isValidDate(val, 'MM/YY');
                });
              },
              inputFormatters: [FormToolsDateFormatter(pattern: 'MM/YY')],
              validator: (val) => _isValidDate ? null : 'Invalid date format',
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _upperController,
              decoration: const InputDecoration(
                labelText: 'All Uppercase',
                border: OutlineInputBorder(),
              ),
              inputFormatters: [
                FormToolsCapitalizationFormatter(
                  type: CapitalizationType.allUpper,
                ),
              ],
              validator: (val) =>
                  val != null && val.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _lowerController,
              decoration: const InputDecoration(
                labelText: 'All Lowercase',
                border: OutlineInputBorder(),
              ),
              inputFormatters: [
                FormToolsCapitalizationFormatter(
                  type: CapitalizationType.allLower,
                ),
              ],
              validator: (val) =>
                  val != null && val.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _validate,
              child: const Text('Validate Fields'),
            ),
          ],
        ),
      ),
    );
  }
}

/// TAB 3: Demonstrates the various OTP Widget configurations.
class OtpWidgetsTab extends StatefulWidget {
  const OtpWidgetsTab({super.key});

  @override
  State<OtpWidgetsTab> createState() => _OtpWidgetsTabState();
}

class _OtpWidgetsTabState extends State<OtpWidgetsTab> {
  void _onOtpCompleted(String code, String type) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('OTP completado en $type: $code')));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Dynamic OTP Widgets',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Auto-focusing, customizable lengths and shapes.'),
          const SizedBox(height: 24),

          const Text('Length: 4 | Style: Underlined'),
          const SizedBox(height: 8),
          DynamicOTPWidget(
            length: 4,
            decorationStyle: OtpDecorationStyle.underlined,
            borderColor: Colors.deepPurple,
            onCompleted: (c) => _onOtpCompleted(c, 'Underlined 4'),
          ),
          const SizedBox(height: 32),

          const Text('Length: 6 | Style: Circular'),
          const SizedBox(height: 8),
          DynamicOTPWidget(
            length: 6,
            decorationStyle: OtpDecorationStyle.circular,
            borderColor: Colors.teal,
            onCompleted: (c) => _onOtpCompleted(c, 'Circular 6'),
          ),
          const SizedBox(height: 32),

          const Text('Length: 5 | Style: Square'),
          const SizedBox(height: 8),
          DynamicOTPWidget(
            length: 5,
            decorationStyle: OtpDecorationStyle.square,
            borderColor: Colors.blueGrey,
            onCompleted: (c) => _onOtpCompleted(c, 'Square 5'),
          ),
        ],
      ),
    );
  }
}
