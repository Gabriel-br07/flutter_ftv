import 'package:flutter_ftv/features/players/domain/participant_import.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parseParticipantNames', () {
    test('strips "number + dot without space" prefix', () {
      expect(parseParticipantNames('1.Luan'), ['Luan']);
    });

    test('strips "number + dot + space" prefix', () {
      expect(parseParticipantNames('1. Luan'), ['Luan']);
    });

    test('strips "number + hyphen" prefix', () {
      expect(parseParticipantNames('1 - Luan'), ['Luan']);
    });

    test('strips "number + parenthesis" prefix', () {
      expect(parseParticipantNames('1) Luan'), ['Luan']);
    });

    test('strips "hyphen bullet" prefix', () {
      expect(parseParticipantNames('- Luan'), ['Luan']);
    });

    test('strips "asterisk bullet" prefix', () {
      expect(parseParticipantNames('* Pedro'), ['Pedro']);
    });

    test('keeps a bare name', () {
      expect(parseParticipantNames('Luan'), ['Luan']);
    });

    test('trims surrounding whitespace', () {
      expect(parseParticipantNames('  Gabriel  '), ['Gabriel']);
    });

    test('ignores empty and whitespace-only lines', () {
      expect(parseParticipantNames('\n\nLuan\n   \nLucas\n\n'), [
        'Luan',
        'Lucas',
      ]);
    });

    test('ignores a line that becomes empty after cleanup', () {
      expect(parseParticipantNames('1.\n2. Lucas'), ['Lucas']);
    });

    test('preserves duplicates in order', () {
      expect(parseParticipantNames('Luan\nLuan\nlucas\nLucas'), [
        'Luan',
        'Luan',
        'lucas',
        'Lucas',
      ]);
    });

    test('parses the preferred numbered format', () {
      const input = '1.Luan\n2.Lucas\n3.Felipe\n4.Gabriel';
      expect(parseParticipantNames(input), [
        'Luan',
        'Lucas',
        'Felipe',
        'Gabriel',
      ]);
    });

    test('parses a mixed list with variations, bullets and blank lines', () {
      const input = '1. Luan\n\n2 - Lucas\n3) Felipe\nGabriel\n\n* Pedro';
      expect(parseParticipantNames(input), [
        'Luan',
        'Lucas',
        'Felipe',
        'Gabriel',
        'Pedro',
      ]);
    });

    test('handles Windows line endings', () {
      expect(parseParticipantNames('1. Luan\r\n2. Lucas'), ['Luan', 'Lucas']);
    });

    test('keeps internal hyphens in names', () {
      expect(parseParticipantNames('- Ana-Maria'), ['Ana-Maria']);
    });

    test('returns empty list for blank input', () {
      expect(parseParticipantNames('   \n\n  '), isEmpty);
    });
  });
}
