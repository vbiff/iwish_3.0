import '../../../domain/repository/auth/auth_repository.dart';
import '../../auth/auth_service.dart';

final class AuthScreenRepositoryImpl implements AuthScreenRepository {
  @override
  Future<void> signInWithEmailPassowrd(String email, String password) async {
    try {
      await AuthService().signInWithEmailPassord(email, password);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signUpWithEmailPassowrd(String email, String password) async {
    try {
      await AuthService().signUpWithEmailPassord(email, password);
    } catch (e) {
      rethrow;
    }
  }
}
