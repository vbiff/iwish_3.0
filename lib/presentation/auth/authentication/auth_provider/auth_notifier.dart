import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/logger.dart';
import '../../../../domain/core/result.dart';
import '../../../../domain/models/auth/user_profile.dart';
import '../../../../domain/repository/auth_repository/auth_repository.dart';

class AuthNotifier extends StateNotifier<UserProfile> {
  AuthNotifier(
    this._authRepository,
  ) : super(UserProfile(id: '', email: ''));

  final AuthRepository _authRepository;

  void signUpUser({
    required String email,
    required String password,
  }) async {
    final result =
        await _authRepository.signUpWithEmailPassword(email, password);
    result.fold(
      (_) => AppLogger.info('User signed up successfully'),
      (failure) => AppLogger.error('Sign up failed: ${failure.message}'),
    );
  }

  void loginUser({
    required email,
    required String password,
  }) async {
    final result =
        await _authRepository.signInWithEmailPassword(email, password);
    result.fold(
      (_) => AppLogger.info('User logged in successfully'),
      (failure) => AppLogger.error('Login failed: ${failure.message}'),
    );
  }
}
