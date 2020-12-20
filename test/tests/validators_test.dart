import 'package:inquirescape/pages/Validators.dart';
import 'package:test/test.dart';

void main() {
  test('Empty Email Test', () {
    var result = Validators.validateEmail('');
    expect(result, false);
  });

  test('Invalid Email Test', () {
    var result = Validators.validateEmail('user.user@email.com');
    expect(result, false);
  });

  test('Valid Email Test', () {
    var result = Validators.validateEmail('user@email.com');
    expect(result, true);
  });
}
