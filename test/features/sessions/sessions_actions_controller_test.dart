import 'package:flutter_ftv/app/providers.dart';
import 'package:flutter_ftv/features/history/domain/history_event_type.dart';
import 'package:flutter_ftv/features/sessions/domain/session_status.dart';
import 'package:flutter_ftv/features/sessions/presentation/sessions_actions_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fakes.dart';
import '../../support/fixtures.dart';

void main() {
  test(
    'finish sets the session status to finished and records the event',
    () async {
      final sessionsRepo = FakeSessionsRepository();
      await sessionsRepo.createSession(
        name: 'Pelada',
        courtCount: 1,
        targetPoints: 15,
      );
      final createdId = (await sessionsRepo.getSessions()).single.id;
      final seed = makeState(roster: makePlayers(2), courts: makeCourts(1));

      final container = ProviderContainer(
        overrides: [
          sessionsRepositoryProvider.overrideWithValue(sessionsRepo),
          sessionStateRepositoryProvider.overrideWithValue(
            FakeSessionStateRepository({createdId.value: seed}),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container
          .read(sessionsActionsControllerProvider.notifier)
          .finish(createdId);

      expect(
        (await sessionsRepo.getSessions()).single.status,
        SessionStatus.finished,
      );
      expect(
        sessionsRepo.recordedEvents.map((e) => e.type),
        contains(HistoryEventType.sessionFinished),
      );
      expect(
        container.read(sessionsActionsControllerProvider).infoMessage,
        'Pelada finalizada.',
      );
    },
  );

  test('delete removes the session from the list', () async {
    final sessionsRepo = FakeSessionsRepository();
    await sessionsRepo.createSession(
      name: 'A',
      courtCount: 1,
      targetPoints: 15,
    );
    await sessionsRepo.createSession(
      name: 'B',
      courtCount: 1,
      targetPoints: 15,
    );
    final ids = (await sessionsRepo.getSessions()).map((s) => s.id).toList();

    final container = ProviderContainer(
      overrides: [
        sessionsRepositoryProvider.overrideWithValue(sessionsRepo),
        sessionStateRepositoryProvider.overrideWithValue(
          FakeSessionStateRepository(),
        ),
      ],
    );
    addTearDown(container.dispose);

    await container
        .read(sessionsActionsControllerProvider.notifier)
        .delete(ids.first);

    final remaining = await sessionsRepo.getSessions();
    expect(remaining.map((s) => s.id), isNot(contains(ids.first)));
    expect(remaining, hasLength(1));
    expect(
      container.read(sessionsActionsControllerProvider).infoMessage,
      'Pelada excluída.',
    );
  });
}
