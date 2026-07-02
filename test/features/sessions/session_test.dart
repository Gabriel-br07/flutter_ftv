import 'package:flutter_ftv/core/domain/ids.dart';
import 'package:flutter_ftv/features/sessions/domain/session.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fixtures.dart';

void main() {
  Session create({
    String name = 'Pelada',
    int courts = 2,
    required int points,
  }) {
    return Session.create(
      id: const SessionId('s'),
      name: name,
      courtCount: courts,
      targetPoints: points,
      createdAt: testTimestamp,
    );
  }

  test('should_accept_target_points_15', () {
    final session = create(points: 15);
    expect(session.targetPoints, 15);
  });

  test('should_accept_target_points_18', () {
    final session = create(points: 18);
    expect(session.targetPoints, 18);
  });

  test('should_reject_invalid_target_points', () {
    expect(() => create(points: 21), throwsArgumentError);
    expect(() => create(points: 16), throwsArgumentError);
    expect(() => create(points: 0), throwsArgumentError);
  });

  test('should_reject_blank_session_name', () {
    expect(() => create(name: '', points: 15), throwsArgumentError);
    expect(() => create(name: '   ', points: 15), throwsArgumentError);
  });

  test('should_reject_court_count_less_than_one', () {
    expect(() => create(courts: 0, points: 15), throwsArgumentError);
    expect(() => create(courts: -1, points: 15), throwsArgumentError);
  });
}
