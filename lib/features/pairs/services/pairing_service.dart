import 'package:flutter_ftv/core/domain/ids.dart';
import 'package:flutter_ftv/core/domain/result.dart';
import 'package:flutter_ftv/features/pairs/domain/pair.dart';
import 'package:flutter_ftv/features/pairs/domain/pair_origin.dart';
import 'package:flutter_ftv/features/players/domain/player.dart';
import 'package:flutter_ftv/features/players/domain/player_status.dart';

/// The outcome of a pairing operation.
class PairingResult {
  const PairingResult({
    this.pairs = const [],
    this.waitingPlayer,
    this.updatedQueue = const [],
    this.errors = const [],
  });

  /// Creates a failed result carrying a single [error].
  factory PairingResult.failure(DomainError error) =>
      PairingResult(errors: [error]);

  /// The pairs formed, ordered by their `queueOrder` (front of the pair queue
  /// first; a manual pair, if any, is last).
  final List<Pair> pairs;

  /// The leftover odd player waiting for the next available player, if any.
  final Player? waitingPlayer;

  /// The remaining individual player queue after pairing. Paired players leave
  /// the queue; a waiting player stays (as [PlayerStatus.waitingForPair]).
  final List<Player> updatedQueue;

  /// Validation errors; empty when the operation succeeded.
  final List<DomainError> errors;

  bool get hasErrors => errors.isNotEmpty;
  bool get isSuccess => errors.isEmpty;
}

/// Forms temporary pairs from the individual player queue.
///
/// Pure and deterministic: pair ids are produced by an injectable [idBuilder]
/// (defaulting to `pair-<sequence>`), so no randomness or clock is involved.
class PairingService {
  const PairingService({PairId Function(int sequence)? idBuilder})
    : _idBuilder = idBuilder ?? _defaultIdBuilder;

  final PairId Function(int sequence) _idBuilder;

  static PairId _defaultIdBuilder(int sequence) => PairId('pair-$sequence');

  /// Forms automatic pairs by queue order: 1st+2nd, 3rd+4th, ... An odd
  /// leftover player is returned as [PairingResult.waitingPlayer] with status
  /// [PlayerStatus.waitingForPair]. Removed players are ignored.
  PairingResult formAutomaticPairs({required List<Player> queuedPlayers}) {
    final available = _available(queuedPlayers);
    return _pairSequentially(available, sequenceStart: 0);
  }

  /// Manually pairs [playerOneId] and [playerTwoId] into a single pair placed at
  /// the **end** of the pair queue. Only that one pair is created — the other
  /// queued players stay individual, so the organizer can keep choosing pairs.
  ///
  /// [queueOrder] positions this pair among existing pairs (the caller passes a
  /// monotonically increasing value). The manual pair's ordering *after* every
  /// automatic pair is ultimately enforced by [PairOrigin] at court-fill time,
  /// so a manual pair never jumps ahead even if created first.
  ///
  /// Returns a failed [PairingResult] (via [DomainError]) when the two players
  /// are the same, missing, removed, or already playing — guaranteeing no
  /// player ends up in two active pairs.
  PairingResult createManualPair({
    required List<Player> queuedPlayers,
    required PlayerId playerOneId,
    required PlayerId playerTwoId,
    int queueOrder = 0,
  }) {
    if (playerOneId == playerTwoId) {
      return PairingResult.failure(
        const DomainError(
          'manual_pair_same_player',
          'A manual pair needs two distinct players',
        ),
      );
    }

    final one = _validateManualCandidate(queuedPlayers, playerOneId);
    if (one.isFailure) return PairingResult.failure(one.errorOrNull!);
    final two = _validateManualCandidate(queuedPlayers, playerTwoId);
    if (two.isFailure) return PairingResult.failure(two.errorOrNull!);

    final playerOne = one.valueOrNull!;
    final playerTwo = two.valueOrNull!;

    final manualPair = Pair(
      id: _idBuilder(queueOrder),
      sessionId: playerOne.sessionId,
      playerOneId: playerOne.id,
      playerTwoId: playerTwo.id,
      origin: PairOrigin.manual,
      queueOrder: queueOrder,
    );

    return PairingResult(pairs: [manualPair]);
  }

  /// Filters out removed players; a removed player must never be paired.
  List<Player> _available(List<Player> players) =>
      players.where((p) => p.status != PlayerStatus.removed).toList();

  /// Pairs [players] two-by-two in order, marking each paired player
  /// [PlayerStatus.playing]; any odd leftover becomes the waiting player.
  PairingResult _pairSequentially(
    List<Player> players, {
    required int sequenceStart,
  }) {
    final pairs = <Pair>[];
    var sequence = sequenceStart;
    var index = 0;
    while (index + 1 < players.length) {
      final first = players[index];
      final second = players[index + 1];
      pairs.add(
        Pair(
          id: _idBuilder(sequence),
          sessionId: first.sessionId,
          playerOneId: first.id,
          playerTwoId: second.id,
          origin: PairOrigin.automatic,
          queueOrder: sequence,
        ),
      );
      sequence++;
      index += 2;
    }

    Player? waiting;
    final updatedQueue = <Player>[];
    if (index < players.length) {
      waiting = players[index].copyWith(status: PlayerStatus.waitingForPair);
      updatedQueue.add(waiting);
    }

    return PairingResult(
      pairs: pairs,
      waitingPlayer: waiting,
      updatedQueue: updatedQueue,
    );
  }

  /// Validates a manual-pair candidate: must exist in the pool, not be removed,
  /// and not already be playing.
  Result<Player> _validateManualCandidate(
    List<Player> players,
    PlayerId playerId,
  ) {
    final matches = players.where((p) => p.id == playerId);
    if (matches.isEmpty) {
      return Failure(
        DomainError(
          'player_not_available',
          'Player ${playerId.value} is not in the queue',
        ),
      );
    }
    final player = matches.first;
    if (player.status == PlayerStatus.removed) {
      return Failure(
        DomainError(
          'player_removed',
          'Player ${playerId.value} was removed and cannot be paired',
        ),
      );
    }
    if (player.status == PlayerStatus.playing) {
      return Failure(
        DomainError(
          'player_playing',
          'Player ${playerId.value} is already playing',
        ),
      );
    }
    return Success(player);
  }
}
