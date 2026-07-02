# CLAUDE.md

## Project

This is a Flutter app for managing casual **futevôlei** (beach footvolley) sessions ("peladas").

There is a single main user: the **organizer**, who controls the whole session from one Android device during the game. The organizer creates a session, adds players by arrival order, forms pairs, controls courts and records winner/loser of each match.

The app is optimized for **fast use during a live sports session**, **offline-first/local** operation, **Android first**, and **APK distribution**. The most sensitive part of the product is the **rotation engine** (queue → pairs → courts ladder), which must be correct and heavily tested.

## Language Rules

Use **English** for everything technical:

- source code, file names, folder names;
- classes, methods, variables;
- technical comments;
- tests;
- technical documentation;
- Claude rules and skills (this file, `.claude/rules/*`, `.claude/skills/*`).

Use **Brazilian Portuguese only for user-facing app text** (labels, buttons, messages shown to the organizer). Do not translate code identifiers to Portuguese.

Examples of future user-facing text (Portuguese): "Peladas", "Criar pelada", "Nome da pelada", "Quantidade de quadras", "Jogo até 15 pontos", "Jogo até 18 pontos", "Adicionar jogador", "Formar duplas", "Quadra A", "Dupla 1 venceu", "Dupla 2 venceu", "Ambas saíram", "Vencedora cansou", "Fila de espera", "Histórico", "Desfazer última ação".

## Stack

- Flutter + Dart.
- **Android first**.
- **Riverpod** for state management.
- **go_router** for navigation.
- **Drift** for the local database.
- **Material 3** for UI.
- **MVVM-style** architecture with **Repository** and **Services**.
- Offline-first / local data.
- **APK release** distribution.

## MVP Scope

In scope for the MVP:

- Single organizer operating one Android device.
- Local, offline session management.
- Winner/loser recording (no point-by-point scoring).
- Rotation engine (queue, pairs, courts ladder).
- History/event log and undo of the last action.
- APK release build.

Not a Flutter project yet: there is currently **no `pubspec.yaml`**. Project initialization (`flutter create`, adding stack dependencies) is a **separate future step**, not part of this instruction-setup prompt and not part of the core-engine prompt unless a minimal Drift schema is required.

## Architecture

Layered MVVM with Repository and Services. Dependency direction: `UI → ViewModel → Service → Repository → Database`.

- **UI (widgets/screens)** — render state and dispatch actions only.
- **ViewModel/Controller** — expose screen state and coordinate actions (Riverpod).
- **Service** — contains business rules.
- **Repository** — accesses data.
- **Database** — Drift, isolated under `core/database`.

Mandatory architecture instructions:

- **Do not put business logic in widgets.** Widgets render state and dispatch actions to the ViewModel.
- **Isolate the rotation engine in a dedicated `RotationService`.**
- **`RotationService` must be testable without Flutter UI and without a direct database dependency** — it takes input state and returns the next state (pure domain logic; no `BuildContext`, no Drift).
- **Use transactions for every state-changing operation** involving queue, courts, matches, players or pairs. Persistence of a rotation result must be atomic.
- Prefer immutable models/value objects. Avoid giant classes. Keep domain logic testable without the database.

## Suggested Folder Structure

Feature-first:

```
lib/
  main.dart
  app/
    app.dart
    router.dart
  core/
    database/
    theme/
    errors/
    utils/
  features/
    sessions/
      data/
      domain/
      presentation/
    players/
      data/
      domain/
      presentation/
    courts/
      data/
      domain/
      presentation/
    matches/
      data/
      domain/
      presentation/
    history/
      data/
      domain/
      presentation/
```

- `data/` — repositories and data sources (Drift DAOs, mappers).
- `domain/` — immutable models/value objects and services (business rules).
- `presentation/` — ViewModels/Controllers, screens and widgets.

`RotationService`, `PairingService` and `QueueService` live in the domain layer, free of Flutter and Drift dependencies.

## Business Rules

1. The organizer creates a casual futevôlei session.
2. The organizer provides: **session name**, **number of courts**, and **target points: 15 or 18**.
3. The app does **not** track point-by-point scoring in the MVP.
4. The app records only **winner/loser** per match.
5. **Target points can only be 15 or 18** — any other value is invalid.

## Player Rules

- Players are added by **arrival order**.
- The **main queue is an individual player queue** and is the source of truth for who is available.
- If there is an **odd number of players**, the leftover player **waits** for the next available player.
- A **loser does not leave the session automatically**.
- A player leaves the session **only when the organizer manually removes** that player; manual removal removes only that player.

## Pair Rules

- Pairs are **temporary**.
- By default, pairs are formed by queue order: **1st + 2nd, 3rd + 4th, 5th + 6th**, and so on.
- If two players **manually choose** to play together, that pair goes to the **end of the pair queue** as the cost of choosing the partner.
- A **manually chosen pair lasts only for that cycle**.
- When a pair **loses, gets tired, or leaves the court**, the pair is **dissolved** and its players return **individually** to the end of the player queue.

