import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mystic_horoscope/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:mystic_horoscope/features/favorites/presentation/pages/favorite_detail_page.dart';
import 'package:mystic_horoscope/features/favorites/presentation/pages/favorites_page.dart';

import '../../../helpers/pump_app.dart';
import '../../../helpers/sample_data.dart';

void main() {
  final favorite = sampleFavorite(text: 'Saved Leo reading.');

  setUpAll(() => registerFallbackValue(favorite));

  testWidgets('empty list shows a hint', (tester) async {
    await tester.pumpLocalized(const FavoritesPage());
    expect(find.text('No favorites yet'), findsOneWidget);
  });

  testWidgets('lists favorites; swipe removes with undo', (tester) async {
    final cubit = favoritesCubitWith(
      FavoritesState(items: [favorite], loaded: true),
    );
    when(() => cubit.remove(any())).thenAnswer((_) async {});
    when(() => cubit.restore(any())).thenAnswer((_) async {});

    await tester.pumpLocalized(const FavoritesPage(), favorites: cubit);
    expect(find.text('Leo'), findsOneWidget);
    expect(find.text('WEDNESDAY, NOVEMBER 25'), findsNothing);
    expect(find.text('Wednesday, November 25'), findsOneWidget);
    expect(find.text('Saved Leo reading.'), findsOneWidget);

    await tester.drag(find.text('Leo'), const Offset(-600, 0));
    await tester.pumpAndSettle();
    verify(() => cubit.remove(favorite.id)).called(1);

    await tester.tap(find.text('Undo'));
    verify(() => cubit.restore(favorite)).called(1);
  });

  testWidgets('detail shows the saved text and date', (tester) async {
    await tester.pumpLocalized(
      FavoriteDetailPage(favoriteId: favorite.id),
      favorites: favoritesCubitWith(
        FavoritesState(items: [favorite], loaded: true),
      ),
    );
    expect(find.text('Saved Leo reading.'), findsOneWidget);
    expect(find.text('Saved on Nov 25, 2026'), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });

  testWidgets('detail of an unknown id explains it is gone', (tester) async {
    await tester.pumpLocalized(
      const FavoriteDetailPage(favoriteId: 'leo-daily-19990101'),
    );
    expect(find.text('This favorite no longer exists.'), findsOneWidget);
  });
}
