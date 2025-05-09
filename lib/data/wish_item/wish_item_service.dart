import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/wishlist_item.dart';

class WishItemService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> createItem(WishlistItem item) async {
    await _supabase.from('item').insert({
      'userId': _supabase.auth.currentUser!.id,
      'wishlist_id': item.wishlistId,
      'title': item.title,
      'link': item.url,
      'image_url': item.imageUrl,
      'comments': item.description
    });
  }

  Future<List<WishlistItem>> getItems() async {
    final data = await _supabase.from('item').select().eq(
          'userId',
          _supabase.auth.currentUser!.id,
        );

    return data
        .map((item) => WishlistItem(
              id: item['id'].toString(),
              wishlistId: item['whishlist_id'].toString(),
              title: item['title'] as String,
              description: item['comments'] as String?,
              imageUrl: item['image_urk'] as String?,
              url: item['link'] as String?,
            ))
        .toList();
  }

  Future<void> deleteItem(String id) async {
    await _supabase.from('item').delete().eq('id', id);
  }
}
