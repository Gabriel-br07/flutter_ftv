import 'package:flutter/material.dart';
import 'package:flutter_ftv/features/players/domain/participant_import.dart';

/// Opens the "Importar participantes" modal bottom sheet. Returns the parsed
/// list of names when the organizer confirms, or `null` if they cancel.
///
/// [existingNames] are the names already registered, used only to flag likely
/// duplicates in the preview (the actual de-duplication happens on import).
Future<List<String>?> showImportParticipantsSheet(
  BuildContext context, {
  required List<String> existingNames,
}) {
  return showModalBottomSheet<List<String>>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) =>
        _ImportParticipantsSheet(existingNames: existingNames),
  );
}

class _ImportParticipantsSheet extends StatefulWidget {
  const _ImportParticipantsSheet({required this.existingNames});

  final List<String> existingNames;

  @override
  State<_ImportParticipantsSheet> createState() =>
      _ImportParticipantsSheetState();
}

class _ImportParticipantsSheetState extends State<_ImportParticipantsSheet> {
  final _controller = TextEditingController();
  List<String> _names = const [];

  late final Set<String> _existing = {
    for (final n in widget.existingNames) n.trim().toLowerCase(),
  };

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) =>
      setState(() => _names = parseParticipantNames(value));

  void _clear() {
    _controller.clear();
    _onChanged('');
  }

  /// Whether the name at [index] duplicates an existing participant or an
  /// earlier name in the parsed list (case-insensitive).
  bool _isDuplicate(int index) {
    final normalized = _names[index].trim().toLowerCase();
    if (_existing.contains(normalized)) return true;
    for (var i = 0; i < index; i++) {
      if (_names[i].trim().toLowerCase() == normalized) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final hasText = _controller.text.trim().isNotEmpty;

    return Padding(
      // Lift the sheet above the keyboard.
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Importar participantes', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Cole a lista de nomes abaixo. Use um nome por linha. Exemplo:',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '1. Luan\n2. Lucas\n3. Felipe\n4. Gabriel',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('importTextField'),
              controller: _controller,
              onChanged: _onChanged,
              maxLines: 6,
              minLines: 4,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                hintText: 'Cole aqui a lista de participantes...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            _Preview(
              names: _names,
              hasText: hasText,
              isDuplicate: _isDuplicate,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                TextButton(
                  key: const Key('importCancelButton'),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                const Spacer(),
                TextButton(
                  key: const Key('importClearButton'),
                  onPressed: hasText ? _clear : null,
                  child: const Text('Limpar'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            FilledButton(
              key: const Key('importConfirmButton'),
              onPressed: _names.isEmpty
                  ? null
                  : () => Navigator.pop(context, _names),
              child: const Text('Adicionar participantes'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview({
    required this.names,
    required this.hasText,
    required this.isDuplicate,
  });

  final List<String> names;
  final bool hasText;
  final bool Function(int index) isDuplicate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    if (names.isEmpty) {
      if (!hasText) return const SizedBox.shrink();
      return Text(
        'Nenhum nome válido encontrado. Confira se existe um nome por linha.',
        style: theme.textTheme.bodyMedium?.copyWith(color: scheme.error),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          names.length == 1
              ? '1 participante encontrado:'
              : '${names.length} participantes encontrados:',
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        // Cap the preview height so a large paste keeps the confirm button
        // reachable; the names scroll within this bounded area. A fixed height
        // is safe inside the sheet's outer SingleChildScrollView.
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 240),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: names.length,
            itemBuilder: (context, i) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Icon(Icons.person, size: 18, color: scheme.onSurfaceVariant),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      names[i],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isDuplicate(i))
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'duplicado',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
