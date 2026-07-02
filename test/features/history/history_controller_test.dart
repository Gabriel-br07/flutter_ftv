import 'package:flutter_ftv/app/providers.dart';
import 'package:flutter_ftv/core/domain/ids.dart';
import 'package:flutter_ftv/features/history/domain/history_event.dart';
import 'package:flutter_ftv/features/history/domain/history_event_type.dart';
import 'package:flutter_ftv/features/history/presentation/history_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fakes.dart';
import '../../support/fixtures.dart';

void main() {
  test('should_load_history_events_newest_first', () async {
    final events = [
      HistoryEvent(
        id: const HistoryEventId('e1'),
        sessionId: testSessionId,
        type: HistoryEventType.sessionCreated,
        description: 'created',
        createdAt: testTimestamp,
      ),
      HistoryEvent(
        id: const HistoryEventId('e2'),
        sessionId: testSessionId,
        type: HistoryEventType.playerAdded,
        description: 'added',
        createdAt: testTimestamp.add(const Duration(minutes: 1)),
      ),
    ];
    final seed = makeState(roster: const [], history: events);
    final container = ProviderContainer(
      overrides: [
        sessionStateRepositoryProvider.overrideWithValue(
          FakeSessionStateRepository({seed.session.id.value: seed}),
        ),
      ],
    );
    addTearDown(container.dispose);

    await container
        .read(historyControllerProvider.notifier)
        .load(testSessionId.value);

    final state = container.read(historyControllerProvider);
    expect(state.events, hasLength(2));
    expect(state.events.first.type, HistoryEventType.playerAdded);
  });
}
