import 'package:flutter/material.dart';
import 'package:flutter_ftv/core/utils/labels.dart';
import 'package:flutter_ftv/features/sessions/domain/session_status.dart';

/// A chip showing a session's lifecycle status (Rascunho / Em andamento /
/// Finalizada) with a matching icon. Shared by the sessions list and the courts
/// screen header so the status→style mapping lives in one place. Colors come
/// from [ColorScheme] roles (good contrast); the icon + text label mean the
/// state never depends on color alone.
class SessionStatusChip extends StatelessWidget {
  const SessionStatusChip({required this.status, super.key});

  final SessionStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (Color bg, Color fg, IconData icon) = switch (status) {
      SessionStatus.draft => (
        scheme.surfaceContainerHighest,
        scheme.onSurfaceVariant,
        Icons.edit_note,
      ),
      SessionStatus.active => (
        scheme.primaryContainer,
        scheme.onPrimaryContainer,
        Icons.play_circle_outline,
      ),
      SessionStatus.finished => (
        scheme.secondaryContainer,
        scheme.onSecondaryContainer,
        Icons.flag_outlined,
      ),
    };
    return Chip(
      avatar: Icon(icon, size: 18, color: fg),
      label: Text(Labels.sessionStatus(status)),
      backgroundColor: bg,
      labelStyle: TextStyle(color: fg, fontWeight: FontWeight.w600),
      side: BorderSide.none,
    );
  }
}
