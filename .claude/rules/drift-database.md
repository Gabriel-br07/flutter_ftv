# Rule: Local Database (Drift)

The app is **offline-first**. All main data lives in a local **Drift** database, isolated under `core/database`.

## What to persist

Persist with Drift:

- **Sessions** (name, number of courts, target points: 15 or 18).
- **Players** (with arrival order).
- **Player queue entries**.
- **Pairs** (temporary).
- **Courts** (A, B, C...).
- **Matches** (winner/loser).
- **History events**.

## Rules

- **Use transactions** for rotation-related state changes and any change to queue/courts/matches/players/pairs — the match-finalization sequence must be atomic (see "Consistency Rules" in `CLAUDE.md`).
- **Record a history event** for every relevant state change.
- **Do not use `shared_preferences` for main app data** — it is for trivial UI preferences at most. Domain data lives in Drift.
- **Create migrations whenever the schema changes** — never break an existing database without a migration.
- **Avoid duplicating derived state** unless there is a clear reason; if materialized, keep it consistent within the same transaction.
- **Repositories abstract database access** — the UI never touches Drift directly.

## Access

- DAOs and schema live in `core/database`; feature repositories (`data/`) use those DAOs.
