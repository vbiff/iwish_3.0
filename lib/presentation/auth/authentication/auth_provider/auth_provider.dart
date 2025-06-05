import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_wish/data/repository/auth/auth_repository_impl.dart';
import 'package:i_wish/domain/models/auth/user_profile.dart';
import 'package:i_wish/domain/repository/auth/auth_repository.dart';

import '../../../../data/services/auth/auth_service.dart';
import 'auth_notifier.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authRepositoryProvider = Provider<AuthScreenRepository>((ref) {
  return AuthScreenRepositoryImpl(authService: ref.read(authServiceProvider));
});

final authProvider = StateNotifierProvider<AuthNotifier, UserProfile>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return AuthNotifier(repository);
});
