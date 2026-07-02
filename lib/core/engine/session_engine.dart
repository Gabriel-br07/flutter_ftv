import 'package:flutter_ftv/core/domain/ids.dart';
import 'package:flutter_ftv/core/domain/result.dart';
import 'package:flutter_ftv/core/utils/id_generator.dart';
import 'package:flutter_ftv/features/history/domain/history_event.dart';
import 'package:flutter_ftv/features/history/domain/history_event_type.dart';
import 'package:flutter_ftv/features/matches/domain/rotation_state.dart';
import 'package:flutter_ftv/features/matches/services/rotation_service.dart';
import 'package:flutter_ftv/features/pairs/domain/pair.dart';
import 'package:flutter_ftv/features/pairs/domain/pair_status.dart';
import 'package:flutter_ftv/features/pairs/services/pairing_service.dart';
import 'package:flutter_ftv/features/players/domain/player.dart';
import 'package:flutter_ftv/features/players/domain/player_status.dart';

/// Outcome of a bulk player import ([SessionEngine.addPlayers]).
class ImportPlayersResult {
  const ImportPlayersResult({
    required this.state,
    required this.addedCount,
    required this.skippedDuplicates,
  });

  /// The resulting state with the new players appended.
  final RotationState state;

  /// How many players were actually added.
  final int addedCount;

  /// Names skipped because they duplicated an existing player or an earlier name
  /// in the same batch (original trimmed spelling, in order).
  final List<String> skippedDuplicates;
}

/// Coordinates the pure domain services (`PairingService`, `RotationService`)
/// over a whole [RotationState].
///
/// This is where the app layer applies a single logical action to the session
/// state and gets a new immutable state back. It never re-implements rotation
/// or pairing rules — it delegates to the services and only performs
/// bookkeeping (queue/roster/history) around them. It stays pure: an injected
/// [IdGenerator] and clock keep it deterministic and free of Drift/Flutter.
class SessionEngine {
  SessionEngine({IdGenerator? idGenerator, DateTime Function()? now})
    : _ids = idGenerator ?? IdGenerator(),
      _now = now ?? DateTime.now;

  final IdGenerator _ids;
  final DateTime Function() _now;

  PairingService get _pairing =>
      PairingService(idBuilder: (_) => PairId(_ids.next('pair')));

  RotationService get _rotation => RotationService(
    matchIdBuilder: (_) => MatchId(_ids.next('m')),
    pairIdBuilder: (_) => PairId(_ids.next('rp')),
    eventIdBuilder: (_) => HistoryEventId(_ids.next('ev')),
  );

  /// Adds a player by arrival order to the end of the queue.
  ///
  /// The individual queue is never reordered and players already on a court are
  /// untouched: the new player is simply appended to the end of both the roster
  /// and the queue. This works identically whether the session is still a draft
  /// or already running.
  ///
  /// Fails with a [DomainError] when [name] (trimmed, case-insensitive) matches a
  /// player who is still in the session; a name freed by a *removed* player can
  /// be reused. The organizer is expected to disambiguate with a surname.
  Result<RotationState> addPlayer(RotationState state, String name) {
    final trimmed = name.trim();
    final normalized = trimmed.toLowerCase();
    final isDuplicate = state.roster.any(
      (p) =>
          p.status != PlayerStatus.removed &&
          p.name.trim().toLowerCase() == normalized,
    );
    if (isDuplicate) {
      return Failure(
        DomainError(
          'duplicate_player_name',
          'A player named "$trimmed" is already in the session',
        ),
      );
    }

    final player = Player(
      id: PlayerId(_ids.next('player')),
      sessionId: state.session.id,
      name: trimmed,
      arrivalOrder: state.roster.length,
    );
    return Success(
      state.copyWith(
        roster: [...state.roster, player],
        queue: [...state.queue, player.id],
        history: [
          ...state.history,
          _event(
            state,
            HistoryEventType.playerAdded,
            'Player ${player.name} added',
          ),
        ],
      ),
    );
  }

