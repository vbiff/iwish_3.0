import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../domain/models/auth/user_profile.dart';

final class ProfileService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<UserProfile> getUserProfile() async {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    final id = user?.id;
    final email = user?.email;
    final avatarUrl = user?.userMetadata?['avatar_url'] as String?;

    return UserProfile(
      id: id!,
      email: email!,
      avatarPhoto: avatarUrl,
    );
  }

  Future<void> signOut() async {
    return await _supabase.auth.signOut();
  }

  Future<String> updateProfilePhoto(String imagePath) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final file = File(imagePath);
    final fileName =
        '${user.id}/avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';

    // Upload image to Supabase Storage
    try {
      final response =
          await _supabase.storage.from('avatars').upload(fileName, file);
      print('Upload response: $response');
    } catch (e) {
      print('Upload error: $e');
      throw Exception('Failed to upload image: $e');
    }

    // Get public URL
    final publicUrl = _supabase.storage.from('avatars').getPublicUrl(fileName);

    // Update user metadata with avatar URL
    final updateResult = await _supabase.auth.updateUser(
      UserAttributes(
        data: {'avatar_url': publicUrl},
      ),
    );

    // Wait a bit for the metadata to be updated
    await Future.delayed(const Duration(milliseconds: 500));

    return publicUrl;
  }
}
