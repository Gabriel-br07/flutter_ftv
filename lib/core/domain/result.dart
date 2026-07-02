/// Lightweight result and error types for domain-level validation.
///
/// Services return a [Result] (or a result object carrying [DomainError]s) for
/// *expected* operational failures — for example, trying to manually pair a
/// player who is already playing. Hard invariants that represent programming
/// errors (an invalid target-points value, a blank session name) are enforced
/// in factory constructors that throw [ArgumentError] instead.
library;

/// A recoverable, expected domain failure. Prefer this over throwing for
/// validation outcomes the caller is expected to handle.
class DomainError {
  const DomainError(this.code, this.message);

  /// A stable, machine-readable code (e.g. `player_not_queued`).
  final String code;

  /// A human-readable, developer-facing description of the failure.
  final String message;

  @override
  String toString() => 'DomainError($code): $message';

  @override
  bool operator ==(Object other) =>
      other is DomainError && other.code == code && other.message == message;

  @override
  int get hashCode => Object.hash(code, message);
}

/// The outcome of an operation that can either succeed with a value of type [T]
/// or fail with a [DomainError].
sealed class Result<T> {
  const Result();

  /// Whether this result represents a success.
  bool get isSuccess => this is Success<T>;

  /// Whether this result represents a failure.
  bool get isFailure => this is Failure<T>;

  /// The success value, or `null` if this is a [Failure].
  T? get valueOrNull => switch (this) {
    Success<T>(:final value) => value,
    Failure<T>() => null,
  };

  /// The error, or `null` if this is a [Success].
  DomainError? get errorOrNull => switch (this) {
    Success<T>() => null,
    Failure<T>(:final error) => error,
  };
}

/// A successful [Result] wrapping a [value].
class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;

  @override
  bool operator ==(Object other) => other is Success<T> && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// A failed [Result] wrapping a [DomainError].
class Failure<T> extends Result<T> {
  const Failure(this.error);

  final DomainError error;

  @override
  bool operator ==(Object other) => other is Failure<T> && other.error == error;

  @override
  int get hashCode => error.hashCode;
}
