import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_wish/data/dummy/list_wishlists.dart';

final wishItemProvider = Provider((ref) {
  return wishlistItems;
});
