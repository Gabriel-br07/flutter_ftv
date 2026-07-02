---
name: drift-schema-designer
description: Use to create or alter the Drift schema (tables, DAOs, migrations, queries). Invoke when adding or changing entities like sessions, players, queue entries, pairs, courts, matches or events.
---

# Drift Schema Designer

Creates and alters the local schema in **Drift**, preserving integrity across entities. Everything is isolated under `core/database`; the UI never accesses Drift directly.

## Instructions

1. Read `CLAUDE.md` and `.claude/rules/drift-database.md`.
2. **Use Drift** for all main data — never `shared_preferences` as main storage.
3. **Preserve integrity** among **sessions, players, queue entries, pairs, courts, matches and events** (foreign keys, consistent relations).
4. **Create migrations** whenever the schema changes — never break an existing database. Bump the schema version and update the `MigrationStrategy`.
5. **Use transactions** for state-changing workflows that alter queue/courts/matches/pairs (rotation is atomic).
6. **Create useful queries** (DAOs) for common access: active session, player queue, courts, matches and history.
7. **Update repository tests** when the schema changes.
8. **Avoid duplicating derived state** unless there is a clear reason.

## Checklist

- [ ] Tables with correct relations and integrity.
- [ ] Migration created for the schema change.
- [ ] Transactions where rotation/state changes happen.
- [ ] History event recorded on relevant changes.
- [ ] Useful DAOs/queries exposed (active session, queue, courts, matches, history).
- [ ] Repository tests updated and passing (`flutter test`).
