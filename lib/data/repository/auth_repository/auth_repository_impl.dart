import '../../../core/utils/logger.dart';
import '../../../domain/core/result.dart';
import '../../../domain/failures/failure.dart';
import '../../../domain/models/auth/user_profile.dart';
import '../../../domain/repository/auth_repository/auth_repository.dart';
import '../../services/auth/auth_service.dart';

final class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required this.authService});

  final AuthService authService;

  @override
  Future<Result<UserProfile, Failure>> signInWithEmailPassword(
      String email, String password) async {
    try {
      final user = await authService.signInWithEmailPassord(email, password);
      AppLogger.info('User signed in successfully');
      return Success(user);
    } catch (e) {
      AppLogger.error('Sign in failed', e);
      return Error(AuthFailure('Failed to sign in: ${e.toString()}'));
    }
  }

  @override
  Future<Result<UserProfile, Failure>> signUpWithEmailPassword(
      String email, String password) async {
    try {
      final user = await authService.signUpWithEmailPassord(email, password);
      AppLogger.info('User signed up successfully');
      return Success(user);
    } catch (e) {
      AppLogger.error('Sign up failed', e);
      return Error(AuthFailure('Failed to sign up: ${e.toString()}'));
    }
  }
}
