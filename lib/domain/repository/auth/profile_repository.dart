import '../../models/auth/user_profile.dart';

abstract class ProfileScreenRepository {
  Future<UserProfile> getProfile();
  Future<void> signOut();
}
