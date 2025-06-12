import '../failures/failure.dart';

sealed class Result<T, F extends Failure> {
  const Result();
}

class Success<T, F extends Failure> extends Result<T, F> {
  const Success(this.value);
  final T value;
}

class Error<T, F extends Failure> extends Result<T, F> {
  const Error(this.failure);
  final F failure;
}

extension ResultExtension<T, F extends Failure> on Result<T, F> {
  bool get isSuccess => this is Success<T, F>;
  bool get isError => this is Error<T, F>;

  T? get value => switch (this) {
        Success(value: final value) => value,
        Error() => null,
      };

  F? get failure => switch (this) {
        Success() => null,
        Error(failure: final failure) => failure,
      };

  R fold<R>(
    R Function(T value) onSuccess,
    R Function(F failure) onError,
  ) {
    return switch (this) {
      Success(value: final value) => onSuccess(value),
      Error(failure: final failure) => onError(failure),
    };
  }
}
