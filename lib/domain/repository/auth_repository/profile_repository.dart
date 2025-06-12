import '../../core/result.dart';
import '../../failures/failure.dart';
import '../../models/auth/user_profile.dart';

abstract class ProfileRepository {
  Future<Result<UserProfile, Failure>> getProfile();
  Future<Result<void, Failure>> signOut();
}
