import '../../../domain/models/auth/user_profile.dart';
import '../../../domain/repository/auth/profile_repository.dart';
import '../../services/auth/profile_service.dart';

final class ProfileScreenRepositoryImpl implements ProfileScreenRepository {
  ProfileScreenRepositoryImpl({required this.profileService});

  final ProfileService profileService;

  @override
  Future<void> signOut() async {
    try {
      await profileService.signOut();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserProfile> getProfile() async {
    try {
      return await profileService.getUserProfile();
    } catch (e) {
      throw Error;
    }
  }
}
