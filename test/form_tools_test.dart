import 'package:flutter_test/flutter_test.dart';
import 'package:form_tools/form_tools.dart';

void main() {
  test('isStrongPassword validates correctly', () {
    expect(FormToolsValidators.isStrongPassword('weak'), isFalse);
    expect(FormToolsValidators.isStrongPassword('Strong1!'), isTrue);
    
    // Testing customizable minimum length
    expect(FormToolsValidators.isStrongPassword('S1!', minLength: 3), isTrue);
    expect(FormToolsValidators.isStrongPassword('Strong1!', minLength: 10), isFalse);
    
    // Testing specific requirements
    expect(FormToolsValidators.isStrongPassword('strong1!', requireUppercase: false), isTrue);
    expect(FormToolsValidators.isStrongPassword('STRONG1!', requireLowercase: false), isTrue);
    expect(FormToolsValidators.isStrongPassword('Strong!!', requireDigits: false), isTrue);
    expect(FormToolsValidators.isStrongPassword('Strong11', requireSpecialChar: false), isTrue);
  });
}