  /// Adds many players at once (bulk import), appending the new, unique names to
  /// the end of the queue in one transition. Names are normalized (trimmed,
  /// case-insensitive) and a name is **skipped** when it duplicates a player
  /// still in the session or a name already accepted earlier in the same batch —
  /// preserving the session's unique-name rule. Blank/whitespace-only names are
  /// ignored. Returns the new state plus how many were added and which were
  /// skipped as duplicates.
  ImportPlayersResult addPlayers(RotationState state, List<String> names) {
    final existing = {
      for (final p in state.roster)
        if (p.status != PlayerStatus.removed) p.name.trim().toLowerCase(),
    };
    final added = <Player>[];
    final events = <HistoryEvent>[];
    final skipped = <String>[];
    var arrivalOrder = state.roster.length;
    for (final raw in names) {
      final trimmed = raw.trim();
      if (trimmed.isEmpty) continue;
      final normalized = trimmed.toLowerCase();
      if (existing.contains(normalized)) {
        skipped.add(trimmed);
        continue;
      }
      existing.add(normalized);
      final player = Player(
        id: PlayerId(_ids.next('player')),
        sessionId: state.session.id,
        name: trimmed,
        arrivalOrder: arrivalOrder++,
      );
      added.add(player);
      events.add(
        _event(
          state,
          HistoryEventType.playerAdded,
          'Player ${player.name} added',
        ),
      );
    }
    final next = state.copyWith(
      roster: [...state.roster, ...added],
      queue: [...state.queue, ...added.map((p) => p.id)],
      history: [...state.history, ...events],
    );
    return ImportPlayersResult(
      state: next,
      addedCount: added.length,
      skippedDuplicates: skipped,
    );
  }

  /// Fills any open courts from the current pairs / queue without disturbing
  /// matches in progress, seating late entrants from the bottom of the ladder.
  /// Used after [addPlayer] while the session is already running so a newly
  /// added player can take an idle court immediately.
  RotationState fillOpenCourts(RotationState state) => _rotation
      .fillCourts(state: state, timestamp: _now(), fromTop: false)
      .state;

  /// Manually removes exactly one player from the session (organizer action).
  ///
  /// The player is marked removed and dropped from the queue first; if they were
  /// on a court, [RotationService.detachActivePlayer] then voids their match,
  /// dissolves their pair (the partner returns individually), lets the opponent
  /// keep the court and reconciles the ladder — so no removed player is left
  /// active on a court.
  RotationState removePlayer(RotationState state, PlayerId playerId) {
    final player = state.playerById(playerId);
    final marked = state.copyWith(
      roster: [
        for (final p in state.roster)
          if (p.id == playerId) p.copyWith(status: PlayerStatus.removed) else p,
      ],
      queue: [
        for (final id in state.queue)
          if (id != playerId) id,
      ],
    );
    final detached = _rotation.detachActivePlayer(
      state: marked,
      playerId: playerId,
      timestamp: _now(),
    );
    return detached.state.copyWith(
      history: [
        ...detached.state.history,
        _event(
          detached.state,
          HistoryEventType.playerRemoved,
          'Player ${player?.name ?? playerId.value} removed',
        ),
      ],
    );
  }

  /// Forms automatic pairs from the current queue (1st+2nd, 3rd+4th, ...).
  RotationState formAutomaticPairs(RotationState state) {
    final result = _pairing.formAutomaticPairs(
      queuedPlayers: state.queuedPlayers,
    );
    return _applyPairing(state, result.pairs, result.waitingPlayer);
  }

  /// Manually pairs two available players into a single pair placed at the end
  /// of the pair queue. Only that pair is created; every other queued player
  /// stays individual, so the organizer can choose several pairs in a row.
  /// Returns a [DomainError] when the selection is invalid.
  Result<RotationState> createManualPair(
    RotationState state, {
    required PlayerId playerOneId,
    required PlayerId playerTwoId,
  }) {
    final result = _pairing.createManualPair(
      queuedPlayers: state.queuedPlayers,
      playerOneId: playerOneId,
      playerTwoId: playerTwoId,
      // Monotonic order across incremental manual pairs; final ordering after
      // automatic pairs is enforced by PairOrigin at court-fill time.
      queueOrder: state.pairs.length,
    );
    if (result.hasErrors) return Failure(result.errors.first);
    return Success(_applyPairing(state, result.pairs, result.waitingPlayer));
  }

