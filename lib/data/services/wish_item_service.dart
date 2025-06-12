import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/utils/logger.dart';
import '../../domain/core/result.dart';
import '../../domain/failures/failure.dart';
import '../../domain/models/wishlist_item.dart';

class WishItemService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<Result<void, Failure>> createItem(WishlistItem item) async {
    try {
      await _supabase.from('item').insert({
        'userId': _supabase.auth.currentUser!.id,
        'wishlist_id': item.wishlistId,
        'title': item.title,
        'link': item.url,
        'image_url': item.imageUrl,
        'comments': item.description
      });
      AppLogger.info('Successfully created item: ${item.title}');
      return const Success(null);
    } on PostgrestException catch (e) {
      AppLogger.error('Database error creating item', e);
      return Error(ServerFailure('Failed to create item: ${e.message}'));
    } on AuthException catch (e) {
      AppLogger.error('Auth error creating item', e);
      return Error(AuthFailure('Authentication failed: ${e.message}'));
    } catch (e) {
      AppLogger.error('Unknown error creating item', e);
      return Error(UnknownFailure('An unexpected error occurred'));
    }
  }

  Future<Result<List<WishlistItem>, Failure>> getItems() async {
    try {
      final data = await _supabase.from('item').select().eq(
            'userId',
            _supabase.auth.currentUser!.id,
          );

      final items = data
          .map((item) => WishlistItem(
                id: item['id'].toString(),
                wishlistId: item['wishlist_id']?.toString(),
                title: item['title'] as String,
                description: item['comments'] as String?,
                imageUrl: item['image_url'] as String?,
                url: item['link'] as String?,
              ))
          .toList();

      AppLogger.info('Successfully fetched ${items.length} items');
      return Success(items);
    } on PostgrestException catch (e) {
      AppLogger.error('Database error fetching items', e);
      return Error(ServerFailure('Failed to fetch items: ${e.message}'));
    } on AuthException catch (e) {
      AppLogger.error('Auth error fetching items', e);
      return Error(AuthFailure('Authentication failed: ${e.message}'));
    } catch (e) {
      AppLogger.error('Unknown error fetching items', e);
      return Error(UnknownFailure('An unexpected error occurred'));
    }
  }

  Future<Result<void, Failure>> updateItem(WishlistItem item) async {
    try {
      await _supabase.from('item').update({
        'wishlist_id': item.wishlistId,
        'title': item.title,
        'link': item.url,
        'image_url': item.imageUrl,
        'comments': item.description
      }).eq('id', item.id!);

      AppLogger.info('Successfully updated item: ${item.title}');
      return const Success(null);
    } on PostgrestException catch (e) {
      AppLogger.error('Database error updating item', e);
      return Error(ServerFailure('Failed to update item: ${e.message}'));
    } on AuthException catch (e) {
      AppLogger.error('Auth error updating item', e);
      return Error(AuthFailure('Authentication failed: ${e.message}'));
    } catch (e) {
      AppLogger.error('Unknown error updating item', e);
      return Error(UnknownFailure('An unexpected error occurred'));
    }
  }

  Future<Result<void, Failure>> deleteItem(String id) async {
    try {
      await _supabase.from('item').delete().eq('id', id);
      AppLogger.info('Successfully deleted item with id: $id');
      return const Success(null);
    } on PostgrestException catch (e) {
      AppLogger.error('Database error deleting item', e);
      return Error(ServerFailure('Failed to delete item: ${e.message}'));
    } on AuthException catch (e) {
      AppLogger.error('Auth error deleting item', e);
      return Error(AuthFailure('Authentication failed: ${e.message}'));
    } catch (e) {
      AppLogger.error('Unknown error deleting item', e);
      return Error(UnknownFailure('An unexpected error occurred'));
    }
  }
}
