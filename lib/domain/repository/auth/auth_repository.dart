abstract interface class AuthScreenRepository {
  Future<void> signInWithEmailPassowrd(String email, String password);
  Future<void> signUpWithEmailPassowrd(String email, String password);
}
