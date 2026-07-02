---
name: flutter-feature-builder
description: Use to create a new Flutter feature following MVVM, Riverpod, go_router, Drift and the project's feature-first structure. Invoke when adding a new screen/flow (e.g. add players, courts screen, history).
---

# Flutter Feature Builder

Creates a new feature respecting the project architecture. Never puts business logic in widgets.

## Steps

1. **Read `CLAUDE.md`** and the relevant files in `.claude/rules/` (flutter-architecture, business-rules, design-system, testing, drift-database).
2. **Identify the feature** and which domain it belongs to (`sessions`, `players`, `courts`, `matches`, `history`) — or create a new domain if needed.
3. **Create the structure** `features/<feature>/{data,domain,presentation}` as needed.
4. **Domain**: create **immutable models/value objects** and, if there is business logic, the corresponding **Service(s)**. Rotation logic always goes in `RotationService`, pure and testable.
5. **Data**: create the **Repository** if persistence is needed, using the Drift DAOs from `core/database`. The UI never accesses Drift directly.
6. **Presentation**: create the **ViewModel/Controller with Riverpod** (screen state + actions), then the **screens/widgets**, which only render state and dispatch actions.
7. **Route**: add the route in **go_router** (`app/router.dart`) if the feature has navigation.
8. **Tests**: create unit tests for Services and ViewModels; follow the required test list in `.claude/rules/testing.md`. Use English test names.
9. **Quality**: run `dart format .`, `flutter analyze` and `flutter test`. Do not finish with errors.

## Checklist

- [ ] No business logic in widgets.
- [ ] Immutable models/value objects.
- [ ] Repository isolates Drift access.
- [ ] Riverpod ViewModel holds screen state.
- [ ] Route added in go_router (if applicable).
- [ ] Tests created and passing.
- [ ] `format` + `analyze` + `test` clean.
