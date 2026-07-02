# flutter_ftv — Pelada de Futevôlei

Offline-first Flutter app for managing casual **futevôlei** (beach footvolley)
sessions ("peladas"). A single **organizer** runs the whole session from one
Android device: creates a session, adds players by arrival order, forms pairs,
and records winner/loser of each match while the app applies the court-ladder
rotation.

> User-facing text is in **Brazilian Portuguese**; all code, file names and
> documentation are in **English**.

---

## Features (MVP)

- Create a session: name, number of courts, target points (15 or 18).
- Add players by arrival order; remove players manually.
- Form pairs automatically (by arrival order) or choose a manual pair.
- Courts screen (main operational screen): record `Dupla 1 venceu`,
  `Dupla 2 venceu`, `Vencedora cansou`, `Ambas saíram`.
- Court-ladder rotation: winner stays / challenger rises from the court below,
  losers return individually to the end of the queue.
- Waiting queue always visible, plus pairs waiting for the upper court.
- History log and **undo of the last action**.
- Everything stored **locally** (no login, no backend, no cloud).

---

## Tech stack

- **Flutter + Dart** (Android first)
- **Riverpod 3** — state management / dependency injection
- **go_router** — navigation
- **Drift** (+ `drift_flutter`) — local database
- **Material 3** — UI
- MVVM-style architecture with **Services** + **Repositories**

Requires **Flutter 3.44+ / Dart 3.12+**. Check yours with `flutter --version`.

---

## Getting started

### 1. Install dependencies

```bash
flutter pub get
```

### 2. Generate the database code (Drift)

The Drift tables use code generation. Run this after a fresh clone and whenever
you change `lib/core/database/app_database.dart`:

```bash
dart run build_runner build --delete-conflicting-outputs
```

> The generated file `lib/core/database/app_database.g.dart` is required to
> compile. If you see errors about `_$AppDatabase` or missing companions, re-run
> the command above.

### 3. Run the app

```bash
flutter run
```

Pick an Android emulator or a connected device.

#### ⚠️ Windows: enable Developer Mode

On Windows, building/running an app that uses plugins (this app bundles the
native SQLite libraries) needs **Developer Mode** for symlink support. If
`flutter run` complains, open the setting and toggle it on:

```bash
start ms-settings:developers
```

Then reconnect your device / restart the emulator. This is **not** needed for
running tests or static analysis.

---

## Quality checks

Run these before committing (they must all pass):

```bash
dart format .
flutter analyze          # must report 0 issues
flutter test             # unit + widget tests
dart run custom_lint     # riverpod_lint / custom_lint rules
```

`flutter analyze` uses the strict rules in `analysis_options.yaml`.
`custom_lint`/`riverpod_lint` rules are **not** surfaced by `flutter analyze` —
always run `dart run custom_lint` as well.

---

## E2E / Integration Tests

