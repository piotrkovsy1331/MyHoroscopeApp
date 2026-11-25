# Data sources and licences

## Horoscopes: FreeHoroscopeAPI

Chosen in stage 1 (option B). Verified live on 2026-11-25.

| Property | Value |
|---|---|
| Endpoints used | `GET https://freehoroscopeapi.com/api/v1/get-horoscope/{daily,weekly,monthly}?sign=<sign>` |
| Response | `{"data":{"date":"2026-11-25","period":"daily","sign":"Leo","horoscope":"…"}}`. `date` is the day, the week start, or `YYYY-MM` for monthly. |
| Signs | all 12 (`aries` … `pisces`) |
| Languages | English only. A `lang` parameter is ignored. |
| Yearly / topical readings | Not available (`/yearly` returns 404), so not shown in the app. |
| Key / cost | None / free |
| Rate limits | Not documented. The app caches per period to keep traffic low. |
| Terms | Commercial and non-commercial use allowed **with a visible "Powered by FreeHoroscopeAPI" link** to https://freehoroscopeapi.com. Shown under every reading and on saved favorites. |
| Not covered by the terms | Caching, redistribution, translation, SLA, operator identity, origin of the texts. Ask admin@freehoroscopeapi.com before any wider commercial launch. |

Recorded responses are in `test/fixtures/`.

### Options considered

| Option | Result |
|---|---|
| Own backend + AI-written readings based on real planetary positions | Rejected for now: needs Firebase Blaze (paid) for Cloud Functions. Would enable Polish, yearly and topical readings. |
| APIVerve | Needs an API key (would require a backend). |
| sumitgohil/horoscope-api | Appears unmaintained. |
| DivineAPI, RoxyAPI, Vedika, AstrologyAPI, Prokerala | Paid or trial. Not tested, so no claims are made about them. |

## Natal calculations

Computed on the device (see [ARCHITECTURE.md](ARCHITECTURE.md#natal-calculations)).
No external service is used. Swiss Ephemeris (`pyswisseph`) was only
used outside the repository to produce test reference values. It is not
part of the app.

## Cities: GeoNames

| Property | Value |
|---|---|
| Source | https://download.geonames.org/export/dump/: `cities15000`, `admin1CodesASCII`, `countryInfo` (downloaded 2026-11-25) |
| Licence | CC BY 4.0. Commercial use allowed with attribution. |
| Attribution | "Place data © GeoNames (CC BY 4.0)" in the birthplace form, plus the full notice on the licence page (`assets/licenses/GeoNames-CC-BY-4.0.txt`). |
| Content | 34,246 places with population > 15,000 or capitals: name, ASCII name, country, region, coordinates, IANA time zone, population |
| Size | 1.85 MB (about 0.87 MB compressed in the app package) |
| Known gap | Only primary and ASCII names, so "Warszawa" is not found (use "Warsaw"). |

Open-Meteo Geocoding was rejected: its free tier is non-commercial only,
and it is online-only and rate-limited.

### Updating the city database

1. Download the three files above into an **empty** directory and unzip
   `cities15000.zip`.
2. Run `python3 -I tool/build_cities.py <that-directory> assets/data/cities.tsv`.
3. Run `flutter test test/features/profile/data/places_local_data_source_test.dart`.
   It also checks that every time zone exists in the bundled IANA
   database.
4. Update the download date in `assets/licenses/GeoNames-CC-BY-4.0.txt`.

## Time zones

`package:timezone` (BSD-2) with the full IANA history (`latest_all`), so
past daylight-saving rules are applied (e.g. Warsaw 1990 = UTC+2 in
summer).

## Fonts

| Font | Use | Licence |
|---|---|---|
| Cinzel 500/700 | Headings | SIL OFL 1.1 |
| Inter 400/500/600 | Body | SIL OFL 1.1 |
| Noto Sans Symbols (12-glyph subset, 3.5 KB) | Zodiac glyphs, so iOS doesn't show emoji | SIL OFL 1.1 |

The fonts are bundled, not downloaded at runtime, and their licences are
on the licence page.

## Sign characteristics

The personality portraits and keywords are original content written for
this app (`lib/core/localization/arb/app_en.arb`).

## Privacy

Birth data, favorites and cached readings never leave the device. The
only network traffic is the horoscope request (sign and period).
