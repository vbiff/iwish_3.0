import '../../core/result.dart';
import '../../failures/failure.dart';

abstract interface class AuthRepository {
  Future<Result<void, Failure>> signInWithEmailPassword(
      String email, String password);
  Future<Result<void, Failure>> signUpWithEmailPassword(
      String email, String password);
}
