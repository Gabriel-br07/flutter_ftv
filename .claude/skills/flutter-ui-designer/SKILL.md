---
name: flutter-ui-designer
description: Use to create or review Flutter UI with Material 3, optimized for fast use during a live sports session. Invoke when building the courts screen, queue, add-players screen, or reviewing UX.
---

# Flutter UI Designer

Creates and reviews Flutter UI with **Material 3**, designed for **fast use in an outdoor sports context**. Widgets only render state and dispatch actions — no business logic.

## Design priorities

- **User-facing text in Portuguese** (code identifiers stay English).
- **Large buttons** for primary actions.
- **Clear court cards** (A, B, C...) with the current pair and status.
- **Visible queue** — the waiting queue always at hand.
- **Visible main actions** — never hide important actions in menus.
- **Status chips/badges** — court occupied/free, waiting, winner recorded.
- **Confirmation dialogs for destructive actions** (remove player, end session).
- **Snackbar feedback** for important actions.
- **Undo the last action** when possible.
- **The courts screen is the main operational screen.**
- **No login/onboarding complexity in the MVP** — no long forms or multi-step flows.

## How to work

1. Read `CLAUDE.md` and `.claude/rules/design-system.md`.
2. Consume state from the ViewModel (Riverpod); do not put business logic in `build()`.
3. Prefer standard Material 3 components; ensure large touch targets and good contrast (readable in sunlight).
4. Validate the experience: can a match be operated in a few taps?
5. Run `dart format .` and `flutter analyze`.
