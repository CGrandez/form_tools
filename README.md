# Form Tools

![Form Tools Logo](example/assets/image/form_tools.png)

A highly customizable, ready-to-use Flutter package that provides smart form fields, real-time text formatting, beautiful dynamic OTP widgets, and advanced data validation. 

Make your forms **Plug & Play**!

## Features

- **Smart Form Fields:** Pre-built `TextFormField` wrappers (`FormToolsDateField`, `FormToolsTimeField`, `FormToolsEmailField`, `FormToolsPasswordField`, `FormToolsCapitalizationField`) that handle formatting, validation, and error messages automatically.
- **Real-Time Text Formatters:** `TextInputFormatter` utilities to format text dynamically as the user types (e.g., automatically inserting slashes in dates `DD/MM/YYYY` or colons in times `HH:MM`).
- **Dynamic OTP Widget:** A beautiful, auto-focusing One-Time Password widget for authentication flows, featuring customizable lengths and input styles (Square, Circular, Underlined).
- **Advanced Validation:** Built-in email regex validation and highly customizable strong password validation (configurable minimum lengths and required character types).
- **Fully Localized Default Messages:** Easily customizable error messages for all inputs.

## Getting started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  form_tools: ^1.0.0
```

Import it in your Dart code:

```dart
import 'package:form_tools/form_tools.dart';
```

## Usage

### 1. Smart Fields (The Easiest Way)

Instead of manually writing validation logic and attaching formatters to standard `TextFormField`s, simply drop in our **Smart Fields** inside your Flutter `Form`:

```dart
// Automatic Date formatting and validation
const FormToolsDateField(
  pattern: 'DD/MM/YYYY',
  errorMessage: 'Please enter a valid date',
  futureDateOnly: true, // Only allow dates strictly in the future
),

// Automatic Time formatting and validation
const FormToolsTimeField(
  pattern: 'HH:MM:SS',
  errorMessage: 'Please enter a valid time',
),

// Email validation
const FormToolsEmailField(
  errorMessage: 'Invalid email address',
),

// Password with strength requirements and visibility toggle
const FormToolsPasswordField(
  minLength: 8,
  requireUppercase: true,
  requireLowercase: true,
  requireDigits: true,
  requireSpecialChar: true,
  errorMessage: 'Password is too weak',
),

// Auto-capitalization Title Case
const FormToolsCapitalizationField(
  labelText: 'Full Name',
  type: CapitalizationType.words,
),
```

Just call `_formKey.currentState!.validate()` on your form, and the Smart Fields will handle the rest!

### 2. Formatters (Manual Usage)

If you prefer to use your own Custom TextFields, you can attach our formatters directly to the `inputFormatters` property:

```dart
TextField(
  decoration: const InputDecoration(labelText: 'Expiration Date (MM/YY)'),
  inputFormatters: [FormToolsDateFormatter(pattern: 'MM/YY')],
)
```

### 3. Centralized Validators

If you need to validate data programmatically outside of a form field, use our centralized utility class `FormToolsValidators`. It contains all the logic you need:

```dart
// Check if a date string matches a pattern and is logically possible
bool validDate = FormToolsValidators.isValidDate('12/25', 'MM/YY'); 

// Check if a time string is logically possible
bool validTime = FormToolsValidators.isValidTime('23:59:59', 'HH:MM:SS'); 

// Check email via RFC standard Regex
bool validEmail = FormToolsValidators.isValidEmail('test@example.com');

// Highly customizable strong password checking
bool isStrong = FormToolsValidators.isStrongPassword(
  'MyPass1!',
  minLength: 8,
  requireUppercase: true,
  requireLowercase: true,
  requireDigits: true,
  requireSpecialChar: true,
);
```

### 4. Dynamic OTP Widget

Perfect for 2FA or PIN verification screens:

```dart
DynamicOTPWidget(
  length: 6, // 6 digit code
  decorationStyle: OtpDecorationStyle.circular, // or square, underlined
  borderColor: Colors.teal,
  onCompleted: (String code) {
    print('OTP Entered: $code');
    // Verify code with backend...
  },
)
```

## Additional information

For more detailed examples, check out the `example/` folder inside the repository. It includes a complete showcase app demonstrating Real-Time validation, the various OTP widget styles, and all Formatter configurations.