End-to-end tests use Flutter's official
[`integration_test`](https://docs.flutter.dev/testing/integration-tests) package.
They launch the **real** app (screens, `go_router`, controllers, repositories and
the Drift-backed rotation engine) and drive it the way an organizer would.

**What they cover** (`integration_test/app_e2e_test.dart`):

- `should_create_session_and_add_players` — create a session, add 8 players in
  arrival order, form pairs, start the round, land on the courts screen.
- `should_show_waiting_player_when_player_count_is_odd` — with 5 players the odd
  one shows **"Jogador aguardando dupla"**.
- `should_send_manual_pair_to_end_of_queue` — a manually chosen pair goes to the
  end of the queue and does not take the main court.
- `should_register_match_winner_and_create_history_event` — record a winner on
  Court A, then verify a history event appears.

**Where things live:**

```
integration_test/
  app_e2e_test.dart          # the E2E tests + helpers
  support/test_database.dart # in-memory DB override (isolation), web-safe
test_driver/
  integration_test.dart      # driver entrypoint for `flutter drive` (web)
```

**Test isolation.** On native platforms (Android / desktop) each test runs
against a fresh in-memory SQLite database, so tests never see each other's data.
On web there is no in-memory executor, so the app's real database is used and
tests stay isolated by creating **uniquely named sessions** per run. No
production "clear database" button is ever added.

> The E2E suite drives real widgets by stable `Key`s (`sessionsCreateButton`,
> `playerNameField`, `courtACard`, `courtAWinnerPairOneButton`, `queueSection`,
> `historyScreen`, …). Prefer `find.byKey` over long text when adding assertions.

### Run on a connected Android device / emulator (recommended)

The app targets Android, so an emulator or physical device is the most faithful
way to run the E2E suite.

```powershell
flutter devices
flutter test integration_test/app_e2e_test.dart -d <device-id>
```

Example:

```powershell
flutter test integration_test/app_e2e_test.dart -d emulator-5554
```

Bash is identical:

```bash
flutter devices
flutter test integration_test/app_e2e_test.dart -d emulator-5554
```

### Run with a visible Chrome browser (headed)

Web execution goes through `flutter drive`, which needs **ChromeDriver** running.
Start it in one terminal:

```powershell
chromedriver --port=4444
```

Then, in another terminal (PowerShell uses backticks for line continuation):

```powershell
flutter drive `
  --driver=test_driver/integration_test.dart `
  --target=integration_test/app_e2e_test.dart `
  -d chrome
```

Bash:

```bash
chromedriver --port=4444
```

```bash
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/app_e2e_test.dart \
  -d chrome
```

### Run with a visible Edge browser (headed)

```powershell
chromedriver --port=4444
```

```powershell
flutter drive `
  --driver=test_driver/integration_test.dart `
  --target=integration_test/app_e2e_test.dart `
  -d edge
```

Bash:

```bash
chromedriver --port=4444
```

```bash
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/app_e2e_test.dart \
  -d edge
```

### Run in web headless mode

Headless web uses the `web-server` device (no browser window opens):

```powershell
flutter drive `
  --driver=test_driver/integration_test.dart `
  --target=integration_test/app_e2e_test.dart `
  -d web-server
```

Bash:

```bash
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/app_e2e_test.dart \
  -d web-server
```

> **Notes**
> - For web **headed** mode, keep `chromedriver --port=4444` running in a
>   separate terminal.
> - For **headless** web mode, use `-d web-server`.
> - For Android, prefer running on an emulator or physical device because the
>   app target is Android/APK.
> - Running the E2E suite **on web** requires the Drift web assets
>   (`sqlite3.wasm` + the drift worker) to be present under `web/`; if the app
>   itself runs on web, the tests will too.

### Full quality checks (including E2E)

```powershell
dart format .
flutter analyze
flutter test
flutter test integration_test
```

Bash is identical (swap `.` line continuations as needed). `flutter test
integration_test` needs a target device (`-d <id>`); see the sections above.

### Troubleshooting

1. **No devices found** — run `flutter devices`; start an emulator
   (`flutter emulators --launch <id>`); or connect an Android device with USB
   debugging enabled.
2. **`More than one device connected`** — pass `-d <device-id>` explicitly
   (e.g. `-d emulator-5554`, `-d chrome`).
3. **ChromeDriver not found** — install ChromeDriver matching your Chrome
   version, put it on `PATH`, and verify with `chromedriver --version`. It must
   be running (`chromedriver --port=4444`) before `flutter drive` on web.
4. **Windows: "Building with plugins requires symlink support"** — enable
   **Developer Mode** (`start ms-settings:developers`), then retry. This is
   required to build the app (it bundles native SQLite) on Windows desktop.
5. **Test cannot find a widget** — prefer `find.byKey`; verify the key exists in
   the widget; don't rely only on long/brittle text.
6. **Local database keeps previous data** — the suite already isolates via an
   in-memory DB (native) and unique session names; if you added a test, keep
   session names unique and avoid asserting on global session counts.
7. **Web lifecycle / debug channel warnings** — treat these as noise; they are
   not failures unless a test actually fails or the app does not load.

---

## Building a release APK (Android)

```bash
flutter build apk --release
```

The APK is written to `build/app/outputs/flutter-apk/app-release.apk`.
There is no Play Store setup and no signing config committed to the repo
(keystores / `key.properties` must stay out of version control).

---

## Project structure

Feature-first, with a clear dependency direction
`UI → ViewModel/Controller → Service → Repository → Database`.

```
lib/
  main.dart                     # ProviderScope + app entry
  app/
    app.dart                    # MaterialApp.router (Material 3, PT title)
    router.dart                 # go_router routes
    providers.dart              # DI: database, repositories, engine, session list
  core/
    database/                   # Drift schema (app_database.dart) + mappers
    domain/                     # shared value types (ids, Result)
    engine/                     # SessionEngine: orchestrates the domain services
    theme/                      # Material 3 theme
    utils/                      # IdGenerator, Portuguese labels/formatters
  features/
    sessions/  { data, domain, presentation }
    players/   { domain, presentation }
    pairs/     { domain, services }        # PairingService
    courts/    { domain, presentation }
    matches/   { domain, services, data }  # RotationService, RotationState, repo
    history/   { domain, presentation }

test/
  features/…                    # engine + controller tests
  widget/                       # widget tests
  support/                      # fixtures + in-memory fakes
integration_test/               # E2E tests (integration_test package)
test_driver/                    # driver entrypoint for `flutter drive` (web)
```

### Architecture rules (please follow when changing code)

- **No business logic in widgets.** Widgets render state and dispatch actions.
- **Rotation logic lives only in `RotationService`** (pure Dart, no Flutter/DB).
  Don't duplicate it in the UI. `SessionEngine` (in `core/engine`) coordinates
  the services and returns a new `RotationState`.
- **UI never touches Drift directly** — always go through a repository
  (`SessionsRepository`, `SessionStateRepository`).
- Prefer **immutable models** with `copyWith`. Keep domain logic testable
  without the database.
- The rotation engine is the most sensitive part of the app and **must stay
  covered by tests** — see `test/features/matches/`.

---

## How the pieces fit together

1. **Domain** (`features/*/domain`) — immutable models + enums.
2. **Services** (`RotationService`, `PairingService`) — pure business rules
   operating on domain objects / `RotationState`.
3. **`SessionEngine`** (`core/engine`) — applies one logical action (add player,
   form pairs, finish match, start round…) by delegating to the services.
4. **Repositories** (`features/*/data`) — load/save state via Drift, in
   transactions. Ids are generated by `IdGenerator` (injected into the engine).
5. **Controllers** (`Notifier`s in `presentation/`) — hold UI state, call the
   engine + repositories, expose Portuguese messages.
6. **Screens/widgets** — render controller state and dispatch actions.

---

## Contributing / making changes

1. Create a branch and make your change following the architecture rules above.
2. If you touch a business rule, **update or add tests** (English test names).
3. If you change the Drift schema, re-run `build_runner` and add a **migration**
   (bump `schemaVersion` in `app_database.dart`).
4. Keep user-facing strings in **Brazilian Portuguese** (see `core/utils/labels.dart`);
   keep code/identifiers in English.
5. Run the full quality checklist (`format`, `analyze`, `test`, `custom_lint`)
   and make sure everything is green.

### Out of scope (MVP)

No login/authentication, backend, Firebase/Supabase, cloud sync, online ranking,
chat, push notifications, payments, Play Store publishing, point-by-point
scoring, or iOS-specific work. Add these only if the scope is explicitly changed.
