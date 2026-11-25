import 'package:flutter_test/flutter_test.dart';
import 'package:mystic_horoscope/core/localization/generated/app_localizations_en.dart';
import 'package:mystic_horoscope/features/zodiac/domain/entities/zodiac_sign.dart';
import 'package:mystic_horoscope/features/zodiac/presentation/pages/sign_detail_page.dart';
import 'package:mystic_horoscope/features/zodiac/presentation/zodiac_l10n.dart';

import '../../../helpers/pump_app.dart';

void main() {
  test('every sign has distinct, non-empty localized content', () {
    final l10n = AppLocalizationsEn();
    final descriptions = ZodiacSign.values.map(
      (s) => s.localizedDescription(l10n),
    );
    final keywords = ZodiacSign.values.map((s) => s.localizedKeywords(l10n));
    expect(descriptions.toSet(), hasLength(12));
    expect(keywords.toSet(), hasLength(12));
    expect(descriptions.every((d) => d.length > 80), isTrue);
  });

  testWidgets('detail page shows attributes and personality', (tester) async {
    await tester.pumpLocalized(const SignDetailPage(sign: ZodiacSign.pisces));
    expect(find.text('Pisces'), findsOneWidget);
    expect(find.text('Water'), findsOneWidget);
    expect(find.text('Neptune'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Personality'), 200);
    expect(find.text('Personality'), findsOneWidget);
    expect(find.text('Imaginative · Compassionate · Dreamy'), findsOneWidget);
  });
}
