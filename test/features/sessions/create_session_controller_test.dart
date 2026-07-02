import 'package:flutter_ftv/app/providers.dart';
import 'package:flutter_ftv/features/sessions/presentation/sessions_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fakes.dart';

void main() {
  ProviderContainer makeContainer(FakeSessionsRepository repo) {
    final container = ProviderContainer(
      overrides: [sessionsRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('should_reject_blank_session_name', () async {
    final container = makeContainer(FakeSessionsRepository());
    final controller = container.read(createSessionControllerProvider.notifier);

    final session = await controller.submit(
      name: '   ',
      courtCount: 2,
      targetPoints: 15,
    );

    expect(session, isNull);
    expect(
      container.read(createSessionControllerProvider).errorMessage,
      'Informe o nome da pelada',
    );
  });

  test('should_reject_invalid_target_points', () async {
    final container = makeContainer(FakeSessionsRepository());
    final controller = container.read(createSessionControllerProvider.notifier);

    final session = await controller.submit(
      name: 'Pelada',
      courtCount: 2,
      targetPoints: 21,
    );

    expect(session, isNull);
    expect(
      container.read(createSessionControllerProvider).errorMessage,
      'Escolha uma pontuação válida',
    );
  });

  test('should_create_session_when_input_is_valid', () async {
    final repo = FakeSessionsRepository();
    final container = makeContainer(repo);
    final controller = container.read(createSessionControllerProvider.notifier);

    final session = await controller.submit(
      name: 'Pelada da Praia',
      courtCount: 3,
      targetPoints: 18,
    );

    expect(session, isNotNull);
    expect(session!.name, 'Pelada da Praia');
    expect(session.courtCount, 3);
    expect(await repo.getSessions(), hasLength(1));
  });
}
