import '../../../domain/models/auth/user_profile.dart';
import '../../../domain/repository/auth/profile_repository.dart';
import '../../auth/profile_service.dart';

final class ProfileScreenRepositoryImpl implements ProfileScreenRepository {
  @override
  Future<void> signOut() async {
    try {
      await ProfileService().signOut();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserProfile> getProfile() async {
    try {
      return await ProfileService().getUserProfile();
    } catch (e) {
      throw Error;
    }
  }
}
