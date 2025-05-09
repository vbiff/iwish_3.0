import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_wish/data/repository/auth/profile_repository_impl.dart';
import 'package:i_wish/domain/models/auth/user_profile.dart';
import 'package:i_wish/domain/repository/auth/profile_repository.dart';

class ProfileNotifier extends StateNotifier<UserProfile> {
  ProfileNotifier(this._authRepository) : super(UserProfile(id: '', email: ''));

  final ProfileScreenRepository _authRepository;

  Future<void> initialize() async {
    try {
      final user = await _authRepository.getProfile();
      state = state.copyWith(
        id: user.id,
        email: user.email,
        name: user.name,
        phone: user.phone,
        birthday: user.birthday,
        avatarPhoto: user.avatarPhoto,
      );
    } catch (e) {
      print(e);
    }
  }

  void logoutUser() async {
    try {
      await _authRepository.signOut();
    } on Exception catch (e) {
      print(e);
    }
  }
}

final _authRepositotyProv = Provider<ProfileScreenRepository>((ref) {
  return ProfileScreenRepositoryImpl();
});

final profileProvider =
    StateNotifierProvider<ProfileNotifier, UserProfile>((ref) {
  final authRepositoryProvider = ref.read(_authRepositotyProv);
  return ProfileNotifier(authRepositoryProvider);
});
