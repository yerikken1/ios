import 'package:flutter_test/flutter_test.dart';
import 'package:my_applab6/main.dart';

void main() {
  testWidgets('shows validation errors on empty submit', (tester) async {
    await tester.pumpWidget(const RegistrationApp());

    await tester.tap(find.text('Register'));
    await tester.pump();

    expect(find.text('Full name is required'), findsOneWidget);
  });
}