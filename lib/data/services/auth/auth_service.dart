import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../domain/models/auth/user_profile.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

// SignIn
  Future<UserProfile> signInWithEmailPassord(
      String email, String password) async {
    print('[AUTH SERVICE] Starting Supabase sign in for: $email');

    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      print('[AUTH SERVICE] Supabase response: ${response.user?.email}');

      final session = _supabase.auth.currentSession;
      final user = session?.user;
      final id = user?.id;
      final eMail = user?.email;

      print('[AUTH SERVICE] Session created - ID: $id, Email: $eMail');

      return UserProfile(id: id!, email: eMail!);
    } catch (e) {
      print('[AUTH SERVICE] Supabase sign in error: $e');
      rethrow;
    }
  }

// SignUp
  Future<UserProfile> signUpWithEmailPassord(
      String email, String password) async {
    print('[AUTH SERVICE] Starting Supabase sign up for: $email');

    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      print('[AUTH SERVICE] Supabase signup response: ${response.user?.email}');

      final session = _supabase.auth.currentSession;
      final user = session?.user;
      final id = user?.id;
      final eMail = user?.email;

      print('[AUTH SERVICE] Session created - ID: $id, Email: $eMail');

      return UserProfile(id: id!, email: eMail!);
    } catch (e) {
      print('[AUTH SERVICE] Supabase sign up error: $e');
      rethrow;
    }
  }
// SignOut
}
