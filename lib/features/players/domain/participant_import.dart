import 'dart:convert';

/// Matches a single leading list prefix at the start of a line: a bullet
/// (`-`, `*`, `•`) or a number followed by `.`, `-` or `)` — with optional
/// surrounding whitespace. Examples stripped: `1.`, `1. `, `1.Luan`, `1 - `,
/// `1) `, `- `, `* `.
///
/// The hyphen inside the character class is escaped (`[.\-)]`) so it is a
/// literal, not an (invalid) range.
final _listPrefix = RegExp(r'^\s*(?:[-*•]\s*|\d+\s*[.\-)]\s*)');

/// Parses a pasted, multi-line list into clean participant names.
///
/// For each line it removes a single leading list prefix (numbering or bullet),
/// trims surrounding whitespace, and drops the line if nothing remains. The
/// original order is preserved and duplicates are kept as-is — duplicate
/// handling is a concern of the caller (preview / import), not the parser.
///
/// Pure and offline: no I/O and no network. Safe to unit-test in isolation.
List<String> parseParticipantNames(String rawText) {
  final names = <String>[];
  for (final line in const LineSplitter().convert(rawText)) {
    final cleaned = line.replaceFirst(_listPrefix, '').trim();
    if (cleaned.isEmpty) continue;
    names.add(cleaned);
  }
  return names;
}
