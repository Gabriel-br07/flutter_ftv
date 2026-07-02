import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ftv/app/providers.dart';
import 'package:flutter_ftv/core/theme/session_status_chip.dart';
import 'package:flutter_ftv/core/utils/labels.dart';
import 'package:flutter_ftv/features/sessions/domain/session.dart';
import 'package:flutter_ftv/features/sessions/domain/session_status.dart';
import 'package:flutter_ftv/features/sessions/presentation/sessions_actions_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Lists all sessions (peladas), routes into one based on its status, and
/// exposes per-item actions (finish an active session, delete a finished one).
class SessionsListScreen extends ConsumerWidget {
  const SessionsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(sessionsActionsControllerProvider, (previous, next) {
      final message = next.infoMessage ?? next.errorMessage;
      if (message != null) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(SnackBar(content: Text(message)));
        ref.read(sessionsActionsControllerProvider.notifier).clearMessages();
      }
    });

    final sessionsAsync = ref.watch(sessionsListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Peladas')),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('sessionsCreateButton'),
        onPressed: () => context.go('/sessions/new'),
        icon: const Icon(Icons.add),
        label: const Text('Criar pelada'),
      ),
      body: sessionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) =>
            const Center(child: Text('Não foi possível carregar as peladas')),
        data: (sessions) {
          if (sessions.isEmpty) {
            return const _EmptyState();
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sessions.length,
            itemBuilder: (context, index) =>
                _SessionTile(session: sessions[index]),
          );
        },
      ),
    );
  }
}

class _SessionTile extends ConsumerWidget {
  const _SessionTile({required this.session});

  final Session session;

  void _open(BuildContext context) {
    final destination = switch (session.status) {
      SessionStatus.draft => 'players',
      SessionStatus.active => 'courts',
      SessionStatus.finished => 'history',
    };
    context.go('/sessions/${session.id.value}/$destination');
  }

  Future<void> _confirmFinish(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Finalizar pelada?'),
        content: const Text(
          'Depois de finalizar, você ainda poderá ver esta pelada na lista e '
          'excluí-la quando quiser.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            key: const Key('confirmFinishButton'),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Finalizar'),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await ref
          .read(sessionsActionsControllerProvider.notifier)
          .finish(session.id);
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir pelada?'),
        content: const Text(
          'Essa ação vai remover esta pelada e seus participantes deste '
          'aparelho. Essa ação não poderá ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            key: const Key('confirmDeleteButton'),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await ref
          .read(sessionsActionsControllerProvider.notifier)
          .delete(session.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _open(context),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 12, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      session.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SessionStatusChip(status: session.status),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${Labels.targetPoints(session.targetPoints)}  •  '
                '${Labels.courtCount(session.courtCount)}',
              ),
              _buildAction(context, ref),
            ],
          ),
        ),
      ),
    );
  }

  /// The single contextual action shown directly on the card: "Finalizar" for an
  /// active pelada (tonal, secondary emphasis) and a destructive "Excluir" for a
  /// finished one (error color + icon + label). Drafts show nothing.
  Widget _buildAction(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final Widget? action = switch (session.status) {
      SessionStatus.active => FilledButton.tonalIcon(
        key: Key('finishSessionButton-${session.id.value}'),
        onPressed: () => unawaited(_confirmFinish(context, ref)),
        icon: const Icon(Icons.flag_outlined, size: 20),
        label: const Text('Finalizar'),
      ),
      SessionStatus.finished => TextButton.icon(
        key: Key('deleteSessionButton-${session.id.value}'),
        onPressed: () => unawaited(_confirmDelete(context, ref)),
        style: TextButton.styleFrom(foregroundColor: scheme.error),
        icon: const Icon(Icons.delete_outline, size: 20),
        label: const Text('Excluir'),
      ),
      SessionStatus.draft => null,
    };
    if (action == null) return const SizedBox(height: 4);
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(padding: const EdgeInsets.only(top: 4), child: action),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sports_volleyball, size: 72),
            SizedBox(height: 16),
            Text(
              'Nenhuma pelada criada',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
