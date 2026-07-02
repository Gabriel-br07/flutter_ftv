import 'package:drift/drift.dart';

/// On web there is no ffi-based in-memory executor; return `null` so the app's
/// default (drift_flutter) database is used. Tests stay isolated by creating
/// uniquely named sessions per run.
QueryExecutor? openInMemoryExecutor() => null;
