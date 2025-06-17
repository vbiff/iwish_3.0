import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/core/result.dart';
import '../../domain/models/auth/user_profile.dart';
import '../../domain/repository/auth_repository/profile_repository.dart';
import '../utils/logger.dart';

/// Profile notifier following SOLID principles
/// Single Responsibility: Only manages user profile state
class ProfileNotifier extends StateNotifier<UserProfile> {
  ProfileNotifier(this._profileRepository) : super(_emptyProfile);

  final ProfileRepository _profileRepository;

  static const _emptyProfile = UserProfile(id: '', email: '');

  /// Initialize profile from repository
  Future<void> initialize() async {
    try {
      final result = await _profileRepository.getProfile();

      result.fold(
        (profile) {
          state = profile;
          AppLogger.info('Profile initialized successfully: ${profile.email}');
        },
        (failure) {
          AppLogger.error('Failed to initialize profile: ${failure.message}');
          // Keep empty profile state on failure
        },
      );
    } catch (error) {
      AppLogger.error('Profile initialization error: $error');
    }
  }

  /// Update profile information locally
  /// Note: Since the repository doesn't have updateProfile method,
  /// this only updates local state
  void updateProfile({
    String? name,
    String? phone,
    String? birthday,
  }) {
    try {
      final updatedProfile = state.copyWith(
        name: name,
        phone: phone,
        birthday: birthday,
      );

      state = updatedProfile;
      AppLogger.info('Profile updated locally');
    } catch (error) {
      AppLogger.error('Profile update error: $error');
    }
  }

  /// Update profile photo
  Future<void> updateProfilePhoto(String imagePath) async {
    try {
      final result = await _profileRepository.updateProfilePhoto(imagePath);

      result.fold(
        (photoUrl) {
          state = state.copyWith(avatarPhoto: photoUrl);
          AppLogger.info('Profile photo updated successfully: $photoUrl');
        },
        (failure) {
          AppLogger.error('Failed to update profile photo: ${failure.message}');
          throw failure;
        },
      );
    } catch (error) {
      AppLogger.error('Profile photo update error: $error');
      rethrow;
    }
  }

  /// Sign out user (clear profile)
  Future<void> signOut() async {
    try {
      final result = await _profileRepository.signOut();

      result.fold(
        (_) {
          state = _emptyProfile;
          AppLogger.info('User signed out successfully');
        },
        (failure) {
          AppLogger.error('Sign out failed: ${failure.message}');
          // Still clear profile locally
          state = _emptyProfile;
        },
      );
    } catch (error) {
      AppLogger.error('Sign out error: $error');
      // Still clear profile locally
      state = _emptyProfile;
    }
  }

  /// Clear profile data
  void clear() {
    state = _emptyProfile;
  }

  /// Refresh profile from server
  Future<void> refresh() async {
    await initialize();
  }

  /// Check if profile is complete
  bool get isProfileComplete {
    return state.name != null &&
        state.name!.isNotEmpty &&
        state.email.isNotEmpty;
  }

  /// Check if profile has avatar
  bool get hasAvatar {
    return state.avatarPhoto != null && state.avatarPhoto!.isNotEmpty;
  }

  /// Get display name (name or email)
  String get displayName {
    if (state.name != null && state.name!.isNotEmpty) {
      return state.name!;
    }
    return state.email;
  }

  /// Get user initials for avatar
  String get userInitials {
    final name = displayName;
    if (name.isEmpty) return '';

    final words = name.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    } else if (words.isNotEmpty) {
      return words[0][0].toUpperCase();
    }
    return '';
  }
}
