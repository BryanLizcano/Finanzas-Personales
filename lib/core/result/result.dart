sealed class Result<T, E> {
  const Result();

  const factory Result.ok(T value) = Success<T, E>;
  const factory Result.error(E error) = Error<T, E>;

  bool get isOk => this is Success<T, E>;
  bool get isError => this is Error<T, E>;

  T? get valueOrNull => switch (this) {
    Success(:final value) => value,
    Error() => null,
  };

  E? get errorOrNull => switch (this) {
    Success() => null,
    Error(:final error) => error,
  };

  R fold<R>({
    required R Function(T value) onOk,
    required R Function(E error) onError,
  }) => switch (this) {
    Success(:final value) => onOk(value),
    Error(:final error) => onError(error),
  };
}

class Success<T, E> extends Result<T, E> {
  final T value;
  const Success(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T, E> &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Result.ok($value)';
}

class Error<T, E> extends Result<T, E> {
  final E error;
  const Error(this.error);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Error<T, E> &&
          runtimeType == other.runtimeType &&
          error == other.error;

  @override
  int get hashCode => error.hashCode;

  @override
  String toString() => 'Result.error($error)';
}
