# Architecture

## Overview

The app uses Clean Architecture with a feature-first folder structure.
Each feature owns its `domain`, `data` and `presentation` layers. Shared
infrastructure lives in `lib/core`.

```
lib/
  main.dart                 entry point: DI, licences, runApp
  bootstrap.dart            root widget with app-wide cubits (shared with integration tests)
  app.dart                  MaterialApp.router, theme, l10n, sky background
  injection_container.dart  get_it registrations (composition root)
  core/
    astronomy/    Ephemeris: Sun, Moon, sidereal time, Ascendant (Meeus)
    bloc/         debug BlocObserver
    constants/    provider URL
    error/        AppException (data) → Failure (domain) mapping
    localization/ ARB files, generated AppLocalizations, l10n helpers
    network/      ApiClient (http → typed exceptions)
    router/       go_router config, route constants, bottom-nav shell
    theme/        colours, typography, Material 3 theme
    utils/        Result<T>, clock, moon phase, motion, licences
    widgets/      StarField, CosmicBackground, GlassCard, FadeSlideIn, …
  features/
    horoscope/    readings from the provider + cache
    zodiac/       sign model, characteristics, constellations, pages
    profile/      birth data, natal calculator, places, time zones
    favorites/    saved readings
    today/        dashboard
    splash/       animated intro
```

### Dependency rule

`presentation → domain ← data`. The domain layer has no Flutter, HTTP or
storage imports. Data sources throw `AppException`s, and repositories
turn them into `Failure`s inside a sealed `Result<T>`. Presentation maps
failures to localized messages (`core/localization/failure_l10n.dart`).

| Feature | Domain contracts | Data implementations |
|---|---|---|
| horoscope | `HoroscopeRepository`, `GetHoroscope` | `HoroscopeRepositoryImpl`, `FreeHoroscopeApiDataSource`, `HoroscopeLocalDataSource` |
| profile | `ProfileRepository`, `PlacesRepository`, `TimeZoneResolver`, `NatalCalculator`, `SearchPlaces` | `ProfileRepositoryImpl`, `PlacesRepositoryImpl` (GeoNames asset), `TzTimeZoneResolver` |
| favorites | `FavoritesRepository` | `FavoritesRepositoryImpl` (on-device) |
| zodiac | `ZodiacSign` (static enum, no repository needed) | – |

## State management (flutter_bloc)

| Unit | Type | Why |
|---|---|---|
| `HoroscopeBloc` | BLoC | Period switches and refreshes can overlap. `restartable()` from bloc_concurrency cancels an in-flight load, so a slow old response never overwrites a newer period. |
| `ProfileCubit` | Cubit, app-wide | Simple sequential commands (load/save/clear). Today and Profile both read it. |
| `FavoritesCubit` | Cubit, app-wide | Toggle, remove and restore (undo). Updates the UI optimistically, then re-reads storage. |

App-wide cubits are provided in `bootstrap.dart`. Page-scoped blocs are
created by the page from get_it (`sl<HoroscopeBloc>(param1: sign)`).

## Dependency injection

`get_it` is configured in `injection_container.dart`. Only the
composition root and page-level providers read the locator; every class
receives its dependencies through the constructor, so tests can build it
directly. Singletons are lazy: for example, the full IANA time zone
database is only loaded the first time a chart is calculated.

## Navigation

`go_router` with a `StatefulShellRoute.indexedStack`: four tabs, each
with its own stack.

```
/splash
/today
/signs → /signs/:signId → /signs/:signId/horoscope
/favorites → /favorites/:favoriteId
/profile → /profile/edit
```

Unknown routes and sign ids show `NotFoundPage`. All pages are
transparent over one shared animated sky, so page transitions fade.
A horizontal slide would show two pages overlapping. The trade-off is
that iOS has no edge-swipe back gesture (the back button works).

## Horoscope caching

`HoroscopeRepositoryImpl` keeps the latest reading per sign and period
in `SharedPreferencesAsync`:

1. A cached reading fetched in the current day, week (Monday start) or
   month is returned without a network call, unless the user forces a
   refresh.
2. Otherwise the provider is asked and the result is cached.
3. If the provider fails, the last cached reading is returned with
   `isStale: true` (the UI shows an offline notice). With no cache, a
   `Failure` is returned (the UI shows the error with a retry button).

## Changing the horoscope provider

1. Implement `HoroscopeRemoteDataSource.fetch(sign, period)` and return
   a `Horoscope`. Throw `AppException`s on failure, as `ApiClient` does.
2. Register it in `_initHoroscope` in `injection_container.dart`.
3. If the provider offers other periods or categories, extend
   `HoroscopePeriod`. The period switcher builds from the enum.

Nothing in domain or presentation needs to change. A provider that
needs an API key must sit behind your own backend, with the key kept
server-side.

## Natal calculations

- `core/astronomy/ephemeris.dart` is pure Dart and works offline:
  - Sun: Meeus chapter 25.
  - Moon: Meeus chapter 47, 59 main periodic terms.
  - GMST (chapter 12) and the Ascendant.
  - Tests compare it with Swiss Ephemeris values. Maximum error: Sun
    0.004°, Moon 0.010°, Ascendant 0.025°.
- `NatalCalculator` never presents a guess:
  - With time and place, the birth instant is exact (local time → UTC
    with historical DST via `package:timezone`).
  - Otherwise it scans every possible instant (the local day, or every
    UTC offset when no place is given) and reports each sign a body
    passed through. The result is `AmbiguousPlacement`, shown as
    "Aries or Taurus".
  - The Ascendant needs an exact instant and a latitude below 66°.
    Otherwise it is `UnavailablePlacement`.

## Animations and performance

| Element | Implementation | Cost control |
|---|---|---|
| Star field | `CustomPainter` with 140 pre-generated stars | Timer-driven at about 30 fps instead of every vsync. Paused when the app isn't resumed. Isolated in a `RepaintBoundary`. No widget rebuilds. |
| Glass cards | Semi-transparent gradient | No `BackdropFilter` (blur would re-rasterise over the moving sky). |
| Constellations | Line-by-line drawing, one controller | Runs once. `RepaintBoundary`. |
| Card entrances, glyph glow, skeletons | Short controllers | Disposed with their widgets. |

Every animation checks `MediaQuery.disableAnimations` (iOS "Reduce
Motion", Android "Remove animations") and renders a still state. City
data (about 34k rows) is parsed in a background isolate.

## Localization

`l10n.yaml` points gen_l10n at `lib/core/localization/arb`. UI strings
come only from `context.l10n`, and domain enums are localized through
presentation extensions (e.g. `ZodiacSignL10n`). To add Polish, create
`app_pl.arb` with the same keys. Device locale detection and fallback
are handled by `supportedLocales`.

## Testing strategy

| Level | Location | Examples |
|---|---|---|
| Unit | `test/core`, `test/features/*/data`, `test/features/*/domain` | API payloads recorded from the provider, cache policy, ephemeris vs Swiss Ephemeris vectors, time zones, city search |
| Bloc/Cubit | `test/features/*/presentation/*_bloc_test.dart`, `*_cubit_test.dart` | Out-of-order responses, undo |
| Widget | `test/features/**`, `test/app_test.dart` | Pages in each state, navigation |
| Accessibility | `test/accessibility` | Tap targets, labels, contrast on the sky, 200% text on a 360 dp phone |
| Integration | `integration_test/` | End-to-end flows on iOS and Android, frame timings |

The test helpers in `test/helpers/` turn on reduced motion, because the
endless sky animation would never let `pumpAndSettle` finish, and they
stub the app-wide cubits.
