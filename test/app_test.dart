import 'package:flutter_test/flutter_test.dart';
import 'package:mystic_horoscope/app.dart';

void main() {
  testWidgets('shows localized English greeting', (tester) async {
    await tester.pumpWidget(const MysticApp());
    await tester.pumpAndSettle();

    expect(find.text('The stars are aligning…'), findsOneWidget);
  });
}
