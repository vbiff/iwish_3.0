import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/logger.dart';
import '../../../../domain/core/result.dart';
import '../../../../domain/models/auth/user_profile.dart';
import '../../../../domain/repository/auth_repository/profile_repository.dart';

class ProfileNotifier extends StateNotifier<UserProfile> {
  ProfileNotifier(this._profileRepository)
      : super(UserProfile(id: '', email: ''));

  final ProfileRepository _profileRepository;

  Future<void> initialize() async {
    final result = await _profileRepository.getProfile();
    result.fold(
      (user) {
        state = state.copyWith(
          id: user.id,
          email: user.email,
          name: user.name,
          phone: user.phone,
          birthday: user.birthday,
          avatarPhoto: user.avatarPhoto,
        );
        AppLogger.info('Profile initialized successfully');
      },
      (failure) {
        AppLogger.error('Failed to initialize profile: ${failure.message}');
      },
    );
  }

  void logoutUser() async {
    final result = await _profileRepository.signOut();
    result.fold(
      (_) => AppLogger.info('User logged out successfully'),
      (failure) => AppLogger.error('Logout failed: ${failure.message}'),
    );
  }
}
