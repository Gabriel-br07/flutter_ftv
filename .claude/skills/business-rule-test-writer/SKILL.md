---
name: business-rule-test-writer
description: Use to generate unit tests for the session's business rules (pairing, queue, court ladder, invariants). Invoke when coverage is missing for RotationService/PairingService/QueueService or after changing a rule.
---

# Business Rule Test Writer

Generates Dart unit tests with **descriptive English names**, covering the business rules. Focus on pure tests (no Flutter UI, no database) for the rotation services.

## Tests to create

Create one test per rule, using these names:

- `should_form_pairs_by_arrival_order`
- `should_leave_odd_player_waiting_for_pair`
- `should_move_manual_pair_to_end_of_pair_queue`
- `should_dissolve_manual_pair_after_loss`
- `should_return_losing_players_individually_to_queue`
- `should_keep_court_a_winner_on_court_a`
- `should_make_court_b_winner_wait_for_court_a`
- `should_make_court_b_winner_challenge_court_a_winner`
- `should_move_court_c_winner_up_to_court_b`
- `should_return_tired_winner_players_individually_to_queue`
- `should_return_all_players_when_both_pairs_leave`
- `should_remove_player_only_by_manual_action`
- `should_prevent_player_from_being_queued_and_playing`
- `should_prevent_player_from_appearing_in_two_active_pairs`
- `should_fill_empty_courts_from_available_queue`
- `should_reject_invalid_target_points`

## Guidelines

1. Read `CLAUDE.md`, `.claude/rules/business-rules.md` and `.claude/rules/testing.md`.
2. Use test names that describe the rule (snake_case as above).
3. Cover the **happy path and edge cases** (empty queue, one player, odd count, all courts occupied).
4. `RotationService` tests must be **pure** — do not mock Drift or Flutter.
5. When done, run `flutter test` and make sure everything passes.
