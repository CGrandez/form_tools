# Form Tools Example App

This directory contains a full Flutter application demonstrating all the features of the `form_tools` package.

## Running the Example

Make sure you are in the `example` directory:

```bash
cd example
flutter run
```

## What's Included

The example app is organized into three primary tabs to clearly showcase the different ways you can use the package:

1. **Smart Fields (Plug & Play):** Demonstrates the absolute easiest way to build forms. It uses our pre-built `FormToolsDateField`, `FormToolsTimeField`, `FormToolsEmailField`, `FormToolsPasswordField`, and `FormToolsCapitalizationField`. These components manage their own controllers and hook seamlessly into a standard Flutter `Form` validation.
2. **Formatters (Manual Usage):** Shows how to use the underlying formatters (`FormToolsDateFormatter`, `FormToolsCapitalizationFormatter`) on raw, standard `TextField` or `TextFormField` widgets. It also demonstrates how to manually validate values using the centralized `FormToolsValidators` class.
3. **OTP Widgets:** Showcases the `DynamicOTPWidget` in action with varying configurations (different lengths, and varying styles like Underlined, Circular, and Square).

## Source Code

To see exactly how these are implemented, open `lib/main.dart` in your editor.
