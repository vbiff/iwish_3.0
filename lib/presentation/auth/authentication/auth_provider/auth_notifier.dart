import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/logger.dart';
import '../../../../domain/core/result.dart';
import '../../../../domain/models/auth/user_profile.dart';
import '../../../../domain/repository/auth_repository/auth_repository.dart';

// Auth State Model
class AuthState {
  final UserProfile? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    UserProfile? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(
    this._authRepository,
  ) : super(const AuthState());

  final AuthRepository _authRepository;

  Future<void> signUpUser({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result =
          await _authRepository.signUpWithEmailPassword(email, password);
      result.fold(
        (user) {
          AppLogger.info('User signed up successfully');
          state = state.copyWith(
            isLoading: false,
            user: user,
            isAuthenticated: true,
            error: null,
          );
        },
        (failure) {
          AppLogger.error('Sign up failed: ${failure.message}');
          state = state.copyWith(
            isLoading: false,
            error: _getErrorMessage(failure.message),
          );
        },
      );
    } catch (e) {
      AppLogger.error('Sign up error: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    print('[AUTH DEBUG] Starting login for email: $email');
    state = state.copyWith(isLoading: true, error: null);

    try {
      print('[AUTH DEBUG] Calling auth repository...');
      final result =
          await _authRepository.signInWithEmailPassword(email, password);
      result.fold(
        (user) {
          print('[AUTH DEBUG] Login successful! User: ${user.email}');
          AppLogger.info('User logged in successfully');
          state = state.copyWith(
            isLoading: false,
            user: user,
            isAuthenticated: true,
            error: null,
          );
          print(
              '[AUTH DEBUG] State updated - isAuthenticated: ${state.isAuthenticated}');
        },
        (failure) {
          print('[AUTH DEBUG] Login failed: ${failure.message}');
          AppLogger.error('Login failed: ${failure.message}');
          state = state.copyWith(
            isLoading: false,
            error: _getErrorMessage(failure.message),
          );
        },
      );
    } catch (e) {
      print('[AUTH DEBUG] Login exception: $e');
      AppLogger.error('Login error: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void signOut() {
    state = const AuthState();
  }

  String _getErrorMessage(String error) {
    if (error.contains('Invalid login credentials') ||
        error.contains('invalid_credentials')) {
      return 'Invalid email or password. Please check your credentials and try again.';
    }

    if (error.contains('Email not confirmed')) {
      return 'Please check your email and confirm your account before signing in.';
    }

    if (error.contains('User already registered')) {
      return 'An account with this email already exists. Please sign in instead.';
    }

    if (error.contains('Password should be at least')) {
      return 'Password must be at least 6 characters long.';
    }

    if (error.contains('Invalid email')) {
      return 'Please enter a valid email address.';
    }

    if (error.contains('Network')) {
      return 'Network error. Please check your connection and try again.';
    }

    // Default error message
    return 'Something went wrong. Please try again.';
  }
}
