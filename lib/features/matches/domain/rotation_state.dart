import 'package:flutter_ftv/core/domain/ids.dart';
import 'package:flutter_ftv/features/courts/domain/court.dart';
import 'package:flutter_ftv/features/history/domain/history_event.dart';
import 'package:flutter_ftv/features/matches/domain/court_slot.dart';
import 'package:flutter_ftv/features/matches/domain/match.dart';
import 'package:flutter_ftv/features/matches/domain/match_status.dart';
import 'package:flutter_ftv/features/pairs/domain/pair.dart';
import 'package:flutter_ftv/features/pairs/domain/pair_status.dart';
import 'package:flutter_ftv/features/players/domain/player.dart';
import 'package:flutter_ftv/features/sessions/domain/session.dart';

/// The full, immutable snapshot of a session's rotation state.
///
/// This is the input and output of [RotationService]: pure domain data, with no
/// dependency on Flutter, Drift, or Riverpod. Persistence is the repository's
/// concern.
///
/// Invariants (checked via [hasUniqueActivePlayers] /
/// [hasNoDissolvedPairOnCourt]) must hold after every transition:
/// no player is active in two places, and no dissolved pair sits on a court.
class RotationState {
  const RotationState({
    required this.session,
    required this.roster,
    required this.queue,
    required this.courts,
    required this.pairs,
    required this.slots,
    required this.matches,
    required this.history,
  });

  /// The session being played.
  final Session session;

  /// Every player in the session (any status). Source of [Player] objects.
  final List<Player> roster;

  /// The individual player queue as an ordered list of ids: index 0 is the
  /// front (picked first), the last index is the end.
  final List<PlayerId> queue;

  /// The courts of the ladder, ascending by [Court.level] (A, B, C, ...).
  final List<Court> courts;

  /// All pairs of the session. Active pairs plus dissolved ones (kept with
  /// [PairStatus.dissolved]) so finished matches that reference a loser pair
  /// still resolve via [pairById] after a reload. Dissolved pairs are never
  /// referenced by a court slot.
  final List<Pair> pairs;

  /// Per-court occupancy, one entry per court.
  final List<CourtSlot> slots;

  /// All matches created in the session (active and finished).
  final List<Match> matches;

  /// Recorded history events, in creation order.
  final List<HistoryEvent> history;

  // --- Lookups ---------------------------------------------------------------

  Player? playerById(PlayerId id) {
    for (final p in roster) {
      if (p.id == id) return p;
    }
    return null;
  }

  Pair? pairById(PairId id) {
    for (final p in pairs) {
      if (p.id == id) return p;
    }
    return null;
  }

  Court? courtById(CourtId id) {
    for (final c in courts) {
      if (c.id == id) return c;
    }
    return null;
  }

  Court? courtByLevel(int level) {
    for (final c in courts) {
      if (c.level == level) return c;
    }
    return null;
  }

  CourtSlot? slotForCourt(CourtId id) {
    for (final s in slots) {
      if (s.courtId == id) return s;
    }
    return null;
  }

  Match? matchById(MatchId id) {
    for (final m in matches) {
      if (m.id == id) return m;
    }
    return null;
  }

  /// The active match on [courtId], if any.
  Match? activeMatchOnCourt(CourtId courtId) {
    final slot = slotForCourt(courtId);
    if (slot == null || slot.matchId == null) return null;
    final match = matchById(slot.matchId!);
    if (match == null || match.status != MatchStatus.active) return null;
    return match;
  }

  /// The players currently in the queue, in order.
  List<Player> get queuedPlayers => [
    for (final id in queue)
      if (playerById(id) case final Player p) p,
  ];

  // --- Invariants ------------------------------------------------------------

  /// All player ids that are active on a court right now (across all slots).
  List<PlayerId> get activePlayerIds {
    final ids = <PlayerId>[];
    for (final slot in slots) {
      for (final pairId in slot.pairIds) {
        final pair = pairById(pairId);
        if (pair != null) ids.addAll(pair.playerIds);
      }
    }
    return ids;
  }

  /// No player appears twice among active courts, and no active player is also
  /// sitting in the queue.
  bool get hasUniqueActivePlayers {
    final active = activePlayerIds;
    final activeSet = active.toSet();
    if (activeSet.length != active.length) return false; // duplicate on courts
    for (final id in queue) {
      if (activeSet.contains(id)) return false; // playing and queued at once
    }
    return true;
  }

  /// No dissolved pair is referenced by any court slot.
  bool get hasNoDissolvedPairOnCourt {
    for (final slot in slots) {
      for (final pairId in slot.pairIds) {
        final pair = pairById(pairId);
        // A pair referenced by a slot must exist and not be dissolved.
        if (pair == null || pair.status == PairStatus.dissolved) return false;
      }
    }
    return true;
  }

  RotationState copyWith({
    Session? session,
    List<Player>? roster,
    List<PlayerId>? queue,
    List<Court>? courts,
    List<Pair>? pairs,
    List<CourtSlot>? slots,
    List<Match>? matches,
    List<HistoryEvent>? history,
  }) {
    return RotationState(
      session: session ?? this.session,
      roster: roster ?? this.roster,
      queue: queue ?? this.queue,
      courts: courts ?? this.courts,
      pairs: pairs ?? this.pairs,
      slots: slots ?? this.slots,
      matches: matches ?? this.matches,
      history: history ?? this.history,
    );
  }
}