  /// Dissolves a pair that was formed but has not started playing yet (draft
  /// screen), returning both players individually to the queue in arrival order.
  /// No-op if the pair is missing, already dissolved, or currently on a court
  /// (before the round starts it never is).
  RotationState dissolveFormedPair(RotationState state, PairId pairId) {
    final pair = state.pairById(pairId);
    if (pair == null || pair.status == PairStatus.dissolved) return state;
    final onCourt = state.slots.any((s) => s.pairIds.contains(pairId));
    if (onCourt) return state;

    final freedIds = pair.playerIds.map((i) => i.value).toSet();
    final roster = [
      for (final p in state.roster)
        if (freedIds.contains(p.id.value))
          p.copyWith(status: PlayerStatus.queued)
        else
          p,
    ];
    // Reinsert the two freed players (paired players had left the queue), then
    // keep the whole individual queue ordered by arrival.
    final byArrival = {for (final p in roster) p.id.value: p.arrivalOrder};
    final queue = [...state.queue, ...pair.playerIds]
      ..sort((a, b) => byArrival[a.value]!.compareTo(byArrival[b.value]!));
    return state.copyWith(
      roster: roster,
      pairs: [
        for (final p in state.pairs)
          if (p.id != pairId) p,
      ],
      queue: queue,
      history: [
        ...state.history,
        _event(
          state,
          HistoryEventType.pairDissolved,
          'Pair ${pairId.value} dissolved',
        ),
      ],
    );
  }

  /// Starts a round: automatically pairs any players still individual in the
  /// queue, then fills the courts. Automatic/individual pairs take courts before
  /// any manually chosen pair (enforced by [PairOrigin]); an odd leftover stays
  /// at the front of the queue with priority for the next partner.
  RotationState startRound(RotationState state) {
    final prepared = state.queuedPlayers.length >= 2
        ? formAutomaticPairs(state)
        : state;
    return _rotation.fillCourts(state: prepared, timestamp: _now()).state;
  }

  /// Restores [previous] as the current state, appending an `undoPerformed`
  /// history event (built with the injected clock/ids so it stays
  /// deterministic). Owning event construction here keeps it out of the
  /// ViewModel.
  RotationState undo(RotationState previous) => previous.copyWith(
    history: [
      ...previous.history,
      _event(previous, HistoryEventType.undoPerformed, 'Undo performed'),
    ],
  );

  /// A `sessionStarted` history event for [state]; recorded atomically with the
  /// status change by the repository.
  HistoryEvent sessionStartedEvent(RotationState state) =>
      _event(state, HistoryEventType.sessionStarted, 'Session started');

  /// A `sessionFinished` history event for [state]; recorded atomically with the
  /// status change by the repository.
  HistoryEvent sessionFinishedEvent(RotationState state) =>
      _event(state, HistoryEventType.sessionFinished, 'Session finished');

  /// Finalizes a match and applies the ladder rotation.
  RotationResult finishMatch(
    RotationState state, {
    required MatchId matchId,
    required PairId winnerPairId,
    bool winnerGotTired = false,
    bool bothPairsLeft = false,
  }) {
    return _rotation.finishMatch(
      state: state,
      matchId: matchId,
      winnerPairId: winnerPairId,
      winnerGotTired: winnerGotTired,
      bothPairsLeft: bothPairsLeft,
      timestamp: _now(),
    );
  }

  /// Applies a set of freshly formed [pairs] (and an optional waiting player) to
  /// the state by **merging**: the new pairs are appended to any existing pairs,
  /// the newly paired players are dropped from the individual queue (order
  /// preserved), and rostered players get the right status. Merging (rather than
  /// replacing) keeps pairs and players that are already active on courts.
  RotationState _applyPairing(
    RotationState state,
    List<Pair> pairs,
    Player? waitingPlayer,
  ) {
    final pairedIds = {
      for (final p in pairs) ...p.playerIds.map((i) => i.value),
    };
    final waitingId = waitingPlayer?.id;
    final roster = [
      for (final p in state.roster)
        if (pairedIds.contains(p.id.value))
          p.copyWith(status: PlayerStatus.playing)
        else if (p.id == waitingId)
          p.copyWith(status: PlayerStatus.waitingForPair)
        else
          p,
    ];
    return state.copyWith(
      pairs: [...state.pairs, ...pairs],
      roster: roster,
      queue: [
        for (final id in state.queue)
          if (!pairedIds.contains(id.value)) id,
      ],
      history: [
        ...state.history,
        _event(state, HistoryEventType.pairsGenerated, 'Pairs generated'),
      ],
    );
  }

  HistoryEvent _event(
    RotationState state,
    HistoryEventType type,
    String description,
  ) => HistoryEvent(
    id: HistoryEventId(_ids.next('ev')),
    sessionId: state.session.id,
    type: type,
    description: description,
    createdAt: _now(),
  );
}
