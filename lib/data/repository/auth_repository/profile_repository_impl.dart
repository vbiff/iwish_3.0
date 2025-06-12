import '../../../core/utils/logger.dart';
import '../../../domain/core/result.dart';
import '../../../domain/failures/failure.dart';
import '../../../domain/models/auth/user_profile.dart';
import '../../../domain/repository/auth_repository/profile_repository.dart';
import '../../services/auth/profile_service.dart';

final class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({required this.profileService});

  final ProfileService profileService;

  @override
  Future<Result<void, Failure>> signOut() async {
    try {
      await profileService.signOut();
      AppLogger.info('User signed out successfully');
      return const Success(null);
    } catch (e) {
      AppLogger.error('Sign out failed', e);
      return Error(AuthFailure('Failed to sign out: ${e.toString()}'));
    }
  }

  @override
  Future<Result<UserProfile, Failure>> getProfile() async {
    try {
      final profile = await profileService.getUserProfile();
      AppLogger.info('Profile retrieved successfully');
      return Success(profile);
    } catch (e) {
      AppLogger.error('Get profile failed', e);
      return Error(AuthFailure('Failed to get profile: ${e.toString()}'));
    }
  }
}
