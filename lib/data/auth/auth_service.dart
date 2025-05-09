import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/auth/user_profile.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

// SignIn
  Future<UserProfile> signInWithEmailPassord(
      String email, String password) async {
    await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    final id = user?.id;
    final eMail = user?.email;

    return UserProfile(id: id!, email: eMail!);
  }

// SignUp
  Future<UserProfile> signUpWithEmailPassord(
      String email, String password) async {
    await _supabase.auth.signUp(
      email: email,
      password: password,
    );
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    final id = user?.id;
    final eMail = user?.email;

    return UserProfile(id: id!, email: eMail!);
  }
// SignOut
}
