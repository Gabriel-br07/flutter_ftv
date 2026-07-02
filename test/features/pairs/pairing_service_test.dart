import 'package:flutter_ftv/features/pairs/domain/pair_origin.dart';
import 'package:flutter_ftv/features/pairs/domain/pair_status.dart';
import 'package:flutter_ftv/features/pairs/services/pairing_service.dart';
import 'package:flutter_ftv/features/players/domain/player_status.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fixtures.dart';

void main() {
  const service = PairingService();

  group('PairingService.formAutomaticPairs', () {
    test('should_form_pairs_by_arrival_order', () {
      // Arrange
      final players = makePlayers(4); // p1..p4, queued, arrival 1..4

      // Act
      final result = service.formAutomaticPairs(queuedPlayers: players);

      // Assert
      expect(result.isSuccess, isTrue);
      expect(result.pairs, hasLength(2));
      expect(result.pairs[0].playerOneId, players[0].id);
      expect(result.pairs[0].playerTwoId, players[1].id);
      expect(result.pairs[1].playerOneId, players[2].id);
      expect(result.pairs[1].playerTwoId, players[3].id);
      expect(
        result.pairs.every((p) => p.origin == PairOrigin.automatic),
        isTrue,
      );
      expect(result.pairs.every((p) => p.status == PairStatus.queued), isTrue);
      expect(result.waitingPlayer, isNull);
    });

    test('should_leave_odd_player_waiting_for_pair', () {
      // Arrange
      final players = makePlayers(5); // p1..p5

      // Act
      final result = service.formAutomaticPairs(queuedPlayers: players);

      // Assert
      expect(result.pairs, hasLength(2));
      expect(result.waitingPlayer, isNotNull);
      expect(result.waitingPlayer!.id, players[4].id);
      expect(result.waitingPlayer!.status, PlayerStatus.waitingForPair);
      expect(result.updatedQueue.single.id, players[4].id);
    });
  });

  group('PairingService.createManualPair', () {
    test('should_create_only_the_chosen_pair', () {
      // Arrange: 6 players; two of them (p5, p6) choose to play together.
      final players = makePlayers(6);

      // Act
      final result = service.createManualPair(
        queuedPlayers: players,
        playerOneId: players[4].id,
        playerTwoId: players[5].id,
      );

      // Assert: exactly one pair is created (the others stay individual, so the
      // organizer can keep choosing pairs).
      expect(result.isSuccess, isTrue);
      expect(result.pairs, hasLength(1));
      final pair = result.pairs.single;
      expect(pair.origin, PairOrigin.manual);
      expect(pair.contains(players[4].id), isTrue);
      expect(pair.contains(players[5].id), isTrue);
      expect(result.waitingPlayer, isNull);
    });

    test('should_position_manual_pair_by_provided_queue_order', () {
      // Arrange
      final players = makePlayers(2);

      // Act
      final result = service.createManualPair(
        queuedPlayers: players,
        playerOneId: players[0].id,
        playerTwoId: players[1].id,
        queueOrder: 3,
      );

      // Assert: the pair is manual and carries the caller-provided order; landing
      // after automatic pairs is enforced by PairOrigin at court-fill time.
      final pair = result.pairs.single;
      expect(pair.origin, PairOrigin.manual);
      expect(pair.queueOrder, 3);
    });

    test('should_reject_manual_pair_with_removed_player', () {
      // Arrange
      final removed = makePlayer(1, status: PlayerStatus.removed);
      final available = makePlayer(2);

      // Act
      final result = service.createManualPair(
        queuedPlayers: [removed, available],
        playerOneId: removed.id,
        playerTwoId: available.id,
      );

      // Assert
      expect(result.hasErrors, isTrue);
      expect(result.pairs, isEmpty);
      expect(result.errors.single.code, 'player_removed');
    });

    test('should_reject_manual_pair_with_playing_player', () {
      // Arrange
      final playing = makePlayer(1, status: PlayerStatus.playing);
      final available = makePlayer(2);

      // Act
      final result = service.createManualPair(
        queuedPlayers: [playing, available],
        playerOneId: playing.id,
        playerTwoId: available.id,
      );

      // Assert
      expect(result.hasErrors, isTrue);
      expect(result.errors.single.code, 'player_playing');
    });

    test('should_prevent_player_from_appearing_in_two_active_pairs', () {
      // Arrange
      final players = makePlayers(4);

      // Act: manually pair p1 with p2 (the rest stay individual).
      final result = service.createManualPair(
        queuedPlayers: players,
        playerOneId: players[0].id,
        playerTwoId: players[1].id,
      );

      // Assert: every player id appears in exactly one pair.
      final allIds = result.pairs.expand((p) => p.playerIds).toList();
      expect(allIds.toSet(), hasLength(allIds.length));
      // A player cannot be paired with themselves either.
      final selfPair = service.createManualPair(
        queuedPlayers: players,
        playerOneId: players[0].id,
        playerTwoId: players[0].id,
      );
      expect(selfPair.hasErrors, isTrue);
      expect(selfPair.errors.single.code, 'manual_pair_same_player');
    });
  });
}
