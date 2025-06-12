import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_wish/data/repository/auth_repository/profile_repository_impl.dart';
import 'package:i_wish/domain/models/auth/user_profile.dart';
import 'package:i_wish/domain/repository/auth_repository/profile_repository.dart';

import '../../../../data/services/auth/profile_service.dart';
import 'profile_notifier.dart';

final profileServiceProvider = Provider<ProfileService>((ref) {
  return ProfileService();
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(
      profileService: ref.read(profileServiceProvider));
});

final profileProvider =
    StateNotifierProvider<ProfileNotifier, UserProfile>((ref) {
  final authRepositoryProvider = ref.read(profileRepositoryProvider);
  return ProfileNotifier(authRepositoryProvider);
});
