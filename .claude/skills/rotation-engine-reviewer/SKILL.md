---
name: rotation-engine-reviewer
description: Use to implement, review or test the rotation engine (RotationService and related domain services). Invoke whenever changing how pairs are formed, how losers return to the queue, or how winners move up the court ladder.
---

# Rotation Engine Reviewer

Ensures the rotation logic is correct, isolated and transactional. `RotationService` must be pure and testable without Flutter UI and without a database.

## Rule checklist

Verify each item when implementing or reviewing:

- [ ] **Player queue is individual** (the unit is the player).
- [ ] **Pairs are temporary**.
- [ ] **Manual pair goes to the end** of the pair queue.
- [ ] **Manual pair is dissolved after losing/tiring/leaving** and lasts only one cycle.
- [ ] **Loser returns individually** to the end of the queue.
- [ ] **Court A winner stays on Court A**.
- [ ] **Court B winner waits for Court A** and then **challenges the Court A winner**.
- [ ] **Court C winner waits for Court B** and then **moves up to Court B**.
- [ ] **Lower courts follow the same ladder rule** (D, E, F...).
- [ ] **Tired winner returns individually** to the queue.
- [ ] **Odd player waits**.
- [ ] **Empty courts are filled from the available queue**.

## Invariants

- [ ] **No player is in two active places at once** (two courts, or court + queue).
- [ ] **No player appears in two active pairs.**
- [ ] **No dissolved pair remains active** on a court.
- [ ] **All state changes are transactional when persistence is involved** — the match-finalization sequence (record result → dissolve losing pair → return losers → update winner → apply court ladder → form new pairs → fill empty courts → record event) is atomic.
- [ ] **All relevant events are recorded in history.**

## How to review

1. Read `CLAUDE.md` and `.claude/rules/business-rules.md`.
2. Confirm the logic lives in `RotationService` (domain), not in widgets or the Repository.
3. Verify the service is **pure**: input state → output state, no Drift/Flutter.
4. Confirm **tests exist for each important rule** (see `business-rule-test-writer`) and run `flutter test`.
