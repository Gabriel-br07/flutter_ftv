import 'package:drift/drift.dart';
import 'package:drift/native.dart';

/// Native (mobile/desktop/flutter_tester) executor: a fresh in-memory SQLite
/// database, giving each test a clean, isolated store.
QueryExecutor? openInMemoryExecutor() => NativeDatabase.memory();
