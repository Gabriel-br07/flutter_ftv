import 'package:drift/drift.dart';

// Selects a platform-specific implementation so the ffi import
// (`package:drift/native.dart`) never reaches a web build.
import 'test_database_io.dart'
    if (dart.library.js_interop) 'test_database_web.dart'
    as impl;

/// Returns an isolated in-memory Drift executor for E2E tests, or `null` when
/// no isolated executor is available for the platform (web), in which case the
/// app's real database is used and tests rely on unique session names.
QueryExecutor? openInMemoryExecutor() => impl.openInMemoryExecutor();