## Court Rotation Rules

- Courts are named **A, B, C, D...**; **Court A is the main court**.
- The **winner on Court A stays on Court A**.
- The **winner on Court B waits for Court A to finish**, then plays against **Court A's winner**.
- The **winner on Court C waits for Court B to finish**, then **moves up to Court B**.
- The same **ladder rule** applies to D, E, F and so on (a lower court's winner moves up to the court immediately above once it frees up).
- **Losers return individually** to the end of the player queue.
- If the **winning pair gets tired**, both players return **individually** to the end of the player queue.
- The organizer can mark that **both pairs left/got tired** at once; all four players return individually to the queue.
- **Empty courts are filled from the available player queue.**

## Consistency Rules

Every action that changes queue, courts, matches, players or pairs must be **transactional** — all-or-nothing; no inconsistent intermediate state may be persisted.

When a match is finalized, run this sequence inside a single transaction:

1. Record winner/loser.
2. Dissolve the losing pair.
3. Return the losing players **individually** to the end of the queue.
4. Update the winner's status.
5. Apply court promotion/challenge (A stays, B challenges A, C moves up to B, ladder for lower courts).
6. Form new pairs from available players.
7. Fill empty courts.
8. Record the **history event**.

Invariants (must always hold):

- **No player can be in two active places at the same time** (not in two courts, not in a court and the queue simultaneously).
- **No dissolved pair can remain on a court.**
- **No player can appear in two active pairs.**

## UI/UX Rules

- Use **Material 3**.
- Design for **outdoor, fast-use** sports context (operable in a few taps, readable in sunlight).
- **Large buttons** for primary actions.
- **Clear court cards** (per court: current pair and status).
- **Queue always visible.**
- **Main actions must not be hidden** in overflow menus.
- **User-facing text in Portuguese.**
- **Confirmation dialogs for destructive actions** (remove player, end session).
- **Snackbar/feedback** for important actions (e.g. winner recorded).
- **Undo the last action** when possible.
- The **courts screen is the main operational screen**.
- Avoid login, long onboarding or complex forms in the MVP.

## Required MVP Screens

- Sessions list.
- Create session.
- Add players.
- Courts screen (main screen).
- Waiting queue.
- Simple history.

## Database Rules

- Use **Drift** as the local database.
- Persist: **sessions, players, player queue entries, pairs, courts, matches, history events**.
- Use **transactions** for rotation-related state changes.
- Record a **history event** for relevant state changes.
- **Do not use `shared_preferences` for main app data** (only trivial UI preferences).
- **Create migrations** when the schema changes.
- Avoid duplicating derived state unless there is a clear reason.
- Repositories abstract database access; the UI never touches Drift directly.

## Testing Rules

- **Every rotation rule needs unit tests.**
- Prioritize `RotationService`, `PairingService`, `QueueService`, repositories and ViewModels.
- Test **happy path and edge cases**; cover the invariants (no duplicated active player).
- Use **English test names**.
- `RotationService` tests must run **without Flutter UI and without a database**.

Run before finishing any task:

```bash
dart format .
flutter analyze
flutter test
```

## Quality Commands

```bash
flutter pub get
dart format .
flutter analyze
flutter test
```

Do not finish with static-analysis errors or failing tests.

## Code Quality Rules

- **Always run `dart format .`** before finishing any task.
- **Always run `flutter analyze`** before finishing any task.
- **Always run `flutter test`** before finishing any task.
- **Never finish with analyzer errors.**
- **Do not ignore lints without a documented reason** — no bare `// ignore` /
  `// ignore_for_file`; add a short comment explaining why when suppression is unavoidable.
- **Keep business logic out of widgets** — widgets only render state and dispatch actions.
- **Do not duplicate rotation logic** — it lives only in `RotationService`.
- **Do not access Drift directly from the UI** — always go through a Repository.

Static analysis is configured in `analysis_options.yaml` (strict analyzer modes plus a curated lint
set). `custom_lint`/`riverpod_lint` rules are surfaced by `dart run custom_lint` (and the IDE), not
by `flutter analyze`.

## MVP Prohibitions

Do not implement in the MVP:

- Login / authentication.
- Backend.
- Firebase.
- Cloud sync.
- Online ranking.
- Chat.
- Push notifications.
- Payments.
- Public profiles.
- Play Store setup/publishing.
- iOS-specific work.

Only add these if the scope is **explicitly changed**.

## Next Implementation Steps

The next prompt should implement **only** the core business engine — **no UI**:

- domain models / value objects;
- `PairingService`;
- `QueueService`;
- `RotationService`;
- unit tests for the business rules (see `.claude/rules/testing.md`);
- an **initial Drift schema only if needed** for the core engine.

Do not build the full UI in the next prompt. Full Flutter project initialization (`flutter create`, wiring Riverpod/go_router/Material 3, dependencies) is a separate step.
