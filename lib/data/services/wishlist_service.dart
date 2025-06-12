import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/core/result.dart';
import '../../domain/failures/failure.dart';
import '../../domain/models/wishlists.dart';
import '../model/wishlist_model.dart';

class WishlistService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<Result<List<Wishlist>, Failure>> getWishlists() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return Error(AuthFailure('User not authenticated'));
      }

      final data =
          await _supabase.from('wishlist').select().eq('user_id', userId);
      final wishlists = data.map((e) => WishlistModel.fromJson(e)).toList();
      return Success(wishlists.map((e) => e.toEntity()).toList());
    } on PostgrestException catch (e) {
      return Error(ServerFailure('Failed to get wishlists: ${e.message}'));
    }
  }

  Future<Result<void, Failure>> createWishlist(Wishlist wishlist) async {
    try {
      final result = await _supabase
          .from('wishlist')
          .insert(WishlistModel.fromEntity(wishlist).toJson())
          .select();
      print('Wishlist created successfully: $result');
      return Success(null);
    } on PostgrestException catch (e) {
      print('Failed to create wishlist: ${e.message}');
      return Error(ServerFailure('Failed to create wishlist: ${e.message}'));
    }
  }

  Future<Result<void, Failure>> updateWishlist(Wishlist wishlist) async {
    try {
      await _supabase.from('wishlist').update({
        'title': wishlist.title,
        'color': wishlist.color.value,
      }).eq('id', wishlist.id);
      return Success(null);
    } on PostgrestException catch (e) {
      return Error(ServerFailure('Failed to update wishlist: ${e.message}'));
    }
  }

  Future<Result<void, Failure>> deleteWishlist(String id) async {
    try {
      await _supabase.from('wishlist').delete().eq('id', id);
      return Success(null);
    } on PostgrestException catch (e) {
      return Error(ServerFailure('Failed to delete wishlist: ${e.message}'));
    }
  }
}
