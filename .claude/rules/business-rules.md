# Rule: Business Rules (domain)

These are the domain rules of the futevôlei session. They must live in Services (never in widgets) and be covered by unit tests.

## Session

- The organizer creates a casual futevôlei session.
- The organizer provides **session name**, **number of courts**, and **target points: 15 or 18**.
- **Target points can only be 15 or 18**; reject any other value.
- The app records only **winner/loser** — no point-by-point scoring in the MVP.

## Queue

- The **individual player queue is the source of truth** for availability.
- Players are added by **arrival order**.
- If there is an **odd number of players**, the leftover player **waits** for the next available player.

## Pairs

- Pairs are **temporary**.
- **Automatic pairs** are formed by arrival order: 1st + 2nd, 3rd + 4th, 5th + 6th...
- **Manual pairs** (two players choosing to play together) go to the **end of the pair queue** as the cost of choosing.
- A **manual pair lasts only one cycle**.
- **Losing / tired / leaving pairs are dissolved**, and their players return **individually** to the end of the player queue.

## Courts (ladder)

- Courts are named **A, B, C, D...**; **Court A is the main court**.
- The **Court A winner stays** on Court A.
- The **Court B winner waits for Court A** to finish and then **challenges the Court A winner**.
- The **Court C winner waits for Court B** to finish and then **moves up to Court B**.
- The same ladder rule applies to lower courts (D, E, F...).
- **Losers return individually** to the end of the queue.
- If the **winning pair gets tired**, both players return **individually** to the queue.
- The organizer can mark that **both pairs left/got tired**; all four players return individually.
- **Empty courts are filled from the available queue.**

## Removal

- Leaving the session is a **manual organizer action** only; it removes only that player.
- A **loser does not leave the session automatically** — the player returns individually to the end of the queue.

## Invariants

- **No player can be duplicated across active states** (not in two courts, not in a court and the queue at the same time).
- **No player can appear in two active pairs.**
- **No dissolved pair remains active** on a court.
- A **history event must be recorded** for every relevant state change.
