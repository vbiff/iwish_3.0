import '../../core/result.dart';
import '../../failures/failure.dart';
import '../../models/auth/user_profile.dart';

abstract interface class AuthRepository {
  Future<Result<UserProfile, Failure>> signInWithEmailPassword(
      String email, String password);
  Future<Result<UserProfile, Failure>> signUpWithEmailPassword(
      String email, String password);
}
