abstract class Failure {
  const Failure(this.message);
  final String message;

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
