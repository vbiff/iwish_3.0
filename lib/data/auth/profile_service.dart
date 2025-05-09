import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/auth/user_profile.dart';

final class ProfileService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<UserProfile> getUserProfile() async {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    final id = user?.id;
    final email = user?.email;
    return UserProfile(id: id!, email: email!);
  }

  Future<void> signOut() async {
    return await _supabase.auth.signOut();
  }
}
