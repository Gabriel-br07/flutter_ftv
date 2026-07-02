# Rule: Design System (UI/UX)

UI is built for **fast use in an outdoor sports context** — the organizer taps the screen between matches, often on the beach, in sunlight.

## Fundamentals

- Use **Material 3**.
- Optimize for **fast use**: few taps, large touch targets, clear and legible text.

## Components and layout

- **Large buttons** for primary actions.
- **Clear court cards** — each court (A, B, C...) as a card showing its current pair and status.
- **Queue always visible** — the waiting queue must be clear on screen.
- **Status chips/badges** — indicate court occupied/free, waiting, winner recorded.
- **The courts screen is the main operational screen.**
- **Main actions must not be hidden** in overflow menus or drawers.

## User-facing text

- **User-facing text is in Portuguese** (e.g. "Criar pelada", "Fila de espera", "Desfazer última ação"). Code identifiers stay in English.

## Interaction safety

- **Confirmation dialogs for destructive actions** (remove player, end session).
- **Snackbar/feedback for important actions** (e.g. winner recorded).
- **Undo the last action** when possible.

## MVP constraints

- **Avoid login, long onboarding, or complex forms** in the MVP.
- Avoid screens with many steps or many fields.
