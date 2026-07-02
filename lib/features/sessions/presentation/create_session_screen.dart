import 'package:flutter/material.dart';
import 'package:flutter_ftv/features/sessions/presentation/sessions_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Form to create a new session (name, court count, target points).
class CreateSessionScreen extends ConsumerStatefulWidget {
  const CreateSessionScreen({super.key});

  @override
  ConsumerState<CreateSessionScreen> createState() =>
      _CreateSessionScreenState();
}

class _CreateSessionScreenState extends ConsumerState<CreateSessionScreen> {
  final _nameController = TextEditingController();
  int _courtCount = 2;
  int _targetPoints = 15;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final session = await ref
        .read(createSessionControllerProvider.notifier)
        .submit(
          name: _nameController.text,
          courtCount: _courtCount,
          targetPoints: _targetPoints,
        );
    if (!mounted) return;
    if (session != null) {
      context.go('/sessions/${session.id.value}/players');
      return;
    }
    final message = ref.read(createSessionControllerProvider).errorMessage;
    if (message != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting = ref.watch(
      createSessionControllerProvider.select((s) => s.isSubmitting),
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Criar pelada')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              key: const Key('sessionNameField'),
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Nome da pelada',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Quantidade de quadras',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            _CourtCountStepper(
              value: _courtCount,
              onChanged: (value) => setState(() => _courtCount = value),
            ),
            const SizedBox(height: 24),
            Text('Pontuação', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(
                  value: 15,
                  label: Text('15 pontos', key: Key('targetPoints15Option')),
                ),
                ButtonSegment(
                  value: 18,
                  label: Text('18 pontos', key: Key('targetPoints18Option')),
                ),
              ],
              selected: {_targetPoints},
              onSelectionChanged: (selection) =>
                  setState(() => _targetPoints = selection.first),
            ),
            const SizedBox(height: 32),
            FilledButton(
              key: const Key('createSessionSubmitButton'),
              onPressed: isSubmitting ? null : _submit,
              child: isSubmitting
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Criar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CourtCountStepper extends StatelessWidget {
  const _CourtCountStepper({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton.filledTonal(
          key: const Key('courtCountDecrementButton'),
          onPressed: value > 1 ? () => onChanged(value - 1) : null,
          iconSize: 32,
          icon: const Icon(Icons.remove),
        ),
        Expanded(
          child: Text(
            '$value',
            key: const Key('courtCountField'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        IconButton.filledTonal(
          key: const Key('courtCountIncrementButton'),
          onPressed: () => onChanged(value + 1),
          iconSize: 32,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
