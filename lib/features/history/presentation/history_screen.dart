import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ftv/core/utils/labels.dart';
import 'package:flutter_ftv/features/history/presentation/history_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Chronological history of a session (newest first), described in Portuguese.
class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({required this.sessionId, super.key});

  final String sessionId;

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(
      Future.microtask(
        () =>
            ref.read(historyControllerProvider.notifier).load(widget.sessionId),
      ),
    );
  }

  String _time(DateTime time) {
    String two(int value) => value.toString().padLeft(2, '0');
    return '${two(time.hour)}:${two(time.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final historyState = ref.watch(historyControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico')),
      body: SafeArea(
        child: historyState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : historyState.events.isEmpty
            ? Center(
                child: Text(
                  'Nenhum evento registrado',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              )
            : ListView.separated(
                key: const Key('historyScreen'),
                padding: const EdgeInsets.all(16),
                itemCount: historyState.events.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final event = historyState.events[index];
                  return ListTile(
                    leading: const Icon(Icons.event_note),
                    title: Text(Labels.historyEventLabel(event.type)),
                    trailing: Text(_time(event.createdAt)),
                  );
                },
              ),
      ),
    );
  }
}
