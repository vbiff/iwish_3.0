import '../../../domain/repository/auth/auth_repository.dart';
import '../../services/auth/auth_service.dart';

final class AuthScreenRepositoryImpl implements AuthScreenRepository {
  AuthScreenRepositoryImpl({required this.authService});

  final AuthService authService;

  @override
  Future<void> signInWithEmailPassowrd(String email, String password) async {
    try {
      await authService.signInWithEmailPassord(email, password);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signUpWithEmailPassowrd(String email, String password) async {
    try {
      await authService.signUpWithEmailPassord(email, password);
    } catch (e) {
      rethrow;
    }
  }
}
