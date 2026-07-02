/// Zero-cost, type-safe identifiers for domain entities.
///
/// Each identifier is an [extension type] over [String], which gives value
/// equality for free (two ids with the same underlying value are equal) while
/// preventing accidental mixing of, say, a [PlayerId] where a [PairId] is
/// expected.
library;

extension type const SessionId(String value) {}

extension type const PlayerId(String value) {}

extension type const PairId(String value) {}

extension type const CourtId(String value) {}

extension type const MatchId(String value) {}

extension type const HistoryEventId(String value) {}
