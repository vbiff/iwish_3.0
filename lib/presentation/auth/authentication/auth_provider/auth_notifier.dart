import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/models/auth/user_profile.dart';
import '../../../../domain/repository/auth/auth_repository.dart';

class AuthNotifier extends StateNotifier<UserProfile> {
  AuthNotifier(
    this._authRepository,
  ) : super(UserProfile(id: '', email: ''));

  final AuthScreenRepository _authRepository;

  void signUpUser({
    required String email,
    required String password,
  }) async {
    try {
      await _authRepository.signUpWithEmailPassowrd(email, password);
    } on Exception catch (e) {
      print(e);
    }
  }

  void loginUser({
    required email,
    required String password,
  }) async {
    try {
      await _authRepository.signInWithEmailPassowrd(email, password);
    } catch (e) {
      print(e);
    }
  }
}
