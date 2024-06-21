import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/favourite_models.dart';

final favoriteProvider =
    StateNotifierProvider<FavoriteNotifier, Map<String, FavoriteModel>>(
  (ref) {
    return FavoriteNotifier();
  },
);

class FavoriteNotifier extends StateNotifier<Map<String, FavoriteModel>> {
  FavoriteNotifier() : super({});

  //is to add product to favorite

  void addProductToFavorite({
    required String productName,
    required String productId,
    required List imageUrl,
    required int productPrice,
  }) {
    state[productId] = FavoriteModel(
        productName: productName,
        productId: productId,
        imageUrl: imageUrl,
        productPrice: productPrice);

    //notify listeners that the state has changed

    state = {...state};
  }

  //remove all item from favorite

  void removeAllItem() {
    state.clear();

    //notify listeners that the state has changed

    state = {...state};
  }

//remove favorite item

  void removeItem(String productId) {
    state.remove(productId);

    //notify listeners that the state has changed

    state = {...state};
  }

//retrive value from the state object
  Map<String, FavoriteModel> get getFavoriteItem => state;
}
