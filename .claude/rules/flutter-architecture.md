# Rule: Flutter Architecture

These rules apply to all Flutter/Dart code in this project. See also `CLAUDE.md`.

## Layers (MVVM with Repository and Services)

Dependency direction: `UI → ViewModel → Service → Repository → Database`.

- **UI (widgets/screens)** — render state and dispatch actions only.
- **ViewModel/Controller** — expose screen state and coordinate actions (Riverpod). Do not access Drift directly.
- **Service** — contains business rules. Single responsibility per service (rotation, pairing, queue).
- **Repository** — accesses data; the boundary between domain and Drift.
- **Database** — Drift, isolated under `core/database`.

## Mandatory rules

- **Do not put business logic in widgets.** No rotation, pairing, court-ladder or validation decisions inside `build()`.
- **Widgets render state and dispatch actions only** — they receive state from the ViewModel and call ViewModel methods.
- **ViewModels/Controllers expose screen state and coordinate actions.**
- **Services contain business rules** — the only place rotation/pairing/queue rules live.
- **Repositories access data.**
- **Drift is isolated under `core/database`** (schema, DAOs, connection).
- **UI must not access Drift directly** — always go through a Repository.

## RotationService

- **`RotationService` must be pure and testable, independent from Flutter UI** — it takes input state and returns the next state, with no dependency on Flutter, `BuildContext`, Riverpod or Drift.
- Persisting a `RotationService` result is the Repository/ViewModel's responsibility, inside a transaction.

## Good practices

- **Prefer immutable models/value objects** where practical (e.g. `copyWith`); do not mutate domain state in place.
- **Avoid giant classes** — split responsibilities.
- **Use a feature-first structure** (`sessions`, `players`, `courts`, `matches`, `history`), each with `data/`, `domain/`, `presentation/`.
- **Keep domain logic testable without the database** when possible.
