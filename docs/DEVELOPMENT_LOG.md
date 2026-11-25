# Development log

All work was done in stages. Each stage was reviewed with the product
owner before the next one started. Every commit passed `dart format`,
`flutter analyze` (no issues) and the test suite.

## Stage 1: analysis and planning (no commits)

- The repository was empty and had no git history. Environment: Flutter
  3.47.7, Dart 3.13.5, Xcode 27.2, Android SDK 36.
- Horoscope sources were tested live. Decisions:
  - FreeHoroscopeAPI, English only.
  - No Firebase Blaze plan, so no backend.
  - Notifications and the final app id postponed.

## Stage 2: foundations

| Commit | Summary |
|---|---|
| `3faff8f` chore: initial Flutter project setup | Empty iOS/Android app, `.gitignore` for secrets and keystores |
| `48acdfe` feat: implement localization | gen_l10n with English ARB and fallback for other locales; core dependencies |
| `b396efd` chore: configure project architecture | Exceptions → failures, `Result<T>`, `ApiClient`, get_it, go_router, dark theme, BlocObserver |

## Stage 3: user interface

| Commit | Summary |
|---|---|
| `837cf65` feat: add animated UI components | Bundled fonts, star field, glass cards, entrance animation, Moon phase, constellation drawing, reduced-motion support |
| `11799bb` feat: add zodiac sign domain model | 12 signs with attributes and date ranges |
| `3818948` feat: implement app shell, navigation and core screens | Splash, bottom navigation, Today, Signs, detail, horoscope shell, native splash colours |

## Stage 4: astrological features

| Commit | Summary |
|---|---|
| `b54fc6c` feat: implement horoscope module | Live FreeHoroscopeAPI integration, cache policy, `HoroscopeBloc` with `restartable()`, attribution |
| `ef2d3a4` feat: add zodiac sign characteristics | Original personality texts |
| `85851e5` feat: add astronomical calculations | Meeus Sun/Moon/Ascendant, checked against Swiss Ephemeris |
| `6ef6d2b` feat: add natal calculator and offline birthplace search | Honest ambiguity handling, GeoNames cities, historical time zones |
| `3f3031a` feat: implement user profile | Profile page, birth form, personal Today card |

## Stage 5: users (partial)

| Commit | Summary |
|---|---|
| `5d8bb7f` feat: implement local favorites | Snapshot favorites, swipe to delete with undo, heart toggle |

Login and sync are postponed (see README).

## Stage 6: notifications

Postponed by decision.

## Stage 7: testing and optimization

| Commit | Summary |
|---|---|
| `bac15cb` fix(android): add INTERNET permission for release builds | Release builds could not reach the API. Verified on an Android 17 emulator |
| `d5bd040` fix: keep the Read horoscope action above the fold | Found by an integration test on a real iPhone screen size |
| `adecb6a` test: add integration tests for key flows | 4 flows, passing on iOS simulator and Android emulator |
| `bc1a69d` fix: scale sign tiles with accessibility text size | Plus tap target, label, contrast and 200% text tests |
| `db46d23` perf: cap the star field at 30 fps and pause it in background | Less GPU and battery use on high-refresh screens |
| `a07ff31` test: add frame timing performance test | Profile-mode frame timings with a static-sky baseline |

## Stage 8: documentation

README, architecture, data sources and licences, this log.

## Open items

- Final app id, release signing and store assets.
- Firebase Auth and Firestore sync for profile and favorites (Spark
  plan); Sign in with Apple needs a paid developer account.
- Local daily notifications.
- Frame timings on a physical device.
- Polish UI (`app_pl.arb`), alternate city names (e.g. "Warszawa").
- iOS edge-swipe back gesture (currently fade transitions only).
