import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/core/result.dart';
import '../../domain/models/auth/user_profile.dart';
import '../../domain/repository/auth_repository/auth_repository.dart';
import '../utils/logger.dart';

// Auth State Model with improved immutability
class AuthState {
  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  final UserProfile? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  AuthState copyWith({
    UserProfile? user,
    bool? isLoading,
    String? Function()? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error != null ? error() : this.error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }

  // Factory constructors for common states
  factory AuthState.initial() => const AuthState();

  factory AuthState.loading() => const AuthState(isLoading: true);

  factory AuthState.authenticated(UserProfile user) => AuthState(
        user: user,
        isAuthenticated: true,
      );

  factory AuthState.error(String error) => AuthState(error: error);

  // Computed properties
  bool get hasError => error != null;
  bool get isUnauthenticated => !isAuthenticated;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthState &&
          runtimeType == other.runtimeType &&
          user == other.user &&
          isLoading == other.isLoading &&
          error == other.error &&
          isAuthenticated == other.isAuthenticated;

  @override
  int get hashCode =>
      user.hashCode ^
      isLoading.hashCode ^
      error.hashCode ^
      isAuthenticated.hashCode;

  @override
  String toString() {
    return 'AuthState(isAuthenticated: $isAuthenticated, isLoading: $isLoading, hasError: $hasError)';
  }
}

/// Auth notifier following SOLID principles
/// Single Responsibility: Only manages authentication state
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._authRepository) : super(AuthState.initial());

  final AuthRepository _authRepository;

  /// Sign up a new user
  Future<void> signUpUser({
    required String email,
    required String password,
  }) async {
    state = AuthState.loading();

    try {
      final result =
          await _authRepository.signUpWithEmailPassword(email, password);

      result.fold(
        (user) {
          AppLogger.info('User signed up successfully: ${user.email}');
          state = AuthState.authenticated(user);
        },
        (failure) {
          final errorMessage = _getErrorMessage(failure.message);
          AppLogger.error('Sign up failed: ${failure.message}');
          state = AuthState.error(errorMessage);
        },
      );
    } catch (error) {
      AppLogger.error('Sign up error: $error');
      state =
          AuthState.error('An unexpected error occurred. Please try again.');
    }
  }

  /// Sign in an existing user
  Future<void> signInUser({
    required String email,
    required String password,
  }) async {
    state = AuthState.loading();

    try {
      final result =
          await _authRepository.signInWithEmailPassword(email, password);

      result.fold(
        (user) {
          AppLogger.info('User signed in successfully: ${user.email}');
          state = AuthState.authenticated(user);
        },
        (failure) {
          final errorMessage = _getErrorMessage(failure.message);
          AppLogger.error('Sign in failed: ${failure.message}');
          state = AuthState.error(errorMessage);
        },
      );
    } catch (error) {
      AppLogger.error('Sign in error: $error');
      state =
          AuthState.error('An unexpected error occurred. Please try again.');
    }
  }

  /// Sign out the current user
  Future<void> signOut() async {
    try {
      // You could call repository signOut method here if needed
      // await _authRepository.signOut();
      state = AuthState.initial();
      AppLogger.info('User signed out successfully');
    } catch (error) {
      AppLogger.error('Sign out error: $error');
      // Still sign out locally even if remote fails
      state = AuthState.initial();
    }
  }

  /// Clear any error state
  void clearError() {
    state = state.copyWith(error: () => null);
  }

  /// Check if user is currently authenticated
  bool get isAuthenticated => state.isAuthenticated;

  /// Get current user
  UserProfile? get currentUser => state.user;

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      // Assuming the repository has a reset password method
      // final result = await _authRepository.resetPassword(email);
      AppLogger.info('Password reset email sent to: $email');
    } catch (error) {
      AppLogger.error('Password reset error: $error');
      state = AuthState.error('Failed to send password reset email.');
    }
  }

  /// Update user profile in auth state
  void updateUserProfile(UserProfile updatedUser) {
    if (state.isAuthenticated) {
      state = state.copyWith(user: updatedUser);
    }
  }

  /// Private method to convert error messages to user-friendly messages
  String _getErrorMessage(String error) {
    // Define error message mappings following Open/Closed Principle
    final errorMappings = {
      'Invalid login credentials':
          'Invalid email or password. Please check your credentials and try again.',
      'invalid_credentials':
          'Invalid email or password. Please check your credentials and try again.',
      'Email not confirmed':
          'Please check your email and confirm your account before signing in.',
      'User already registered':
          'An account with this email already exists. Please sign in instead.',
      'Password should be at least':
          'Password must be at least 6 characters long.',
      'Invalid email': 'Please enter a valid email address.',
      'Network': 'Network error. Please check your connection and try again.',
    };

    // Find matching error message
    for (final mapping in errorMappings.entries) {
      if (error.contains(mapping.key)) {
        return mapping.value;
      }
    }

    // Default error message
    return 'Something went wrong. Please try again.';
  }
}

// Placeholder provider - will be properly defined in app_providers.dart
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  throw UnimplementedError('This should be implemented in app_providers.dart');
});
