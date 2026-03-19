import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_tools/form_tools.dart';

void main() {
  testWidgets('FormToolsSearchField filters items', (WidgetTester tester) async {
    final items = ['Apple', 'Banana', 'Cherry'];
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FormToolsSearchField<String>(
            items: items,
            labelBuilder: (item) => item,
          ),
        ),
      ),
    );

    // Enter text to trigger filtering
    await tester.enterText(find.byType(TextFormField), 'Ap');
    await tester.pumpAndSettle();

    // Check if 'Apple' is shown in the options
    expect(find.text('Apple'), findsOneWidget);
    expect(find.text('Banana'), findsNothing);
    
    // Select the option
    await tester.tap(find.text('Apple'));
    await tester.pumpAndSettle();
    
    // Check if the text field is updated
    expect(find.widgetWithText(TextFormField, 'Apple'), findsOneWidget);
  });
}
