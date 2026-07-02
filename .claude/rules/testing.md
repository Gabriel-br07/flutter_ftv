# Rule: Testing

The rotation engine is the core of the app and the part most sensitive to bugs. It must be strongly covered by tests.

## Principles

- **Every rotation rule needs unit tests.**
- Prioritize tests for **`RotationService`, `PairingService`, `QueueService`, repositories and ViewModels**.
- Test the **happy path and edge cases** (empty queue, one player, odd count, all courts occupied, both pairs leaving).
- **Cover invariants**, especially: no duplicated active player.
- Use **English test names**.
- `RotationService` tests must run **without Flutter UI and without a database** — pure, fast, deterministic Dart tests.

## Required tests

- `automatic pairing by arrival order`;
- `odd number of players leaves one player waiting`;
- `manual pair goes to the end`;
- `manual pair is dissolved after losing`;
- `losing pair players return individually to the end of the queue`;
- `Court A winner stays on Court A`;
- `Court B winner waits for Court A`;
- `Court B winner challenges Court A winner after Court A finishes`;
- `Court C winner moves up to Court B after Court B finishes`;
- `tired winning pair returns individually to the queue`;
- `both pairs leaving returns all four players individually to the queue`;
- `manually removing a player removes only that player`;
- `no player can be simultaneously queued and playing`;
- `no player can appear in two active pairs`;
- `empty courts are filled from the available queue`;
- `target points can only be 15 or 18`.

## Commands

Run before considering a task done:

```bash
dart format .
flutter analyze
flutter test
```

Do not finish with failing tests or static-analysis errors.
