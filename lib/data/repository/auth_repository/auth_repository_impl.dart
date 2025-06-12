import '../../../core/utils/logger.dart';
import '../../../domain/core/result.dart';
import '../../../domain/failures/failure.dart';
import '../../../domain/repository/auth_repository/auth_repository.dart';
import '../../services/auth/auth_service.dart';

final class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required this.authService});

  final AuthService authService;

  @override
  Future<Result<void, Failure>> signInWithEmailPassword(
      String email, String password) async {
    try {
      await authService.signInWithEmailPassord(email, password);
      AppLogger.info('User signed in successfully');
      return const Success(null);
    } catch (e) {
      AppLogger.error('Sign in failed', e);
      return Error(AuthFailure('Failed to sign in: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void, Failure>> signUpWithEmailPassword(
      String email, String password) async {
    try {
      await authService.signUpWithEmailPassord(email, password);
      AppLogger.info('User signed up successfully');
      return const Success(null);
    } catch (e) {
      AppLogger.error('Sign up failed', e);
      return Error(AuthFailure('Failed to sign up: ${e.toString()}'));
    }
  }
}
